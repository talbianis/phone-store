// lib/main.dart

import 'dart:io'; // ⬅️ ADD THIS
import 'package:flutter/material.dart';
import 'package:phone_shop/providers/dashborad_provider.dart';
import 'package:provider/provider.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // ⬅️ ADD THIS

import 'core/constants/app_routes.dart';
import 'data/database/database_helper.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/category_provider.dart';
import 'providers/customer_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/sale_provider.dart';
import 'providers/debt_provider.dart';
import 'providers/expense_provider.dart';

import 'providers/theme_provider.dart';
import 'routes/app_router.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // ⬅️ CRITICAL: Initialize database factory for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Initialize FFI for desktop
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize database
  await _initializeDatabase();

  runApp(const MyApp());
}

// Database initialization function
Future<void> _initializeDatabase() async {
  try {
    // This will create the database and tables if they don't exist
    final db = await DatabaseHelper.instance.database;

    print('📁 Database path: ${await db.path}');
  } catch (e) {
    rethrow; // Re-throw to see full error
  }
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
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
