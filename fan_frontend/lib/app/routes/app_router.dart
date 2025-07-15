import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/authentication/screens/welcome_screen.dart';
import '../../features/authentication/screens/phone_verification_screen.dart';
import '../../features/authentication/screens/otp_verification_screen.dart';
import '../../features/authentication/screens/registration_screen.dart';
import '../../features/authentication/screens/login_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/fuel_advance/screens/advance_request_screen.dart';
import '../../features/fuel_advance/screens/qr_display_screen.dart';
import '../../features/partner_stations/screens/station_list_screen.dart';
import '../../features/transactions/screens/transaction_history_screen.dart';
import '../../features/repayment/screens/repayment_screen.dart';
import '../../shared/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  
  return GoRouter(
    initialLocation: authState.isAuthenticated ? '/dashboard' : '/welcome',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/auth') || 
                         state.matchedLocation == '/welcome';
      
      if (!isAuthenticated && !isAuthRoute) {
        return '/welcome';
      }
      
      if (isAuthenticated && isAuthRoute) {
        return '/dashboard';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/auth/phone-verification',
        builder: (context, state) => const PhoneVerificationScreen(),
      ),
      GoRoute(
        path: '/auth/otp-verification',
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return OtpVerificationScreen(phone: phone);
        },
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return RegistrationScreen(phone: phone);
        },
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/advance-request',
        builder: (context, state) => const AdvanceRequestScreen(),
      ),
      GoRoute(
        path: '/qr-display',
        builder: (context, state) {
          final qrCode = state.extra as String? ?? '';
          return QrDisplayScreen(qrCode: qrCode);
        },
      ),
      GoRoute(
        path: '/stations',
        builder: (context, state) => const StationListScreen(),
      ),
      GoRoute(
        path: '/transactions',
        builder: (context, state) => const TransactionHistoryScreen(),
      ),
      GoRoute(
        path: '/repayment',
        builder: (context, state) {
          final transactionId = state.extra as int? ?? 0;
          return RepaymentScreen(transactionId: transactionId);
        },
      ),
    ],
  );
});
