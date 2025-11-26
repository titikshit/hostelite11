import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/student_dashboard.dart';
import '../screens/complaints/register_complaint_screen.dart';
import '../screens/complaints/complaints_list_screen.dart';
import '../screens/notices/notices_screen.dart';
import '../screens/fees/fees_screen.dart';
import '../screens/feedback/feedback_screen.dart';
import '../screens/forms/forms_list_screen.dart';
import '../screens/forms/forms_fill_screen.dart'; // Ensure this import points to the file where FormFillScreen is defined

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
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const StudentDashboard(),
      ),
      GoRoute(
        path: '/register-complaint',
        builder: (context, state) => const RegisterComplaintScreen(),
      ),
      GoRoute(
        path: '/complaints',
        builder: (context, state) => const ComplaintsListScreen(),
      ),
      GoRoute(
        path: '/notices',
        builder: (context, state) => const NoticesScreen(),
      ),
      GoRoute(
        path: '/fees',
        builder: (context, state) => const FeesScreen(),
      ),
      GoRoute(
        path: '/feedback',
        builder: (context, state) => const FeedbackScreen(),
      ),
      GoRoute(
        path: '/forms',
        builder: (context, state) => const FormsListScreen(),
      ),
      GoRoute(
        path: '/forms/:id',
        builder: (context, state) {
          final form = state.extra as HostelForm;
          return FormFillScreen(form: form);
        },
      ),
    ],
  );
});
