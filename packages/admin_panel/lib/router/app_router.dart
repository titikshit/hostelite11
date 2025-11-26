import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../screens/auth/admin_login_screen.dart';
import '../screens/dashboard/admin_dashboard.dart';
import '../screens/notices/create_notice_screen.dart';
import '../screens/students/register_student_screen.dart';
import '../screens/complaints/complaints_management_screen.dart';
import '../screens/forms/create_form_screen.dart';
import '../screens/forms/create_form_screen.dart';
import '../screens/forms/form_responses_management_screen.dart';
import '../screens/forms/form_response_detail_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.when(
        data: (auth) => auth.session != null,
        loading: () => false,
        error: (_, __) => false,
      );

      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) {
        return '/login';
      }

      if (isLoggedIn && isLoginRoute) {
        return '/admin';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboard(),
      ),
      GoRoute(
        path: '/admin/create-notice',
        builder: (context, state) => const CreateNoticeScreen(),
      ),
      GoRoute(
        path: '/admin/register-student',
        builder: (context, state) => const RegisterStudentScreen(),
      ),
      GoRoute(
        path: '/admin/complaints',
        builder: (context, state) => const ComplaintsManagementScreen(),
      ),
      GoRoute(
        path: '/admin/create-form',
        builder: (context, state) => const CreateFormScreen(),
      ),
      GoRoute(
        path: '/admin/form-responses',
        builder: (context, state) => const FormResponsesManagementScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final formId = state.pathParameters['id']!;
              return FormResponseDetailScreen(formId: formId);
            },
          ),
        ],
      ),
    ],
  );
});
