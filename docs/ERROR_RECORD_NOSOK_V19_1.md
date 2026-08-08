# ERROR RECORD — NOSOK V19.1

## Error group 1 — Unsupported Material icon
**File:** `lib/features/nosok_system/system_navigation.dart`  
**Error:** `Member not found: 'outgoing_mail_outlined'`  
**Cause:** Icon constant not available in the local Flutter SDK.  
**Fix:** Replaced with stable `Icons.send`.

## Error group 2 — Riverpod AsyncNotifier method name collision
**File:** `lib/features/nosok_system/application/nosok_followup_inbox_controller.dart`  
**Error:** `method update has fewer positional arguments than overridden method AsyncNotifierBase.update`  
**Cause:** The controller declared a custom `update(...)` method that collided with Riverpod's `AsyncNotifierBase.update(...)`.  
**Fix:** Renamed method to `updateFollowupInboxItem(...)` and updated call sites.

## Error group 3 — Missing lifecycle widget
**File:** `lib/features/nosok_system/presentation/pages/admin/nosok_admin_application_details_page.dart`  
**Error:** `_LifecycleEnforcementSection` is not defined.  
**Cause:** V19 inserted the widget usage but omitted the widget implementation.  
**Fix:** Added `_LifecycleEnforcementSection` and `_runLifecycleTransition(...)` using lifecycle rules/transitions providers.

## Error group 4 — Duplicate constant set entries
**File:** `lib/features/nosok_system/system_permissions.dart`  
**Error:** Constant evaluation conflict in `NosokSystemPermissionsProposal.admin`.  
**Cause:** Duplicate entries for `manageNosokApplicationLifecycle` and `dispatchNosokNotifications`.  
**Fix:** Removed duplicate entries while preserving both permissions once.

## Stable baseline after fix
`Nosok v19.1 — compile-hotfix-ready / local-retest-required / production-not-approved`
