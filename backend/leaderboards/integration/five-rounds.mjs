import assert from 'node:assert/strict';
import {initializeApp} from 'firebase-admin/app';
import {getFirestore} from 'firebase-admin/firestore';
import {writeFileSync} from 'node:fs';
const project='demo-socialdeck-scoring';
assert.equal(process.env.GCLOUD_PROJECT,project);
assert.ok(process.env.FIRESTORE_EMULATOR_HOST && process.env.FIREBASE_AUTH_EMULATOR_HOST,
  'Emulators required; never run against real data.');
initializeApp({projectId:project});const db=getFirestore();
const names=['Amy','Ben','Cal','Dana','Eli','Fay','Gia','Hugo'];
const users=[];
for(const name of [...names,'Outsider']) {
 const response=await fetch(`http://${process.env.FIREBASE_AUTH_EMULATOR_HOST}/identitytoolkit.googleapis.com/v1/accounts:signUp?key=demo-key`,{
 method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({email:`${name.toLowerCase()}@example.test`,password:'Emulator-only-123!',returnSecureToken:true})});
 const body=await response.json();assert.ok(body.idToken);users.push({uid:body.localId,token:body.idToken});
}
const call=async(data,token=users[0].token)=>{
 const res=await fetch(`http://127.0.0.1:5108/${project}/us-central1/finalizePromptdRound`,{method:'POST',headers:{'content-type':'application/json',...(token?{authorization:`Bearer ${token}`}:{})},body:JSON.stringify({data})});
 return res.json();
};
const denied=async(data,token,status)=>assert.equal((await call(data,token)).error?.status,status);
const match=(a,b,av,bv)=>({sides:[{playerId:users[a].uid,votes:av},{playerId:users[b].uid,votes:bv}]});
const rounds=[
 [match(0,1,5,1),match(2,3,3,3),match(4,5,4,2),match(6,7,0,6)],
 [match(0,2,1,5),match(1,3,3,3),match(4,6,2,4),match(5,7,6,0)],
 [match(0,7,4,2),match(1,6,5,1),match(2,5,3,3),match(3,4,2,4)],
 [match(0,3,3,3),match(1,4,4,2),match(2,7,5,1),match(5,6,2,4)],
 [match(0,4,2,4),match(1,5,3,3),match(2,6,1,5),match(3,7,6,0)]];
const gameId='integration-eight';const ref=db.doc(`promptdGames/${gameId}`);
await ref.set({players:names.map((playerName,i)=>({playerId:users[i].uid,playerName,points: 0, totalVotes:0, matchWins:0})),playerIds:users.slice(0,8).map(u=>u.uid),status:'playing',currentRound:1,lastScoredRound:0,totalRounds:5});
await denied({gameId,round:1},null,'UNAUTHENTICATED');
await denied({gameId,round:1},users[8].token,'PERMISSION_DENIED');
await denied({gameId,round:1,votes:999},users[0].token,'INVALID_ARGUMENT');
await denied({gameId,round:2},users[0].token,'FAILED_PRECONDITION');
await denied({gameId,round:1},users[0].token,'FAILED_PRECONDITION');
const boards=[];
for(let i=0;i<5;i++) {
 const round=i+1;
 if(i)await ref.update({currentRound:round,status:'playing'});
 // Fixture substitutes for teammates' trusted voting backend; no voting implementation changed.
 await ref.collection('finalizedVotes').doc(String(round)).set({gameId,round,status:'finalized',matches:rounds[i]});
 const requests=await Promise.all(Array.from({length:5},(_,n)=>call({gameId,round},users[n].token)));
 requests.forEach(r=>{assert.ok(r.result,JSON.stringify(r));assert.deepEqual(r.result,requests[0].result);});
 const result=requests[0].result;boards.push(result.standings.map(p=>({name:p.playerName,points:p.points,totalVotes:p.totalVotes,matchWins:p.matchWins,rank:p.rank})));
 const persisted=(await ref.get()).data();assert.deepEqual(persisted.players,result.standings);
 assert.equal(persisted.lastScoredRound,round);
 assert.equal(persisted.status,round===5?'final-results':'round-results');
 assert.equal((await ref.collection('roundResults').get()).size,round);
}
assert.deepEqual(boards[4].map(p=>[p.name,p.points,p.rank]),[['Dana',400,1],['Cal',390,2],['Ben',370,3],['Fay',350,4],['Eli',320,5],['Gia',320,6],['Amy',290,7],['Hugo',70,8]]);
const rest=`http://${process.env.FIRESTORE_EMULATOR_HOST}/v1/projects/${project}/databases/(default)/documents/promptdGames/${gameId}`;
const get=async(url,token)=>fetch(url,{headers:{authorization:`Bearer ${token}`}});
assert.equal((await get(`${rest}/roundResults/3`,users[0].token)).status,200);
assert.equal((await get(`${rest}/roundResults/3`,users[8].token)).status,403);
assert.equal((await get(`${rest}/finalizedVotes/3`,users[0].token)).status,403);
assert.equal((await fetch(`${rest}/roundResults/3`,{method:'PATCH',headers:{authorization:`Bearer ${users[0].token}`,'content-type':'application/json'},body:JSON.stringify({fields:{round:{integerValue:'99'}}})})).status,403);
assert.equal((await fetch(`${rest}/finalizedVotes/3`,{method:'PATCH',headers:{authorization:`Bearer ${users[0].token}`,'content-type':'application/json'},body:JSON.stringify({fields:{status:{stringValue:'finalized'}}})})).status,403);
await ref.update({status:'ended'});
await denied({gameId,round:3},users[0].token,'FAILED_PRECONDITION');
const report={environment:'Firebase local Auth + Functions + Firestore emulators',boards,passed:['5 rounds / 8 players via callable HTTP','5 simultaneous callers per round: identical results, no duplicate awards','Persisted scores and round transitions','Login, membership, payload and round order checks','Missing finalized votes rejected','Participant read allowed; outsider read denied','Client score and finalized-vote writes denied','Private vote inputs hidden','Ended game rejected'],limitations:['Finalized vote fixtures, not real voting','Not deployed cloud test','Local Node 24; deployment targets Node 22']};
writeFileSync('backend/leaderboards/integration/results-five-rounds.json',JSON.stringify(report,null,2));
console.log(JSON.stringify(report,null,2));await db.terminate();
