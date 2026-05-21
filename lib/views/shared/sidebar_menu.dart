// lib/views/shared/sidebar_menu.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/layout/desktop_adaptive.dart';
import '../../core/constants/app_routes.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/auth_provider.dart';

class SidebarMenu extends StatelessWidget {
  final String currentRoute;

  const SidebarMenu({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final sidebarBackground = isDark ? const Color(0xFF101828) : colors.surface;
    final primaryText = isDark ? Colors.white : colors.onSurface;
    final secondaryText =
        isDark ? Colors.white.withOpacity(0.68) : colors.onSurfaceVariant;
    final dividerColor =
        isDark ? Colors.white.withOpacity(0.10) : theme.dividerColor;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: sidebarBackground,
        border: Border(
          right: BorderSide(color: dividerColor),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: desktopSidebarInset(context),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 107, 142, 199),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/icons/app_icon.png',
                  ),
                ),
                const SizedBox(width: 7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.sidebarTitleShort,
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.sidebarSubtitle,
                      maxLines: 2,
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 9,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: dividerColor, height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: Text(
              l10n.mainMenu,
              style: TextStyle(
                color: secondaryText,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.dashboard,
                  label: l10n.dashboard,
                  route: AppRoutes.dashboard,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.inventory_2_outlined,
                  label: l10n.products,
                  route: AppRoutes.products,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.category_outlined,
                  label: l10n.categories,
                  route: AppRoutes.categories,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.shopping_cart_outlined,
                  label: l10n.pos,
                  route: AppRoutes.pos,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.people_outline,
                  label: l10n.customers,
                  route: AppRoutes.customers,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.receipt_long_outlined,
                  label: l10n.sales,
                  route: AppRoutes.sales,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.credit_card_outlined,
                  label: l10n.debts,
                  route: AppRoutes.debts,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.outbond,
                  label: l10n.expenses,
                  route: AppRoutes.expenses,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.store_outlined,
                  label: l10n.stock,
                  route: AppRoutes.stock,
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(12),
          //   child: _buildMenuItem(
          //     context,
          //     icon: Icons.logout,
          //     label: l10n.logout,
          //     route: 'logout',
          //     onTap: () async {
          //       await authProvider.logout();
          //       if (context.mounted) {
          //         Navigator.pushReplacementNamed(context, AppRoutes.login);
          //       }
          //     },
          //   ),
          // ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: dividerColor),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: 20,
                  child: Text(
                    authProvider.currentUser?.fullName[0].toUpperCase() ?? 'A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.currentUser?.fullName ?? l10n.guestUser,
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        authProvider.currentUser?.role ?? l10n.admin,
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    VoidCallback? onTap,
  }) {
    final isActive = currentRoute == route;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final inactiveColor =
        isDark ? Colors.white.withOpacity(0.72) : colors.onSurfaceVariant;
    final hoverColor =
        isDark ? Colors.white.withOpacity(0.06) : colors.surfaceVariant;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ??
              () {
                if (route != 'logout') {
                  Navigator.pushReplacementNamed(context, route);
                }
              },
          borderRadius: BorderRadius.circular(8),
          hoverColor: hoverColor,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? Colors.white : inactiveColor,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isActive ? Colors.white : inactiveColor,
                      fontSize: 13,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isActive) ...[
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
