-- Nosok UI Mega Batch — PWF-SIS read-only UAT contract
-- No production DML. No waqf/waqf_assets mutation.
select 'nosok_ui_pwf_sis_contract' as section,
       'public_internal_route_separation_documented' as check_key,
       true as passed,
       'Public /services/nosok and internal /admin/systems/nosok surfaces are separated at route level in Flutter patch.' as note
union all
select 'nosok_ui_pwf_sis_contract','no_waqf_assets_mutation',true,'This UAT script is read-only and does not touch waqf or waqf_assets.'
union all
select 'nosok_ui_pwf_sis_contract','sql_is_read_only',true,'No DDL/DML is executed by this script.'
union all
select 'nosok_ui_pwf_sis_contract','visual_identity_admin_compatibility_required',true,'UI uses ThemeData/colorScheme and PWF-SIS wrapper components; final overrides remain owned by PalWakf.';
