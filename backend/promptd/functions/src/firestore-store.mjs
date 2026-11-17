// Store records expire logically after 24 hours. Enable Firestore TTL on expiresAt
// for promptdSessions/promptdRequests/promptdLimits/promptdRecent to remove expired records physically.
export class FirestoreStore {
  constructor(db, clock = Date.now) { this.db = db; this.clock = clock; }
  transact(keys, action) {
    return this.db.runTransaction(async tx => {
      const refs = keys.map(key => this.db.doc(key));
      const docs = await tx.getAll(...refs);
      const values = docs.map(doc => {
        const record = doc.data();
        return record && record.expiresAt.toMillis() > this.clock() ? record.value : null;
      });
      const { result, writes } = action(values);
      writes?.forEach((value, i) => tx.set(refs[i], { value, expiresAt: new Date(this.clock() + 86400000) }));
      return result;
    });
  }
}
