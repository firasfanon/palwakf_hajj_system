# Nosok v37 — Public Repository Binding Runtime Switch Candidate

## المرشحات

| السطح | القرار | السبب |
|---|---|---|
| Public campaigns | candidate | wrapper موجود ويمكن تجربة القراءة العامة عبر fallback-safe adapter |
| Public requirements | candidate | wrapper موجود ويمكن تجربة published-only requirements |
| Public submit | deferred | يحتاج privacy/rate-limit/error-normalizer evidence |
| Public track | deferred | يحتاج no-PII/no-documents/no-audit privacy evidence |
| Admin queues/review | blocked | يحتاج Admin RPC/RLS مستقل وليس public wrappers |

## القاعدة

لا direct access إلى `nosok.*` من Flutter. كل ربط عام يمر عبر `public.rpc_nosok_*` فقط.
