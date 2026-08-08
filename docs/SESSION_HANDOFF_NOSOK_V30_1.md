# Session Handoff — Nosok v30.1

## Latest baseline

```text
nosok_platform_integration_patch_v30_1_apply_result_read_only_intake_under_platform.zip
```

## Current governing state

Nosok remains a semi-independent, pre-join, platform-compliant system under PalWakf.

The owner schema design is prepared, but not applied. The current database still does not contain the `nosok` schema or the proposed `nosok.*` owner tables.

## Accepted evidence in this turn

### SQL read-only

The user ran the v30 read-only apply-result intake SQL.

Accepted results:

```text
nosok_present=false
candidate expected nosok tables present_as_base_table=false
new_public_nosok_base_tables_detected=false
rls_status_if_any=[]
controlled_apply_result_required=true
```

### Flutter runtime

Accepted results:

```text
flutter clean: passed
flutter pub get: passed
dart format .: passed
flutter analyze: No issues found
flutter run -d chrome: passed
Supabase init completed
```

## Boundaries preserved

- `public` remains a compatibility view/RPC surface only.
- No public base table creation is authorized.
- `core` remains the sovereign reference owner for LGU/governorates/org_units.
- `billing_system` remains the payment bridge owner.
- `platform_access` remains the access/RBAC owner.
- `waqf`, `waqf_assets`, and `awqaf_system` remain out of scope.

## Current blockers

```text
owner_authorization_id not supplied
controlled staging DDL apply not executed
nosok schema not created
RLS/RPC post-apply UAT not possible yet
negative UAT not possible yet
production not approved
```

## Correct next step

```text
Nosok v31 — Owner Authorization Token Evidence Intake
+ Controlled Staging DDL Apply Result Certification
+ Post-Apply RLS/RPC Negative UAT Closure
```

Do not run a guarded DDL apply unless the operator provides explicit staging authorization, including:

- `owner_authorization_id`
- staging environment confirmation
- backup confirmation
- explicit permission to create `nosok` schema and the approved `nosok.*` tables only
