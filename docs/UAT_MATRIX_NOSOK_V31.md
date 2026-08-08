# UAT Matrix — Nosok v31

| Area | Test | Expected |
|---|---|---|
| Flutter | Open v31 authorization route | Page renders without console blocker |
| Flutter | Open v31 apply certification route | Shows apply not certified unless SQL result exists |
| Flutter | Open v31 post-apply UAT route | Shows UAT blocked until controlled apply |
| SQL | Run read-only v31 probe | No DDL/DML; returns schema/object/RLS/public guard sections |
| Guard | Run operator apply as-is | Must fail closed before any DDL |
| Boundary | public scan | No new public base tables |
| Boundary | sovereign scan | No waqf/waqf_assets/awqaf_system mutation |
| Post-apply | RLS enabled | Required only after controlled apply output |
| Post-apply | Negative UAT | Required only after controlled apply output |
