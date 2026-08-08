# ERROR RECORD — Nosok v38

## Closed before v38

1. Public subpage compile commas — fixed in v37B-1.
2. Pink/rose palette leakage — removed/enforced in v37D/E.
3. Public header chip visual inconsistency — fixed in v37E.
4. Apply page Stepper unbounded runtime crash — replaced by custom citizen progress flow in v37H.
5. Analyzer warnings — cleaned in v37F.

## v38 state

No new code error is recorded in v38.  
Latest accepted evidence:

```text
format passed / analyze clean / chrome startup passed
```

## Watch items

- Browser console after click-through must remain clean on apply/track/results/waiting/objections.
- Inside-PalWakf route guards may expose new errors after actual merge.
- Schema/RPC errors are not testable until `nosok schema` is created after platform merge.
