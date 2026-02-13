
import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../module/auth/model/authenticated_user.dart';
import '../../module/auth/presentation/screen/login_screen.dart';
import '../../module/auth/presentation/screen/signup_screen.dart';
import '../view/authenticated_home_screen.dart';
import 'route_names.dart';

class AppRouter {
  // static Future<void> navigateTo(RouteNames routeName) async {
  //   await navigatorKey.currentState?.pushNamed(routeName.name);
  // }
  static Future<void> navigateToReplacement(RouteNames routeName, [Object? arguments]) async {
    debugPrint('navigateToReplacement: ${routeName.name}, ${navigatorKey.currentState}');
    await navigatorKey.currentState
        ?.pushReplacementNamed(routeName.path, arguments: arguments);
  }

  // static Future<void> navigateBack() async {
  //   navigatorKey.currentState?.pop();
  // }

  // static Future<void> navigateToAndRemoveUntil(RouteNames routeName, bool Function(Route<dynamic> route) predicate) async {
  //   await navigatorKey.currentState?.pushNamedAndRemoveUntil(
  //     routeName.name,
  //     predicate,
  //   );
  // }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    debugPrint('onGenerateRoute: ${settings.name}');

    if (settings.name == RouteNames.login.path) {
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
        settings: settings,
      );
    }

    if (settings.name == RouteNames.signup.path) {
      return MaterialPageRoute(
        builder: (context) => const SignupScreen(),
        settings: settings,
      );
    }

    if (settings.name == RouteNames.app.path) {
      return MaterialPageRoute(
        builder: (context) => AuthenticatedHomeScreen(
          currentAuth: settings.arguments as AuthenticatedUser,
        ),
        settings: settings,
      );
    }

    return null;
  }
}





// import 'package:class_photo_sicesloposwa/src/core/di/repo_di.dart';
// import 'package:class_photo_sicesloposwa/src/module/auth/repo/auth_repo.dart';
// import 'package:class_photo_sicesloposwa/src/module/auth/ui/view/signin_view.dart';
// import 'package:class_photo_sicesloposwa/src/module/auth/ui/view/signup_view.dart';
// import 'package:class_photo_sicesloposwa/src/module/onboarding/view/splash_view.dart';
// import 'package:go_router/go_router.dart';
// import '../../src/core/module/auth/controller/auth_state_controller.dart';
// import 'route_names.dart';
// import 'route_paths.dart';

// class AppRouter {
//   AppRouter();

//   late final GoRouter router = GoRouter(
//     initialLocation: RoutePaths.splash,
//     refreshListenable: ,
//     routes: [
//       GoRoute(
//         name: RouteNames.splash,
//         path: RoutePaths.splash,
//         builder: (context, state) => const SplashView(),
//       ),

//       GoRoute(
//         name: RouteNames.login,
//         path: RoutePaths.login,
//         builder: (context, state) => const SigninView(),
//       ),

//       GoRoute(
//         name: RouteNames.signup,
//         path: RoutePaths.signup,
//         builder: (context, state) => const SignupView(),
//       ),

//       GoRoute(
//         name: RouteNames.home,
//         path: RoutePaths.home,
//         builder: (context, state) => const HomeScreen(),
//       ),

//       GoRoute(
//         name: RouteNames.profile,
//         path: RoutePaths.profile,
//         builder: (context, state) => const ProfileScreen(),
//       ),
//     ],

//     redirect: (context, state) {
//       final isLoading = authState.isLoading;
//       final user = authState.currentUser;

//       /// Still loading Firebase
//       if (isLoading) return RoutePaths.splash;

//       /// Not logged in → redirect to login page
//       final loggingIn = state.matchedLocation == RoutePaths.login ||
//                         state.matchedLocation == RoutePaths.signup;

//       if (user == null) {
//         return loggingIn ? null : RoutePaths.login;
//       }

//       /// Logged in → prevent returning to login or signup
//       if (loggingIn) return RoutePaths.home;

//       return null;
//     },
//   );
// }
