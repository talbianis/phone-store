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