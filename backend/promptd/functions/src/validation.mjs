import Ajv from 'ajv';
import contracts from '../shared/schemas/contracts.schema.json' with { type: 'json' };
import config from '../shared/config.json' with { type: 'json' };
import { fail } from './errors.mjs';
const ajv = new Ajv({ allErrors: false, strict: false });
ajv.addSchema(contracts);
const validators = new Map();
export function validate(name, value) {
  if (!validators.has(name)) validators.set(name, ajv.compile({ $ref: `${contracts.$id}#/$defs/${name}` }));
  if (!validators.get(name)(value)) fail('invalid-argument', `Invalid ${name}. Check required fields, limits, and contractVersion.`);
  return value;
}
export function validateProfile(profile) {
  validate('profile', profile);
  if (!profile.groupTypes.length && !profile.groupNote.trim()) fail('invalid-argument', 'Choose a group or describe your group.');
  if (profile.moreOf.some(id => profile.lessOf.includes(id))) fail('invalid-argument', 'A topic cannot be selected in both More and Less.');
}
// Known English profanity is blocked before semantic review in clean sessions.
const profanity = /\b(?:fuck\w*|motherfuck\w*|shit\w*|bullshit\w*|bitch(?:es|ing|y)?|assholes?|bastards?|damn(?:ed|it)?|piss(?:ed|ing)?|cunts?|dickheads?|hell|crap)\b/i;
const needsCleanLanguage = profile => profile.safeMode !== false || (profile.averageAge ?? profile.youngestAge) == null || (profile.averageAge ?? profile.youngestAge) < 18 || (profile.youngestAge != null && profile.youngestAge < 18);
const normalized = text => text.normalize('NFKC').toLowerCase().replace(/[’']/g, '').replace(/[^\p{L}\p{N}\s]/gu, ' ').replace(/\s+/g, ' ').trim();
const stopWords = new Set('a an photo that the of in with to is it your you yours our we us for and from at on this looks looking like someone something'.split(' '));
function similar(a, b) {
  if (normalized(a) === normalized(b)) return true;
  const tokens = text => new Set(normalized(text).split(' ').filter(w => !stopWords.has(w)));
  const x = tokens(a), y = tokens(b);
  const overlap = [...x].filter(w => y.has(w)).length;
  const union = new Set([...x, ...y]).size;
  // Catch an old card padded with new adjectives; shared topic words alone are fine.
  return overlap / Math.max(1, union) >= 0.65 || (overlap >= 4 && overlap / Math.min(x.size, y.size) >= 0.85);
}
export function validateBatch(texts, profile, history = [], expectedCount = 5) {
  validate('generatedTexts', texts);
  if (texts.length !== expectedCount) fail('invalid-provider-response', 'Wrong number of replacement prompts.');
  const seen = [...history];
  for (const text of texts) {
    // IA: Photo-game answerability is checked by the semantic reviewer.
    // Do not require a literal 'A photo' prefix; captions/scenarios can work too.
    if (needsCleanLanguage(profile) && profanity.test(text.normalize('NFKC'))) fail('invalid-provider-response', 'Safe Mode or player age requires clean language.');
    if (seen.some(old => similar(text, old))) fail('invalid-provider-response', 'The batch contains repeated prompts.');
    // Only explicit whole terms are blocked here. Contextual meanings are checked by the model.
    const terms = profile.lessOf.flatMap(id => config.lessTerms[id] ?? []);
    if (terms.some(term => new RegExp(`\\b${term.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\b`, 'i').test(text))) fail('invalid-provider-response', 'A prompt touches an avoided topic.');
    seen.push(text);
  }
  return texts;
}
