// lib/routes/app_router.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/views/categories/categories_Screen.dart';
import 'package:phone_shop/views/dashboard/dashbord_screen.dart';
import 'package:phone_shop/views/products/product_Screen.dart';
import '../core/constants/app_routes.dart';
import '../views/auth/splash_screen.dart';
import '../views/auth/login_screen.dart';

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
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      // Placeholder routes (we'll build these later)
      case AppRoutes.products:
        return MaterialPageRoute(builder: (_) => const ProductsScreen());

      case AppRoutes.categories:
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());
      case AppRoutes.pos:
      case AppRoutes.customers:
      case AppRoutes.sales:
      case AppRoutes.debts:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: Text(_getPageTitle(settings.name ?? '')),
            ),
            body: Center(
              child:
                  Text('${_getPageTitle(settings.name ?? '')} - Coming Soon'),
            ),
          ),
        );

      // Default (404)
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Page non trouvée',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Route: ${settings.name}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }

  static String _getPageTitle(String route) {
    switch (route) {
      case AppRoutes.dashboard:
        return 'Dashboard';
      case AppRoutes.products:
        return 'Products';
      case AppRoutes.categories:
        return 'Categories';
      case AppRoutes.pos:
        return 'Point of Sale';
      case AppRoutes.customers:
        return 'Customers';
      case AppRoutes.sales:
        return 'Sales History';
      case AppRoutes.debts:
        return 'Debts';
      default:
        return 'Page';
    }
  }
}
