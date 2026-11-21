import {calculateRound, ScoringError} from './scoring.js';
const fail = (code, message) => { throw new ScoringError(code, message); };
// IA: Injectable transaction service keeps authorization/idempotence testable.
export async function finalizeRound(db, uid, data, timestamp) {
  if (!uid) fail('unauthenticated', 'Sign in first.');
  if (!data || Object.keys(data).some(k => !['gameId', 'round'].includes(k)) ||
      typeof data.gameId !== 'string' || !/^[A-Za-z0-9_-]{1,128}$/.test(data.gameId) ||
      !Number.isInteger(data.round) || data.round < 1 || data.round > 5) {
    fail('invalid-argument', 'Supply only gameId and round (1 to 5).');
  }
  const gameRef = db.doc(`promptdGames/${data.gameId}`);
  const resultRef = gameRef.collection('roundResults').doc(String(data.round));
  const votesRef = gameRef.collection('finalizedVotes').doc(String(data.round));
  return db.runTransaction(async tx => {
    const gameDoc = await tx.get(gameRef);
    if (!gameDoc.exists) fail('not-found', 'Game not found.');
    const game = gameDoc.data();
    if (!Array.isArray(game.players) || !game.players.some(p => p.playerId === uid))
      fail('permission-denied', 'You are not a game participant.');
    if (!['playing', 'round-results', 'final-results'].includes(game.status))
      fail('failed-precondition', 'Game is not active.');
    const result = await tx.get(resultRef);
    // IA: Return the same snapshot on retries; never apply this round twice.
    if (result.exists) return result.data();
    if (!Number.isInteger(game.lastScoredRound) || data.round !== game.lastScoredRound + 1 ||
        data.round !== game.currentRound || !Number.isInteger(game.totalRounds) ||
        game.totalRounds < 1 || game.totalRounds > 5 || data.round > game.totalRounds ||
        game.status !== 'playing') fail('failed-precondition', 'Round is not ready to score.');
    const votesDoc = await tx.get(votesRef);
    if (!votesDoc.exists) fail('failed-precondition', 'Finalized votes are not ready.');
    const votes = votesDoc.data();
    if (votes.status !== 'finalized' || votes.gameId !== data.gameId || votes.round !== data.round)
      fail('failed-precondition', 'Vote results do not match this round.');
    const calculated = calculateRound(game.players, votes.matches);
    const snapshot = {...calculated, gameId: data.gameId, round: data.round};
    tx.create(resultRef, snapshot);
    tx.update(gameRef, {players: calculated.standings, lastScoredRound: data.round,
      status: data.round === game.totalRounds ? 'final-results' : 'round-results',
      updatedAt: timestamp()});
    return snapshot;
  });
}
