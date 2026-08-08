# Nosok v34 — Browser/Role Negative UAT Checklist

After successful wrapper apply and post-wrapper read-only SQL, capture:

1. Anonymous `/services/nosok` public campaign read evidence.
2. Anonymous `/services/nosok/requirements` public requirements evidence.
3. Anonymous `/services/nosok/apply` submit evidence with tracking only.
4. Anonymous `/services/nosok/track` tracking privacy evidence.
5. Authenticated user without Nosok role opens `/admin/systems/nosok` and receives Arabic forbidden/error via Platform Access Gateway.
6. Network tab evidence showing RPC 200/expected controlled error.
7. Console evidence free from application compile errors.

Do not capture or paste full citizen personal data.
