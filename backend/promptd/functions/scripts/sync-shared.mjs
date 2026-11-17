// Package the canonical shared contracts with the deployable function source.
import { cpSync, mkdirSync } from 'node:fs';
const target = new URL('../shared/', import.meta.url);
mkdirSync(target, { recursive: true });
cpSync(new URL('../../shared/prompt_system/', import.meta.url), target, { recursive: true });
