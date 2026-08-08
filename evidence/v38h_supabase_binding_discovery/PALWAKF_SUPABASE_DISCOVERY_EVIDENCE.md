# PalWakf Supabase Discovery Evidence — v38H

## Evidence source

This evidence was collected from the previously uploaded PalWakf baseline inspected during the revoked v39 attempt. It is used only to prepare Nosok for future hosting; it does not execute platform join.

## Key files observed

- `lib/main.dart`: central `Supabase.initialize(url: AppConstants.baseUrl, anonKey: AppConstants.apiKey)`.
- `lib/core/constants/app_constants.dart`: required env keys `SUPABASE_URL` and `SUPABASE_ANON_KEY`.
- `lib/data/services/supabase_service.dart`: singleton `SupabaseService` wrapping `Supabase.instance.client`, `from`, `rpc`, auth, and storage helpers.
- `lib/presentation/providers/supabase_providers.dart`: Riverpod `supabaseServiceProvider`.
- `lib/core/access/access_repository.dart`: access context over admin users and platform roles/permissions.

## Decision

Nosok must be hosted as a feature under PalWakf and receive Supabase/AccessProfile from the platform. No independent client, no hardcoded keys, and no SQL apply in the Nosok pre-join track.
