const {spawnSync}=require('node:child_process');
for(const file of ['ai_setup.test.cjs','party_rules.test.cjs','compatibility.test.cjs']) {
 const r=spawnSync(process.execPath,['--test',file],{cwd:__dirname,env:process.env,stdio:'inherit'});
 if(r.status!==0)process.exit(r.status||1);
}
