// // lib/routes/app_router.dart

// import 'package:flutter/material.dart';
// import '../core/constants/app_routes.dart';

// // Import other screens as you create them

// class AppRouter {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       // Auth Routes
//       case AppRoutes.splash:
//         return MaterialPageRoute(builder: (_) => const SplashScreen());

//       case AppRoutes.login:
//         return MaterialPageRoute(builder: (_) => const LoginScreen());

//       // Main Routes
//       case AppRoutes.dashboard:
//         return MaterialPageRoute(builder: (_) => const DashboardScreen());

//       // Add other routes as you create screens
//       // case AppRoutes.products:
//       //   return MaterialPageRoute(builder: (_) => const ProductsScreen());

//       // case AppRoutes.pos:
//       //   return MaterialPageRoute(builder: (_) => const PosScreen());

//       // Default (404)
//       default:
//         return MaterialPageRoute(
//           builder: (_) => Scaffold(
//             body: Center(
//               child: Text('No route defined for ${settings.name}'),
//             ),
//           ),
//         );
//     }
//   }
// }
// lib/routes/app_router.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/views/dashboard/dashbord_screen.dart';
import '../core/constants/app_routes.dart';
import '../views/auth/splash_screen.dart';
import '../views/auth/login_screen.dart';
// import '../views/dashboard/dashboard_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Auth Routes
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      // Main Routes
      case AppRoutes.dashboard:
        // Temporary placeholder until we create dashboard
        return MaterialPageRoute(builder: (_) => DashboardScreen());

      // Default (404)
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Page non trouvée',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Route: ${settings.name}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}
