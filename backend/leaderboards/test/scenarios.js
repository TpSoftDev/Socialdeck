import {calculateRound} from '../src/scoring.js';
const names=['Amy','Ben','Cal','Dana','Eli','Fay','Gia','Hugo'];
const match=(a,b,av,bv)=>({sides:[{playerId:String(a),votes:av},{playerId:String(b),votes:bv}]});
export function scenarios() {
  return [
    {name:'8 players · 3 rounds',count:8,rounds:[
      [match(0,1,5,1),match(2,3,3,3),match(4,5,4,2),match(6,7,0,6)],
      [match(0,2,1,5),match(1,3,3,3),match(4,6,2,4),match(5,7,6,0)],
      [match(0,7,4,2),match(1,6,5,1),match(2,5,3,3),match(3,4,2,4)]]},
    {name:'4 players · shared places and changing leaders',count:4,rounds:[
      [match(0,1,1,1),match(2,3,1,1)],
      [match(0,2,2,0),match(1,3,1,1)],
      [match(0,3,0,2),match(1,2,2,0)]]},
    {name:'5 players · a bye keeps the previous score',count:5,rounds:[
      [match(0,1,2,1),match(2,3,0,3)],
      [match(0,4,1,2),match(1,2,3,0)]]},
    {name:'4 players · nobody votes',count:4,rounds:[
      [match(0,1,0,0),match(2,3,0,0)]]}
  ].map(s=>{
    let players=names.slice(0,s.count).map((playerName,i)=>({playerId:String(i),playerName,points: 0, totalVotes:0, matchWins:0}));
    return {...s,rounds:s.rounds.map((matches,i)=>{
      const result=calculateRound(players,matches);players=result.standings;
      return {round:i+1,matches,...result};
    })};
  });
}
