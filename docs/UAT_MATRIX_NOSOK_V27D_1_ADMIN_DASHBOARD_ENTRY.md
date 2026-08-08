# UAT MATRIX — Nosok v27D-1 Admin Dashboard Entry

| Area | Route | Check | Expected |
|---|---|---|---|
| Public shell | `/services/nosok` | Header button exists | `دخول الموظفين / لوحة التحكم` visible |
| Public shell | `/services/nosok` | Button click | Navigates to `/admin/systems/nosok` |
| Public home | `/services/nosok` | Entry panel exists | Panel explains staff/admin access |
| Public home | `/services/nosok` | Panel button click | Navigates to `/admin/systems/nosok` |
| RBAC | `/admin/systems/nosok` | Unauthorized user | Forbidden/guarded by platform access profile |
| RBAC | `/admin/systems/nosok` | Authorized user | Admin dashboard opens |
| UX separation | `/services/nosok` | Citizen journey remains primary | Public services are still dominant |
| Governance | All | No waqf mutation | No `waqf_assets` changes |
