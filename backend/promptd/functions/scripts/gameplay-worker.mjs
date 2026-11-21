// IA: Durable local worker. Never run against production; restart resumes queued jobs.
import {readFileSync} from 'node:fs';
import {initializeApp} from 'firebase-admin/app';
import {getFirestore} from 'firebase-admin/firestore';
import {FirestoreStore} from '../src/firestore-store.mjs';
import {createLocalGameplayWorker} from '../src/gameplay-local.mjs';
if(process.env.GCLOUD_PROJECT!=='demo-socialdeck-gameplay'||process.env.FIRESTORE_EMULATOR_HOST!=='127.0.0.1:8280')throw Error('Local demo Firestore required.');
const text=readFileSync(process.argv[2],'utf8'),line=text.split(/\r?\n/).find(l=>l.startsWith('OPENAI_API_KEY='));if(!line)throw Error('Key unavailable');
const apiKey=line.slice(line.indexOf('=')+1).trim().replace(/^['"]|['"]$/g,'');
initializeApp({projectId:process.env.GCLOUD_PROJECT});const db=getFirestore();const worker=createLocalGameplayWorker({store:new FirestoreStore(db),apiKey});
console.log('Local gameplay worker ready');
while(true){
 const queue=await db.collection('promptdRuntimeJobs').where('status','==','queued').get();
 for(const task of queue.docs){
  const {partyId}=task.data();const [p,r]=await Promise.all([db.doc(`parties/${partyId}`).get(),db.doc(`parties/${partyId}/promptdRuntime/current`).get()]);
  if(p.data()?.phase!=='playing'||r.data()?.gameId!==task.id){await task.ref.update({status:'cancelled'});continue;}
  try{const job=await worker.prepareNext(task.id);console.log(JSON.stringify({gameId:task.id,readyRounds:job.ready.length,status:job.status}));if(job.status==='complete')await task.ref.update({status:'complete'});}
  catch(error){const job=await worker.read(task.id);console.log(JSON.stringify({gameId:task.id,error:error.code??'internal'}));if(job?.status==='failed')await task.ref.update({status:'failed'});}
 }
 await new Promise(resolve=>setTimeout(resolve,500));
}
