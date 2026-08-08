# BASELINE CHANGELOG — NOSOK V19.1

**Date:** 2026-05-18  
**Batch:** Nosok v19.1 — Compile Hotfix for Lifecycle/Follow-up/Permissions  
**Base:** Nosok v19 — Lifecycle Enforcement + Follow-up Inbox + Notification Provider Adapter UAT

## Scope
This is a targeted compile blocker correction after local Chrome build feedback. It does not add new business features and does not change the semi-independent system positioning of Nosok under PalWakf.

## Fixed
1. Replaced unsupported `Icons.outgoing_mail_outlined` with stable `Icons.send` in `system_navigation.dart`.
2. Renamed `NosokFollowupInboxController.update(...)` to `updateFollowupInboxItem(...)` to avoid overriding Riverpod `AsyncNotifierBase.update` with an incompatible signature.
3. Updated all Follow-up Inbox page invocations to use `updateFollowupInboxItem(...)`.
4. Added the missing `_LifecycleEnforcementSection` widget in `nosok_admin_application_details_page.dart`.
5. Removed duplicate const entries from `NosokSystemPermissionsProposal.admin` to restore constant-set evaluation.

## Governance
- PalWakf remains the platform authority.
- Nosok remains a semi-independent system under the platform contract.
- No production approval is granted by this hotfix.
- No `waqf`, `waqf_assets`, or `awqaf_system` mutation.

## Local validation required
```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```
