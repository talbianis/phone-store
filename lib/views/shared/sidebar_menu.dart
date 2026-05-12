// lib/views/shared/sidebar_menu.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/auth_provider.dart';

class SidebarMenu extends StatelessWidget {
  final String currentRoute;

  const SidebarMenu({
    Key? key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      width: 250,
      color: AppColors.sidebarBackground,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.store,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.sidebarTitleShort,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.sidebarSubtitle,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white12, height: 1),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: Text(
              l10n.mainMenu,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
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

          Padding(
            padding: const EdgeInsets.all(12),
            child: _buildMenuItem(
              context,
              icon: Icons.logout,
              label: l10n.logout,
              route: 'logout',
              onTap: () async {
                await authProvider.logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                }
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.1)),
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        authProvider.currentUser?.role ?? l10n.admin,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
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
                  color: isActive ? Colors.white : Colors.white70,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.white70,
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                if (isActive) ...[
                  const Spacer(),
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
