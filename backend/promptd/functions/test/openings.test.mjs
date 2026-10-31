import test from 'node:test';
import assert from 'node:assert/strict';
import {validateBatch} from '../src/validation.mjs';
const profile={safeMode:true,averageAge:22,lessOf:[]};
test('IA: varied photo-answerable captions are not rejected for missing a fixed prefix',()=>{
 const prompts=["When the group chat finally makes it out of the planning stage.",
 "Your unofficial campaign poster for a three-day weekend.",
 "Proof that the shortcut was not actually a shortcut.",
 "Somewhere you would happily lose track of an afternoon.",
 "A photo that deserves its own dramatic entrance."];
 assert.deepEqual(validateBatch(prompts,profile),prompts);
});
test('IA: removing prefix restriction preserves length, repetition and safe-language checks',()=>{
 assert.throws(()=>validateBatch(['Too short'],profile,[],1));
 const text='Proof that the shortcut was not actually a shortcut.';
 assert.throws(()=>validateBatch([text],profile,[text],1));
 assert.throws(()=>validateBatch(['When the fucking group chat ruins your entire afternoon.'],profile,[],1));
});
