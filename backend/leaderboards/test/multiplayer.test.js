import test from 'node:test';
import assert from 'node:assert/strict';
import {scenarios} from './scenarios.js';
test('8 players across three rounds: exact cumulative totals',()=>{
  const rounds=scenarios()[0].rounds;
  assert.deepEqual(rounds.map(r=>Object.fromEntries(r.standings.map(p=>[p.playerName,p.points]))),[
    {Hugo:210,Amy:150,Eli:100,Cal:60,Dana:60,Fay:10,Ben:0,Gia:0},
    {Fay:220,Cal:210,Hugo:150,Amy:120,Eli:110,Gia:100,Ben:60,Dana:120},
    {Cal:270,Fay:280,Amy:220,Ben:210,Eli:210,Dana:130,Hugo:160,Gia:70}
  ]);
});
test('all scenarios preserve players, dense ranks, zero floor and arithmetic',()=>{
  for(const s of scenarios()) for(const r of s.rounds){
    assert.equal(r.standings.length,s.count);
    assert.equal(new Set(r.standings.map(p=>p.playerId)).size,s.count);
    for(const a of r.awards) assert.equal(a.points,Math.max(0,a.previous+a.earned-a.penalty));
    const distinct=[...new Set(r.standings.map(p=>`${p.points}/${p.totalVotes}/${p.matchWins}`))];
    for(const p of r.standings) {assert.ok(p.points>=0);assert.equal(p.rank,distinct.indexOf(`${p.points}/${p.totalVotes}/${p.matchWins}`)+1);}
  }
});
test('zero-vote game ties everyone first in alphabetical order',()=>{
  const board=scenarios()[3].rounds[0].standings;
  assert.deepEqual(board.map(p=>[p.playerName,p.points,p.rank]),[['Amy',0,1],['Ben',0,1],['Cal',0,1],['Dana',0,1]]);
});
test('bye preserves score without generating an award',()=>{
  const round=scenarios()[2].rounds[1];
  assert.equal(round.standings.find(p=>p.playerName==='Dana').points,60);
  assert.ok(!round.awards.some(p=>p.playerId==='3'));
});
