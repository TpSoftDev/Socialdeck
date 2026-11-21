import {initializeApp} from 'firebase-admin/app';
import {getFirestore} from 'firebase-admin/firestore';
import {getAuth} from 'firebase-admin/auth';
import config from '../shared/config.json' with {type:'json'};
if(process.env.GCLOUD_PROJECT!=='demo-socialdeck-gameplay'||process.env.FIRESTORE_EMULATOR_HOST!=='127.0.0.1:8280'||process.env.FIREBASE_AUTH_EMULATOR_HOST!=='127.0.0.1:9299')throw Error('Demo emulators required');
initializeApp({projectId:process.env.GCLOUD_PROJECT});const db=getFirestore(),auth=getAuth();
const ids=['host-test','player2','player3','player4','player5','player6','player7','player8'];
for(const [i,uid] of ids.entries()){
 const email=i===0?'host@local.test':`${uid}@local.test`;
 try{await auth.createUser({uid,email,password:'local-test-password',emailVerified:true});}catch(e){if(e.code!=='auth/uid-already-exists'&&e.code!=='auth/email-already-exists')throw e;}
 await db.doc(`users/${uid}`).set({username:['Host','Amy','Ben','Cal','Dana','Eli','Fay','Gia'][i],onboardingComplete:true,email});
 await db.doc(`partySessions/${uid}`).set({partyId:'123456'});
}
const prompts=Array.from({length:5},(_,i)=>({id:`preview-${i}`,text:`Example excluded from gameplay ${i}`,topics:['Pets']}));
const profile={contractVersion:1,groupTypes:['close_friends'],groupNote:'',styleLevel:'bold',moreOf:['funny'],moreOfNote:'',lessOf:[],lessOfNote:'',safeMode:true,averageAge:25,groupDescription:'Friends who like pets, food and weekend trips. Simple witty captions for ordinary photos.',topicLabels:['Pets','Food','Weekend Trips']};
const session={owner:'host-test',profile,effective:config.styles.bold.base,prompts,feedback:prompts.map(p=>({promptId:p.id,text:p.text,accepted:true})),history:prompts.map(p=>p.text),priorPrompts:[]};
await db.doc('promptdSessions/local-approved').set({value:session,expiresAt:new Date(Date.now()+86400000)});
await db.doc('parties/123456').set({hostId:'host-test',phase:'lobby',revision:1,game:{id:'promptd',rounds:5,requiredCards:7,mixCards:false,safeMode:true},memberIds:ids,members:Object.fromEntries(ids.map((uid,i)=>[uid,{name:['Host','Amy','Ben','Cal','Dana','Eli','Fay','Gia'][i],characterId:null,ready:true,cardCount:7,selectionRevision:1}])),createdAt:new Date(),updatedAt:new Date()});
await db.doc('parties/123456/aiSetup/current').set({schemaVersion:1,revision:1,sessionId:'local-approved',savedBy:'host-test',updatedAt:new Date(),settings:{groups:['Friends'],customGroups:[],description:profile.groupDescription,topics:profile.topicLabels,customTopics:[],style:'bold',averageAge:25,safeMode:true,rounds:5,mixCards:false},prompts});
console.log('Seeded demo party 123456: eight simulated ready players, five rounds. Preview fixtures are exclusions only.');
