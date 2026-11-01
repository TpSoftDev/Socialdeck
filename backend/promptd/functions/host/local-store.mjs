// IA: PC hosting uses the same atomic store interface as Firestore.
// Only temporary AI sessions/reviews live here; Party saves still use team Firebase.
import { DatabaseSync } from 'node:sqlite';
export class LocalStore {
  constructor(file, clock = Date.now) {
    this.clock = clock;
    this.db = new DatabaseSync(file);
    this.db.exec('PRAGMA journal_mode=WAL; PRAGMA busy_timeout=5000; CREATE TABLE IF NOT EXISTS records (key TEXT PRIMARY KEY, value TEXT NOT NULL, expires INTEGER NOT NULL);');
    this.read = this.db.prepare('SELECT value FROM records WHERE key = ? AND expires > ?');
    this.write = this.db.prepare('INSERT INTO records (key,value,expires) VALUES (?,?,?) ON CONFLICT(key) DO UPDATE SET value=excluded.value, expires=excluded.expires');
    this.purge = this.db.prepare('DELETE FROM records WHERE expires <= ?');
    this.cleanup();
  }
  cleanup() { this.purge.run(this.clock()); }
  transact(keys, action) {
    this.db.exec('BEGIN IMMEDIATE');
    try {
      const now = this.clock();
      const values = keys.map(key => { const row = this.read.get(key, now); return row ? JSON.parse(row.value) : null; });
      const output = action(values);
      if (output?.then) throw Error('Store transaction callbacks must be synchronous.');
      const { result, writes } = output;
      writes?.forEach((value, i) => this.write.run(keys[i], JSON.stringify(value), now + 86400000));
      this.db.exec('COMMIT');
      return structuredClone(result);
    } catch (error) { this.db.exec('ROLLBACK'); throw error; }
  }
  close() { this.db.close(); }
}
