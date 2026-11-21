import assert from 'node:assert/strict';
import {initializeApp} from 'firebase-admin/app';
import {getFirestore} from 'firebase-admin/firestore';
if(process.env.GCLOUD_PROJECT!=='demo-socialdeck-gameplay'||process.env.FIRESTORE_EMULATOR_HOST!=='127.0.0.1:8280')throw Error('Demo only');
initializeApp({projectId:process.env.GCLOUD_PROJECT});const db=getFirestore();
async function token(email){const r=await fetch('http://127.0.0.1:9299/identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=demo-key',{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({email,password:'local-test-password',returnSecureToken:true})});return (await r.json()).idToken;}
const host=await token('host@local.test'),guest=await token('player2@local.test');
async function call(name,t,data={partyId:'123456'}){const r=await fetch(`http://127.0.0.1:5201/demo-socialdeck-gameplay/us-central1/${name}`,{method:'POST',headers:{'content-type':'application/json',...(t?{authorization:`Bearer ${t}`}:{})},body:JSON.stringify({data})});return r.json();}
assert.equal((await call('startPromptdGame',null)).error.status,'UNAUTHENTICATED');
assert.equal((await call('startPromptdGame',guest)).error.status,'PERMISSION_DENIED');
assert.equal((await call('startPromptdGame',host,{partyId:'123456',prompts:['cheat']})).error.status,'INVALID_ARGUMENT');
await db.doc('parties/123456').update({'members.player2.ready':false});assert.equal((await call('startPromptdGame',host)).error.status,'FAILED_PRECONDITION');await db.doc('parties/123456').update({'members.player2.ready':true});
const results=await Promise.all([call('startPromptdGame',host),call('startPromptdGame',host)]);assert.ok(results[0].result?.gameId,JSON.stringify(results));assert.equal(results[0].result.gameId,results[1].result.gameId);const id=results[0].result.gameId;
const state=(await call('getPromptdGamePreparation',guest)).result;assert.equal(state.readyRounds,0);assert.equal(state.prompt,undefined);assert.equal(state.playerIds,undefined);assert.equal(state.session,undefined);
const denied=await fetch(`http://127.0.0.1:8280/v1/projects/demo-socialdeck-gameplay/databases/(default)/documents/promptdGameplay/${id}`,{headers:{authorization:`Bearer ${guest}`}});assert.equal(denied.status,403);
await db.doc('promptdRuntimeJobs/'+id).update({status:'cancelled'});await db.doc('parties/123456').update({phase:'lobby'});
console.log('PASS: unauthenticated/nonhost rejected; unready blocked; injected prompts rejected; concurrent Start one game; private future prompts denied. Reset lobby for live app test.');
