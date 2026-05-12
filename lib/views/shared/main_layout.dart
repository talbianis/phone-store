// lib/views/shared/main_layout.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import 'sidebar_menu.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String currentRoute;

  const MainLayout({
    Key? key,
    required this.child,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          SidebarMenu(currentRoute: currentRoute),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar
                _buildTopBar(context, authProvider),

                // Content
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, AuthProvider authProvider) {
    final l10n = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isFrench = localeProvider.locale.languageCode == 'fr';

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: TextField(
                decoration: InputDecoration(
                  hintText: l10n.searchProduct,
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  suffixText: l10n.searchShortcut,
                  suffixStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),

          // Date Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  DateFormat.yMMMEd(
                    Localizations.localeOf(context).toString(),
                  ).format(DateTime.now()),
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // ✅ Language Switcher
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                _buildLangButton(
                  label: l10n.langCodeEn,
                  isSelected: !isFrench,
                  onTap: () => localeProvider.setLocale(const Locale('en')),
                  isLeft: true,
                ),
                _buildLangButton(
                  label: l10n.langCodeFr,
                  isSelected: isFrench,
                  onTap: () => localeProvider.setLocale(const Locale('fr')),
                  isLeft: false,
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Notifications
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // User Profile
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  authProvider.currentUser?.fullName[0].toUpperCase() ?? 'A',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authProvider.currentUser?.fullName ?? l10n.guestUser,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    authProvider.currentUser?.role ?? l10n.admin,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Individual language button
  Widget _buildLangButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isLeft,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? const Radius.circular(7) : Radius.zero,
            right: !isLeft ? const Radius.circular(7) : Radius.zero,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
