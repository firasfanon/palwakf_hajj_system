// Apply inside PalWakf route groups only.
// This file is intentionally excluded from standalone analysis.

import 'package:go_router/go_router.dart';
import '../../../features/nosok_system/presentation/routes/nosok_routes.dart';

List<RouteBase> buildNosokPublicRoutes() => NosokRoutes.publicRoutes;
List<RouteBase> buildNosokAdminRoutes() => NosokRoutes.adminRoutes;
