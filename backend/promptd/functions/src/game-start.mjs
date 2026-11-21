// IA: Server-authoritative local Start integration; clients never supply profiles/rosters/prompts.
import {randomUUID} from 'node:crypto';
import {buildGameplayJob} from './gameplay.mjs';
import {fail} from './errors.mjs';
const partyKey=id=>`parties/${id}`;
const runtimeKey=id=>`${partyKey(id)}/promptdRuntime/current`;
function checkId(id){if(typeof id!=='string'||!/^\d{6}$/.test(id))fail('invalid-argument','Invalid party code.');}
export class GameStartService {
 constructor(db,clock=Date.now){this.db=db;this.clock=clock;}
 async start(uid,partyId){
  if(!uid)fail('unauthenticated','Sign in.');checkId(partyId);
  const gameId=randomUUID();
  return this.db.runTransaction(async tx=>{
   const pRef=this.db.doc(partyKey(partyId)),rRef=this.db.doc(runtimeKey(partyId));
   const [pDoc,rDoc,setupDoc]=await tx.getAll(pRef,rRef,this.db.doc(`${partyKey(partyId)}/aiSetup/current`));
   const p=pDoc.data(),runtime=rDoc.data(),setup=setupDoc.data();
   if(!p||p.hostId!==uid||!p.memberIds.includes(uid))fail('permission-denied','Only the current party host can start.');
   if(p.phase==='playing'&&runtime)return {gameId:runtime.gameId};
   if(p.phase!=='lobby'||p.game?.id!=='promptd')fail('failed-precondition','This party is not ready to start.');
   const ids=p.memberIds;
   if(![4,6,8].includes(ids.length))fail('failed-precondition','AI gameplay currently needs 4, 6 or 8 players.');
   if(new Set(ids).size!==ids.length||!ids.every(id=>p.members[id]?.ready&&p.members[id].cardCount===7&&p.members[id].selectionRevision===p.revision))fail('failed-precondition','Every player must pick seven cards and be ready.');
   if(!setup||setup.revision!==p.revision||!setup.sessionId)fail('failed-precondition','Save the approved AI setup before starting.');
   const sessionDoc=await tx.get(this.db.doc(`promptdSessions/${setup.sessionId}`));
   const record=sessionDoc.data(),session=record?.value;
   if(!session||record.expiresAt.toMillis()<=this.clock()||session.owner!==setup.savedBy||session.prompts.length!==5||!session.prompts.every(p=>session.feedback.some(f=>f.promptId===p.id&&f.accepted)))fail('failed-precondition','The approved AI session has expired or is incomplete. Ask the host to save AI setup again.');
   if(session.profile.safeMode!==p.game.safeMode||setup.settings.rounds!==p.game.rounds)fail('failed-precondition','AI settings changed. Save setup again.');
   const job=buildGameplayJob({gameId,playerIds:ids,rounds:p.game.rounds,session},this.clock());
   tx.create(this.db.doc(`promptdGameplay/${gameId}`),{value:job,expiresAt:new Date(this.clock()+86400000)});
   tx.create(this.db.doc(`promptdRuntimeJobs/${gameId}`),{partyId,status:'queued',createdAt:this.clock()});
   tx.set(rRef,{gameId,startedAt:this.clock(),currentRound:1});
   tx.update(pRef,{phase:'playing',updatedAt:new Date(this.clock())});
   return {gameId};
  });
 }
 async status(uid,partyId){
  if(!uid)fail('unauthenticated','Sign in.');checkId(partyId);
  // IA: Transaction keeps membership/current game consistent; unrevealed rounds stay private.
  return this.db.runTransaction(async tx=>{
   const [pDoc,rDoc]=await tx.getAll(this.db.doc(partyKey(partyId)),this.db.doc(runtimeKey(partyId)));
   const p=pDoc.data(),r=rDoc.data();
   if(!p||!p.memberIds.includes(uid)||p.phase==='closed')fail('permission-denied','You are no longer in this party.');
   if(p.phase!=='playing'||!r)return {phase:'lobby',serverNow:this.clock()};
   const snap=await tx.get(this.db.doc(`promptdGameplay/${r.gameId}`));const job=snap.data()?.value;
   if(!job)fail('failed-precondition','Game preparation is unavailable.');
   const result={gameId:r.gameId,phase:job.status,startedAt:r.startedAt,serverNow:this.clock(),readyRounds:job.ready.length,totalRounds:job.rounds,currentRound:r.currentRound,canRetry:p.hostId===uid&&job.status==='failed'};
   // IA: Temporary local pairing contract only. Replace with the gameplay team's authoritative schedule.
   // Round 1 pairs first/last, second/second-last; both opponents get the same slot.
   const index=job.playerIds.indexOf(uid),slot=Math.min(index,job.playerIds.length-1-index);
   if(index<0)fail('permission-denied','You were not in this game roster.');
   // IA: Generation readiness has no presentation delay; the frontend owns countdown/reveal timing.
   if(job.ready[r.currentRound-1]){
    result.prompt=job.ready[r.currentRound-1].prompts[slot];
    result.opponent=p.members[job.playerIds[job.playerIds.length-1-index]]?.name??'Opponent';
   }
   return result;
  });
 }
 async retry(uid,partyId){
  checkId(partyId);
  return this.db.runTransaction(async tx=>{
   const [pDoc,rDoc]=await tx.getAll(this.db.doc(partyKey(partyId)),this.db.doc(runtimeKey(partyId)));
   const p=pDoc.data(),r=rDoc.data();if(!uid||!p||p.hostId!==uid||p.phase!=='playing'||!r)fail('permission-denied','Only the current host can retry.');
   const ref=this.db.doc(`promptdGameplay/${r.gameId}`),snap=await tx.get(ref),record=snap.data();
   if(record?.value.status!=='failed')fail('failed-precondition','Preparation does not need a retry.');
   record.value.status='preparing';record.value.failureCount=0;delete record.value.lastError;
   tx.set(ref,record);tx.update(this.db.doc(`promptdRuntimeJobs/${r.gameId}`),{status:'queued'});return {gameId:r.gameId};
  });
 }
}
