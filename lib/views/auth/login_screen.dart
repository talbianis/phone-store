// lib/views/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/core/localization/app_localizations.dart';
import 'package:phone_shop/core/themes/text_styles.dart';
import 'package:phone_shop/views/auth/widgets/login_form.dart';

import '../../core/constants/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: BoxConstraints(
                maxWidth:
                    (size.width * 0.42).clamp(320.0, 520.0),
              ),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.store,
                          size: 48,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Title
                      Text(l10n.login, style: TextStyles.body),

                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        l10n.loginSubtitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Login Form
                      const LoginForm(),

                      const SizedBox(height: 24),

                      // Footer
                      Text(
                        l10n.version,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
