import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/user_role.dart';
import '../../features/auth/presentation/customer_profile_setup_screen.dart';
import '../../features/auth/presentation/otp_verification_screen.dart';
import '../../features/auth/presentation/partner_profile_setup_screen.dart';
import '../../features/auth/presentation/phone_login_screen.dart';
import '../../features/auth/presentation/welcome_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/customer/home/presentation/customer_home_screen.dart';
import '../../features/customer/home/presentation/customer_nav_shell.dart';
import '../../features/customer/orders/presentation/customer_orders_screen.dart';
import '../../features/customer/partner_details/presentation/partner_detail_screen.dart';
import '../../features/customer/profile/presentation/customer_profile_screen.dart';
import '../../features/customer/search/presentation/customer_search_screen.dart';
import '../../features/customer/subscriptions/presentation/customer_subscriptions_screen.dart';
import '../../features/customer/subscriptions/presentation/meal_calendar_screen.dart';
import '../../features/partner/presentation/kitchen_view_screen.dart';
import '../../features/partner/presentation/partner_dashboard_screen.dart';
import '../../features/partner/presentation/partner_earnings_screen.dart';
import '../../features/partner/presentation/partner_menu_screen.dart';
import '../../features/partner/presentation/partner_nav_shell.dart';
import '../../features/partner/presentation/partner_orders_screen.dart';
import '../../features/partner/presentation/partner_subscribers_screen.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authProvider.notifier);

  return GoRouter(
    initialLocation: RoutePaths.welcome,
    refreshListenable: _AuthListenable(ref),
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final currentLoc = state.uri.toString();

      final isAuthFlow = currentLoc == RoutePaths.welcome ||
          currentLoc == RoutePaths.phoneLogin ||
          currentLoc == RoutePaths.otpVerification;

      // 1. Unauthenticated Users
      if (!auth.isAuthenticated) {
        if (!isAuthFlow) return RoutePaths.welcome;
        return null;
      }

      // 2. Profile Setup Guard
      if (!auth.isProfileComplete) {
        if (auth.role == UserRole.partner) {
          if (currentLoc != RoutePaths.partnerProfileSetup) {
            return RoutePaths.partnerProfileSetup;
          }
        } else {
          if (currentLoc != RoutePaths.customerProfileSetup) {
            return RoutePaths.customerProfileSetup;
          }
        }
        return null;
      }

      // 3. Strict Role Isolation Guards (Section 2.2)
      // Customer trying to visit partner route
      if (auth.role == UserRole.customer && currentLoc.startsWith('/partner')) {
        return RoutePaths.customerHome;
      }

      // Partner trying to visit customer route
      if (auth.role == UserRole.partner && currentLoc.startsWith('/customer')) {
        return RoutePaths.partnerDashboard;
      }

      // Authenticated users trying to visit auth flow routes
      if (isAuthFlow) {
        return auth.role == UserRole.partner
            ? RoutePaths.partnerDashboard
            : RoutePaths.customerHome;
      }

      return null;
    },
    routes: [
      // AUTH / ONBOARDING ROUTES
      GoRoute(
        path: RoutePaths.welcome,
        name: RouteNames.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RoutePaths.phoneLogin,
        name: RouteNames.phoneLogin,
        builder: (context, state) => const PhoneLoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.otpVerification,
        name: RouteNames.otpVerification,
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: RoutePaths.customerProfileSetup,
        name: RouteNames.customerProfileSetup,
        builder: (context, state) => const CustomerProfileSetupScreen(),
      ),
      GoRoute(
        path: RoutePaths.partnerProfileSetup,
        name: RouteNames.partnerProfileSetup,
        builder: (context, state) => const PartnerProfileSetupScreen(),
      ),

      // CUSTOMER SHELL ROUTES
      ShellRoute(
        builder: (context, state, child) => CustomerNavShell(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.customerHome,
            name: RouteNames.customerHome,
            builder: (context, state) => const CustomerHomeScreen(),
          ),
          GoRoute(
            path: RoutePaths.customerSearch,
            name: RouteNames.customerSearch,
            builder: (context, state) => const CustomerSearchScreen(),
          ),
          GoRoute(
            path: RoutePaths.customerSubscriptions,
            name: RouteNames.customerSubscriptions,
            builder: (context, state) => const CustomerSubscriptionsScreen(),
          ),
          GoRoute(
            path: RoutePaths.customerOrders,
            name: RouteNames.customerOrders,
            builder: (context, state) => const CustomerOrdersScreen(),
          ),
          GoRoute(
            path: RoutePaths.customerProfile,
            name: RouteNames.customerProfile,
            builder: (context, state) => const CustomerProfileScreen(),
          ),
        ],
      ),

      // Standalone Customer Sub-routes
      GoRoute(
        path: RoutePaths.customerPartnerDetail,
        name: RouteNames.customerPartnerDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final extra = state.extra as Map<String, dynamic>?;
          return PartnerDetailScreen(partnerId: id, initialData: extra);
        },
      ),
      GoRoute(
        path: RoutePaths.customerMealCalendar,
        name: RouteNames.customerMealCalendar,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MealCalendarScreen(subscriptionId: id);
        },
      ),

      // PARTNER SHELL ROUTES
      ShellRoute(
        builder: (context, state, child) => PartnerNavShell(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.partnerDashboard,
            name: RouteNames.partnerDashboard,
            builder: (context, state) => const PartnerDashboardScreen(),
          ),
          GoRoute(
            path: RoutePaths.partnerOrders,
            name: RouteNames.partnerOrders,
            builder: (context, state) => const PartnerOrdersScreen(),
          ),
          GoRoute(
            path: RoutePaths.partnerMenuManagement,
            name: RouteNames.partnerMenuManagement,
            builder: (context, state) => const PartnerMenuScreen(),
          ),
          GoRoute(
            path: RoutePaths.partnerSubscribers,
            name: RouteNames.partnerSubscribers,
            builder: (context, state) => const PartnerSubscribersScreen(),
          ),
          GoRoute(
            path: RoutePaths.partnerEarnings,
            name: RouteNames.partnerEarnings,
            builder: (context, state) => const PartnerEarningsScreen(),
          ),
        ],
      ),

      // Standalone Partner Sub-routes
      GoRoute(
        path: RoutePaths.partnerKitchenView,
        name: RouteNames.partnerKitchenView,
        builder: (context, state) => const KitchenViewScreen(),
      ),
    ],
  );
});

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}
