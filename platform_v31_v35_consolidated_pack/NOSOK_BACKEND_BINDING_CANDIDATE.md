# Nosok Backend Binding Candidate — v33

الربط الحقيقي مؤجل حتى بعد إنشاء schema/RPCs. المرشح الحالي:

- Public portal -> public RPC wrappers.
- Tracking -> public own-result RPC.
- Lottery results -> public own-result RPC.
- Admin requests -> nosok admin snapshot RPC.
- Draw/committee -> nosok governance RPCs.

كل adapters تبقى disabled قبل توفر:

1. schema nosok.
2. RLS enabled.
3. RPCs deployed.
4. SQL UAT passed.
5. Role UAT passed.
