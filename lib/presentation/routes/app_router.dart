import 'package:go_router/go_router.dart';
import '../../features/log_upload/presentation/pages/log_upload_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/upload',
      builder: (context, state) => const LogUploadPage(),
    ),
  ],
);
