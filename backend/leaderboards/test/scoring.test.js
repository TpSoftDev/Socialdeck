import test from 'node:test';
import assert from 'node:assert/strict';
import {calculateRound, voteReward} from '../src/scoring.js';
import {finalizeRound} from '../src/finalize.js';
const players = (a = 0, b = 0) => [
  {playerId: 'a', playerName: 'Zoe', points: a, totalVotes:0, matchWins:0},
  {playerId: 'b', playerName: 'Amy', points: b, totalVotes:0, matchWins:0}];
const matches = (a, b) => [{sides: [{playerId: 'a', votes: a}, {playerId: 'b', votes: b}]}];
test('increasing vote rewards', () => {
  assert.deepEqual([0,1,2,3,4,5].map(voteReward), [0,10,30,60,100,150]);
});
for (const [a,b,expected] of [[3,2,[60,20]], [4,2,[100,10]], [5,1,[150,0]], [3,3,[60,60]], [0,0,[0,0]]]) {
  test(`match ${a}-${b}: rewards, linear penalty and zero floor`, () => {
    const result = calculateRound(players(), matches(a,b));
    assert.deepEqual(result.awards.map(p => p.points), expected);
  });
}
test('floor applies to cumulative total, not to the round change', () => {
  const result = calculateRound(players(20,100), matches(1,5));
  assert.equal(result.awards[0].points, 0);
  assert.equal(result.awards[0].change, -20);
  assert.equal(result.awards[1].points, 250);
  assert.equal(calculateRound(players(100,100), matches(1,5)).awards[0].points,70);
});
test('dense tied ranks, alphabetical names, bye retained', () => {
  const input = [...players(0,0), {playerId:'c',playerName:'Cal',points: 50, totalVotes:0, matchWins:0},
    {playerId:'d',playerName:'Dan',points: 40, totalVotes:0, matchWins:0}];
  const result = calculateRound(input, matches(3,3));
  assert.deepEqual(result.standings.map(p => [p.playerName,p.rank]),
    [['Amy',1],['Zoe',1],['Cal',2],['Dan',3]]);
  assert.equal(input[0].points,0);
});
test('invalid votes, duplicate sides and unknown players rejected', () => {
  for (const value of [-1, 1.5, '3', NaN, Number.MAX_SAFE_INTEGER])
    assert.throws(() => voteReward(value));
  assert.throws(() => calculateRound(players(), [...matches(1,2), ...matches(2,1)]));
  assert.throws(() => calculateRound(players(), [{sides:[{playerId:'x',votes:1},{playerId:'b',votes:2}]}]));
});
function fixture() {
  const records = new Map([
    ['promptdGames/game1', {players:players(),playerIds:['a','b'],status:'playing',
      currentRound:1,lastScoredRound:0,totalRounds:2}],
    ['promptdGames/game1/finalizedVotes/1', {status:'finalized',gameId:'game1',round:1,matches:matches(3,2)}]
  ]);
  const ref = path => ({path,collection: name => ({doc:id=>ref(`${path}/${name}/${id}`)})});
  // Serialized transactions model successful atomic commits; not an emulator concurrency test.
  let queue = Promise.resolve();
  const db = {doc:ref, runTransaction: fn => {
    const call = queue.then(async () => {
      const writes=[];
      const result=await fn({get:async r=>({exists:records.has(r.path),data:()=>structuredClone(records.get(r.path))}),
        create:(r,d)=>writes.push(()=>{assert.ok(!records.has(r.path));records.set(r.path,d);}),
        update:(r,d)=>writes.push(()=>records.set(r.path,{...records.get(r.path),...d}))});
      writes.forEach(w=>w());return result;
    });queue=call.catch(()=>{});return call;
  }};
  return {records,db};
}
const request={gameId:'game1',round:1};
test('retries return identical results without adding scores twice', async () => {
  const {db,records}=fixture();
  const results=await Promise.all([1,2,3].map(()=>finalizeRound(db,'a',request,()=>123)));
  assert.deepEqual(results[0],results[2]);
  assert.equal(records.get('promptdGames/game1').players[0].points,60);
  assert.equal(records.get('promptdGames/game1').lastScoredRound,1);
});
test('second round accumulates and enters final results',async()=>{
  const {db,records}=fixture();
  await finalizeRound(db,'a',request,()=>123);
  const game=records.get('promptdGames/game1');
  game.status='playing';game.currentRound=2;
  records.set('promptdGames/game1/finalizedVotes/2', {status:'finalized',gameId:'game1',round:2,matches:matches(1,5)});
  const result=await finalizeRound(db,'b',{gameId:'game1',round:2},()=>124);
  assert.deepEqual(result.standings.map(p=>[p.playerId,p.points]),[['b',170],['a',30]]);
  assert.equal(records.get('promptdGames/game1').status,'final-results');
});
for (const [name,uid,data,change,code] of [
  ['signed out',null,request,()=>{},'unauthenticated'],
  ['outsider','x',request,()=>{},'permission-denied'],
  ['client vote injection','a',{...request,votes:99},()=>{},'invalid-argument'],
  ['out of order','a',{...request,round:2},()=>{},'failed-precondition'],
  ['unfinished votes','a',request,r=>r.get('promptdGames/game1/finalizedVotes/1').status='open','failed-precondition'],
  ['ended game','a',request,r=>r.get('promptdGames/game1').status='ended','failed-precondition'],
]) test(name,async()=>{
  const {db,records}=fixture();change(records);
  await assert.rejects(finalizeRound(db,uid,data,()=>123),e=>e.code===code);
  assert.equal(records.has('promptdGames/game1/roundResults/1'),false);
});

// IA: No-vote tied matchup leaves totals unchanged, isolating ranking priorities.
const rankPlayers = (...stats) => calculateRound(stats.map(([points,totalVotes,matchWins],i)=>({
  playerId:String(i),playerName:['Zoe','Amy'][i],points,totalVotes,matchWins
})), [{sides:[{playerId:'0',votes:0},{playerId:'1',votes:0}]}]).standings;
test('points take priority over votes and wins',()=>{
  assert.equal(rankPlayers([100,1,0],[90,20,5])[0].playerId,'0');
});
test('votes break equal points before match wins',()=>{
  assert.equal(rankPlayers([100,12,1],[100,10,4])[0].playerId,'0');
});
test('wins break equal points and votes',()=>{
  const rows=rankPlayers([100,12,3],[100,12,2]);
  assert.deepEqual(rows.map(p=>[p.playerId,p.rank]),[['0',1],['1',2]]);
});
test('all three equal share place alphabetically',()=>{
  assert.deepEqual(rankPlayers([100,12,3],[100,12,3]).map(p=>[p.playerName,p.rank]),[['Amy',1],['Zoe',1]]);
});
test('vote and win totals accumulate, tied matches add no wins',()=>{
  let result=calculateRound(players(),matches(4,2));
  result=calculateRound(result.standings,matches(3,3));
  assert.deepEqual(result.standings.map(p=>[p.playerId,p.totalVotes,p.matchWins]),[['a',7,1],['b',5,0]]);
});
test('missing or invalid tie-break history rejected instead of silently reset',()=>{
  for(const value of [undefined,-1,1.5,'2']) {
    const input=players();input[0].totalVotes=value;
    assert.throws(()=>calculateRound(input,matches(1,1)));
  }
});
