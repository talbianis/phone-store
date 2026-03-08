// lib/main.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/providers/dashborad_provider.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_routes.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/category_provider.dart';
import 'providers/customer_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/sale_provider.dart';
import 'providers/debt_provider.dart';
import 'providers/expense_provider.dart';

import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Theme Provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        // Auth Provider
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Category Provider
        ChangeNotifierProvider(create: (_) => CategoryProvider()),

        // Product Provider
        ChangeNotifierProvider(create: (_) => ProductProvider()),

        // Customer Provider
        ChangeNotifierProvider(create: (_) => CustomerProvider()),

        // Cart Provider (POS)
        ChangeNotifierProvider(create: (_) => CartProvider()),

        // Sale Provider
        ChangeNotifierProvider(create: (_) => SaleProvider()),

        // Debt Provider
        ChangeNotifierProvider(create: (_) => DebtProvider()),

        // Expense Provider
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),

        // Dashboard Provider
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Magasin Pro',
            debugShowCheckedModeBanner: false,

            // Theme
            themeMode: themeProvider.themeMode,

            // Routes
            initialRoute: AppRoutes.splash,
          );
        },
      ),
    );
  }
}
