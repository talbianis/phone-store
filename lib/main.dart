// lib/main.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ⬅️ ADD THIS
import 'package:phone_shop/providers/dashborad_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'core/constants/app_routes.dart';
// ⬅️ ADD THIS
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

  // Initialize database factory for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    print('🖥️ Desktop platform detected - using sqflite_ffi');
  } else {
    print('📱 Mobile platform detected - using standard sqflite');
  }

  // Initialize database
  await _initializeDatabase();

  runApp(const MyApp());
}

// Database initialization function
Future<void> _initializeDatabase() async {
  try {
    final db = await DatabaseHelper.instance.database;
    print('✅ Database initialized successfully');
    print('📁 Database path: ${await db.path}');
  } catch (e) {
    print('❌ Error initializing database: $e');
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => SaleProvider()),
        ChangeNotifierProvider(create: (_) => DebtProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // ⬅️ WRAP MaterialApp with ScreenUtilInit
          return ScreenUtilInit(
            // Design size (reference design dimensions)
            // Use your design's dimensions (Figma/Adobe XD)
            // Common sizes: 375x812 (iPhone), 1920x1080 (Desktop)
            designSize: const Size(1920, 1080), // ⬅️ Desktop design size

            // Minimum text adapt size
            minTextAdapt: true,

            // Split screen mode support
            splitScreenMode: true,

            // Builder
            builder: (context, child) {
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
          );
        },
      ),
    );
  }
}
