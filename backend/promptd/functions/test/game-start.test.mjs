import {test} from 'node:test';
import assert from 'node:assert/strict';
import {GameStartService} from '../src/game-start.mjs';
test('generation status exposes ready current-round prompt immediately, without countdown delay',async()=>{
 const job={status:'preparing',ready:[],rounds:5,playerIds:['host','b','c','d']};
 const party={phase:'playing',hostId:'host',memberIds:job.playerIds,members:{d:{name:'Dana'}}};
 const runtime={gameId:'game',startedAt:100,currentRound:1};
 const wrap=value=>({data:()=>value});
 const db={doc:path=>path,runTransaction:action=>action({getAll:async()=>[wrap(party),wrap(runtime)],get:async()=>wrap({value:job})})};
 const service=new GameStartService(db,()=>101);
 assert.equal((await service.status('host','123456')).prompt,undefined);
 job.ready=[{prompts:[{id:'p1',text:'A ready prompt.'},{id:'p2',text:'Other pair.'}]}];
 const status=await service.status('host','123456');
 assert.equal(status.prompt.id,'p1');assert.equal(status.readyRounds,1);assert.equal(status.ready,undefined);
});
