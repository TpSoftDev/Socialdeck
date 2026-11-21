# Reversible prompt writing style

Approved November 18, 2026. Default for newly created providers: `simple-witty-v1`.

The new calibration favors familiar 5–12-word situations and a small witty twist. It is appended to both generator and reviewer instructions. Original generator/reviewer/policy files remain unchanged; exact backup copies and SHA-256 checksums are in `functions/src/prompt-versions/legacy-v1/`.

## Restore the previous writing style
Set the server environment variable:
```
PROMPTD_WRITING_STYLE=legacy-v1
```
Restart a local server, or redeploy the AI functions for a cloud change to take effect. Restore the new style with `PROMPTD_WRITING_STYLE=simple-witty-v1` (also the default when unset). Invalid values fail closed. This switch restores writing instructions, not an entire old backend or model snapshot.

Existing approved examples and saved responses are not rewritten. Fresh requests and replacements use the selected style, retaining existing feedback and safety rules. No model, reasoning effort, token cap, API contract, safety boundary or repair logic changed.

Local regression tests verify both instruction paths, backup integrity and existing behavior. The earlier live trial used the same calibration, with a test-only label. This source change requires an AI function deployment to take effect online. Gameplay-pool separation, 4/6/8 preparation and two-minute scheduling remain separate pending work.
