# Error Record — Nosok v27.1

## Error Class

`ANALYZER_COMPILE_BLOCKER_ROUTE_PERMISSION_CONSTANT_DRIFT`

## Evidence

After v27 retest, analyzer reported 67 issues. The first failures were:

- `NosokSystemRoutes.adminHomepageSections` undefined.
- `NosokPermissionKeys.manageNosokHomepageSections` undefined.
- Multiple public route constants undefined, including `lotteryResults`, `waitingList`, `objections`, `contact`, `companyLogin`, and `legalRegulation`.
- `flutter run -d chrome` failed to compile because the same route/permission members were missing.

## Diagnosis

The existing Nosok codebase still references pre-join/v38 route and permission constants. v27 did not include a compatibility-preservation sweep for those constants.

## Resolution

v27.1 restores the referenced constants and keeps them in the Nosok route/permission contract.

## Residual Risk

Local retest is required because Flutter/Dart tools were not available inside the packaging environment.
