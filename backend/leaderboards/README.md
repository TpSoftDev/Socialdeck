# Prompt’d leaderboard scoring

Implemented locally; not deployed or connected to live voting yet. No screen visuals changed.

## Rules
- Vote reward: `5 * votes * (votes + 1)` (10 + 20 + 30...).
- Only the loser is penalized: `10 * (opponentVotes - ownVotes)`.
- New cumulative total: `max(0, previous + reward - penalty)`.
- Equal votes have no penalty. Ranking compares cumulative points, then totalVotes, then matchWins (all descending). Only equal values in all three share a dense rank (1,1,2,3); alphabetical names order those shared places. Player ID breaks identical-name ordering only. A tied matchup is not a win.
- Each player appears at most once per round. A player with a bye keeps their total. If gameplay allows multiple matches per player per round, agree on aggregation/floor timing before changing this contract.

## Callable boundary
`finalizePromptdRound({gameId, round})` in `us-central1`. Any authenticated game participant may request it. The server reads trusted finalized vote results; clients cannot supply counts or scores. A Firestore transaction stores the result and cumulative totals atomically. Retrying returns the original snapshot, without another award. No voting collection logic lives here.

## Handoff required from game/voting owners
Trusted backend code creates a unique game ID per game and writes:

`promptdGames/{gameId}`:
```json
{"playerIds":["a","b"],"players":[{"playerId":"a","playerName":"Amy","points":0,"totalVotes":0,"matchWins":0},{"playerId":"b","playerName":"Ben","points":0,"totalVotes":0,"matchWins":0}],"status":"playing","currentRound":1,"lastScoredRound":0,"totalRounds":3}
```

`promptdGames/{gameId}/finalizedVotes/{round}`:
```json
{"gameId":"GAME_ID","round":1,"status":"finalized","matches":[{"sides":[{"playerId":"a","votes":3},{"playerId":"b","votes":2}]}]}
```

The voting owner must validate eligible voters, duplicate votes, deadlines, matchups, and completeness before publishing immutable finalized counts through trusted server code. This is a proposed integration contract, not a claim that their backend already exists. Keep `playerIds` consistent with `players`.

Our callable writes `roundResults/{round}` (standings, per-player awards and scoring version), then changes game status to `round-results` or `final-results`. Gameplay owns advancing the next round. Existing standings mapper can consume returned playerId/playerName/points/rank fields. App wiring waits for the live game controller; Dev Tools remains sample data.

## Security and deployment
Scoped rules in the root `firestore.rules` deny all client writes to games, finalized vote inputs and results. Only participants may read round results. Admin SDK bypasses these rules: trusted writers must be correct. App Check is not enforced yet; enable it once the mobile client is configured. Authentication does not replace App Check.

Run `npm ci` then `npm test` here. From repository root, deploy only this codebase using `firebase deploy --only functions:leaderboards --config firebase.leaderboards.json --project socialdeck-dev`. Review/merge the new scoped rules into the project's actual deployed rules before deploying rules; do not overwrite teammates' production rules blindly. Existing AI functions are in a different codebase and are not part of this deployment.

## Still needed
- Game lifecycle and trusted voting producer integration, Flutter callable invocation and results subscription.
- Independent server final-animation deadline/cleanup and lobby return. This change does NOT yet delete temporary scores; do not treat it as a completed live-game lifecycle.
- Cloud/mobile end-to-end test before deployment. Local emulator security-rule and concurrent transaction tests now pass.

The tests cover score arithmetic, cumulative floors, ties, malformed inputs, authentication, round order, retries and transition to final results. Transaction tests use an in-memory serialized test double, not live Firestore.

## Verified callable emulator test
Run from the repository root with Java 21+ and Firebase CLI installed:
```
firebase emulators:exec --project demo-socialdeck-scoring --config firebase.leaderboards-test.json --only auth,firestore,functions "node backend/leaderboards/integration/emulator.mjs"
```
Uses local Auth, Functions and Firestore only. Tests eight players, three rounds, five concurrent requests per round, saved scores, invalid requests, and Firestore access rules. Output: `backend/leaderboards/integration/results.json`. The fixture writes finalized counts as the trusted voting backend would; it does not implement or test actual vote collection. Local run used Node 24, while deployment is configured for Node 22. No deployment performed.

## Ranking update
Scoring version `increasing-votes-linear-loss-v2` persists totalVotes and matchWins with points in the same transaction. Every fresh game must initialize both counters to zero. Old in-progress fixtures without these fields must be recreated or have history reconstructed by trusted backend code; missing history is rejected rather than silently reset. Previously finalized round snapshots stay immutable on retries. Do not switch ranking versions in a live game. Existing UI rank/color mapping still consumes the server rank; explanatory vote/win labels in the app are a future frontend task.
