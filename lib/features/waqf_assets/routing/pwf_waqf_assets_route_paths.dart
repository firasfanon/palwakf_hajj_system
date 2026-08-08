// PalWakf — Waqf Asset Registry
// Batch 03B — Awqaf System route realignment.
//
// The Waqf Assets Registry is part of awqaf_system, not a detached
// generic admin module. Therefore all operational routes are mounted under:
// /systems/awqaf-system/waqf-assets

class PwfWaqfAssetsRoutePaths {
  const PwfWaqfAssetsRoutePaths._();

  static const awqafSystemRoot = '/systems/awqaf-system';
  static const root = '$awqafSystemRoot/waqf-assets';
  static const create = '$root/create';
  static const review = '$root/review';
  static const lifecycle = '$root/lifecycle';
  static const operationalDevelopment = '$root/operational-development';
  static const operationalReadConsole = '$root/operational-read-console';
  static const userScreens = '$root/user-screens';
  static const sovereignReadiness = '$root/sovereign-readiness';
  static const crossSystemBindings = '$root/cross-system-bindings';
  static const sourceRecords = '$root/source-records';
  static const sourceRecordDetail = '$root/source-records/:sourceRecordId';
  static const sourceDuplicates = '$root/source-duplicates';
  static const sourceParcels = '$root/source-parcels';
  static const detail = '$root/:waqfAssetId';

  // Backward-compatible constant name for code that imported Batch 03/03A.
  // It now points to the awqaf_system route and does not mount the old generic admin route.
  @Deprecated('Use PwfWaqfAssetsRoutePaths.root instead.')
  static const admin = root;

  static String detailFor(String waqfAssetId) => '$root/$waqfAssetId';
  static String sourceRecordDetailFor(String sourceRecordId) =>
      '$root/source-records/$sourceRecordId';
}
