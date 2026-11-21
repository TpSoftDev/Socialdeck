// IA: Pure scoring; voting collection and eligibility belong to the voting backend.
export class ScoringError extends Error {
  constructor(code, message) { super(message); this.code = code; }
}
const requireValue = (ok, message) => {
  if (!ok) throw new ScoringError('failed-precondition', message);
};
const nonnegative = (n) => Number.isSafeInteger(n) && n >= 0;
export function voteReward(votes) {
  requireValue(nonnegative(votes), 'Votes must be nonnegative integers.');
  const reward = 5 * votes * (votes + 1);
  requireValue(Number.isSafeInteger(reward), 'Vote reward is too large.');
  return reward;
}
export function calculateRound(players, matches) {
  requireValue(Array.isArray(players) && players.length >= 2 && players.length <= 8,
    'Expected 2 to 8 game players.');
  const totals = new Map();
  for (const player of players) {
    requireValue(typeof player.playerId === 'string' && player.playerId.length > 0 &&
      typeof player.playerName === 'string' && nonnegative(player.points) &&
      nonnegative(player.totalVotes) && nonnegative(player.matchWins) &&
      !totals.has(player.playerId), 'Invalid or duplicate player.');
    totals.set(player.playerId, {playerId: player.playerId,
      playerName: player.playerName, points: player.points,
      totalVotes: player.totalVotes, matchWins: player.matchWins});
  }
  requireValue(Array.isArray(matches) && matches.length > 0 && matches.length <= 4,
    'Expected finalized head-to-head matches.');
  const seen = new Set();
  const awards = [];
  for (const match of matches) {
    requireValue(Array.isArray(match.sides) && match.sides.length === 2,
      'Each match needs two sides.');
    for (let i = 0; i < 2; i++) {
      const side = match.sides[i];
      const opponent = match.sides[1 - i];
      requireValue(totals.has(side.playerId) && !seen.has(side.playerId),
        'Unknown or repeated player in round.');
      const earned = voteReward(side.votes);
      voteReward(opponent.votes);
      const penalty = Math.max(0, opponent.votes - side.votes) * 10;
      const player = totals.get(side.playerId);
      const previous = player.points;
      const raw = previous + earned - penalty;
      requireValue(Number.isSafeInteger(raw), 'Score is too large.');
      player.points = Math.max(0, raw);
      // IA: Persist tie-break totals alongside points; tied matches are not wins.
      player.totalVotes += side.votes;
      player.matchWins += side.votes > opponent.votes ? 1 : 0;
      requireValue(nonnegative(player.totalVotes) && nonnegative(player.matchWins),
        'Ranking totals are too large.');
      seen.add(side.playerId);
      awards.push({playerId: side.playerId, votes: side.votes, earned, penalty,
        previous, points: player.points, change: player.points - previous});
    }
  }
  // IA: Players without a matchup (e.g. a bye) keep their prior total.
  const compareNames = new Intl.Collator('en', {sensitivity: 'base'});
  const standings = [...totals.values()].sort((a, b) =>
    b.points - a.points || b.totalVotes - a.totalVotes ||
    b.matchWins - a.matchWins || compareNames.compare(a.playerName, b.playerName) ||
    (a.playerId < b.playerId ? -1 : a.playerId > b.playerId ? 1 : 0));
  let rank = 0;
  let previous;
  for (const player of standings) {
    if (!previous || player.points !== previous.points ||
        player.totalVotes !== previous.totalVotes || player.matchWins !== previous.matchWins) rank++;
    player.rank = rank;
    previous = player;
  }
  return {standings, awards, scoringVersion: 'increasing-votes-linear-loss-v2'};
}
