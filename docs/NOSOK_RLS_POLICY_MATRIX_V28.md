# Nosok v28 — RLS Policy Matrix Draft

No policies are applied in this batch. This is a design matrix only.

| Table | Read rule | Write rule | Negative UAT |
|---|---|---|---|
| `nosok.campaigns` | Published data only through public view; internal read by RBAC | `manageNosokCampaigns` via Platform Access Gateway | Anonymous cannot write; scoped employee cannot edit central campaign |
| `nosok.applications` | Applicant tracking subset; internal queue by role/scope | Submit/update through guarded RPC only | Wrong unit cannot read another LGU queue |
| `nosok.application_documents` | Applicant/reviewer metadata only | Storage/RPC guarded metadata insert | Anonymous cannot enumerate documents |
| `nosok.eligibility_rules` | Published rules may be public | `manageNosokLegalCompliance` only | Reviewer cannot change legal rule |
| `nosok.lgu_quotas` | Committee/supervisor before approval | Committee-controlled workflow | Unit admin cannot alter another LGU quota |
| `nosok.workflow_events` | Internal scoped read | Append via guarded RPC/trigger | Normal reviewer cannot edit workflow history |
| `nosok.audit_events` | Audit permission/superuser only | Append-only trigger/RPC | No user can update/delete audit rows |
