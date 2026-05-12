// lib/main.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:phone_shop/core/localization/app_localizations.dart';

import 'package:phone_shop/providers/dashborad_provider.dart';
import 'package:phone_shop/providers/locale_provider.dart';
import 'package:phone_shop/providers/stock_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    debugPrint('🖥️ Desktop platform detected - using sqflite_ffi');
  } else {
    debugPrint('📱 Mobile platform detected - using standard sqflite');
  }

  await _initializeDatabase();

  runApp(const MyApp());
}

Future<void> _initializeDatabase() async {
  try {
    final db = await DatabaseHelper.instance.database;
    debugPrint('✅ Database initialized successfully');
    debugPrint('📁 Database path: ${db.path}');
  } catch (e) {
    debugPrint('❌ Error initializing database: $e');
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
        ChangeNotifierProvider(create: (_) => StockProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return ScreenUtilInit(
            designSize: const Size(1920, 1080),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context).magasinPro,
                debugShowCheckedModeBanner: false,

                // ✅ Locale
                locale: localeProvider.locale,
                supportedLocales: const [
                  Locale('en'),
                  Locale('fr'),
                ],
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],

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
