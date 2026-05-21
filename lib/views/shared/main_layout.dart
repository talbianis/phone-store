// lib/views/shared/main_layout.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/layout/desktop_adaptive.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/product_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/theme_provider.dart';
import 'sidebar_menu.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProductProvider>().ensureProductsLoaded();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final sidebarW = desktopSidebarWidth(constraints.maxWidth);
        final contentW =
            (constraints.maxWidth - sidebarW).clamp(200.0, double.infinity);

        return Scaffold(
          body: Row(
            children: [
              SizedBox(
                width: sidebarW,
                child: SidebarMenu(currentRoute: widget.currentRoute),
              ),
              Expanded(
                child: Column(
                  children: [
                    _buildTopBar(context, authProvider, contentW),
                    Expanded(child: widget.child),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    AuthProvider authProvider,
    double contentAreaWidth,
  ) {
    final l10n = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isFrench = localeProvider.locale.languageCode == 'fr';
    final barHeight = desktopTopBarHeight(context);
    final tight = contentAreaWidth < 780;
    final padH = tight ? 12.0 : 24.0;
    final hintSize = tight ? 13.0 : 14.0;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      height: barHeight,
      padding: EdgeInsets.symmetric(horizontal: padH),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: desktopTopSearchMaxWidth(contentAreaWidth),
                ),
                child: _ProductSearchField(
                  currentRoute: widget.currentRoute,
                  hintSize: hintSize,
                  showShortcut: !tight,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _DatePill(tight: tight),
                    SizedBox(width: tight ? 8 : 16),
                    Container(
                      decoration: BoxDecoration(
                        color: colors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Row(
                        children: [
                          _buildLangButton(
                            context: context,
                            label: l10n.langCodeEn,
                            isSelected: !isFrench,
                            onTap: () =>
                                localeProvider.setLocale(const Locale('en')),
                            isLeft: true,
                          ),
                          _buildLangButton(
                            context: context,
                            label: l10n.langCodeFr,
                            isSelected: isFrench,
                            onTap: () =>
                                localeProvider.setLocale(const Locale('fr')),
                            isLeft: false,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: tight ? 8 : 16),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      color: colors.onSurfaceVariant,
                      onPressed: () {},
                    ),
                    SizedBox(width: tight ? 8 : 16),
                    _ProfileDropdown(authProvider: authProvider, tight: tight),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLangButton({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isLeft,
  }) {
    final colors = Theme.of(context).colorScheme;

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
            color: isSelected ? Colors.white : colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _ProductSearchField extends StatelessWidget {
  final String currentRoute;
  final double hintSize;
  final bool showShortcut;

  const _ProductSearchField({
    required this.currentRoute,
    required this.hintSize,
    required this.showShortcut,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        return Autocomplete<ProductModel>(
          displayStringForOption: (product) => product.name,
          optionsBuilder: (textEditingValue) {
            final query = textEditingValue.text.trim();
            if (query.isEmpty) {
              return const <ProductModel>[];
            }
            final lowerQuery = query.toLowerCase();
            return productProvider.allProducts.where((product) {
              return product.quantity > 0 &&
                  product.name.toLowerCase().contains(lowerQuery);
            }).take(8);
          },
          onSelected: (product) => _runSearch(context, product.name),
          fieldViewBuilder: (
            context,
            controller,
            focusNode,
            onFieldSubmitted,
          ) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              style: TextStyle(color: colors.onSurface, fontSize: hintSize),
              decoration: InputDecoration(
                hintText: l10n.searchProduct,
                hintStyle: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: hintSize,
                ),
                prefixIcon: Icon(Icons.search, color: colors.onSurfaceVariant),
                suffixText: showShortcut ? l10n.searchShortcut : null,
                suffixStyle: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 12,
                ),
                filled: true,
                fillColor: colors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) => context
                  .read<ProductProvider>()
                  .searchAvailableProductsByName(value),
              onSubmitted: (value) => _runSearch(context, value),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return _ProductSearchResults(
              options: options.toList(),
              onSelected: onSelected,
            );
          },
        );
      },
    );
  }

  void _runSearch(BuildContext context, String query) {
    final cleanedQuery = query.trim();
    context.read<ProductProvider>().searchAvailableProductsByName(cleanedQuery);
    if (cleanedQuery.isNotEmpty && currentRoute != AppRoutes.products) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.products);
    }
  }
}

class _ProductSearchResults extends StatelessWidget {
  final List<ProductModel> options;
  final AutocompleteOnSelected<ProductModel> onSelected;

  const _ProductSearchResults({
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 10,
        color: colors.surface,
        borderRadius: BorderRadius.circular(10),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 320, maxWidth: 460),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 6),
            shrinkWrap: true,
            itemCount: options.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
            itemBuilder: (context, index) {
              final product = options[index];
              return InkWell(
                onTap: () => onSelected(product),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          size: 18,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colors.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${CurrencyFormatter.format(product.sellingPrice)}  -  Qty ${product.quantity}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: colors.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DatePill extends StatelessWidget {
  final bool tight;

  const _DatePill({required this.tight});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: tight ? 10 : 16, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            size: 16,
            color: colors.onSurfaceVariant,
          ),
          if (!tight) ...[
            const SizedBox(width: 8),
            Text(
              DateFormat.yMMMEd(
                Localizations.localeOf(context).toString(),
              ).format(DateTime.now()),
              style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfileDropdown extends StatelessWidget {
  final AuthProvider authProvider;
  final bool tight;

  const _ProfileDropdown({
    required this.authProvider,
    required this.tight,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final isDark = themeProvider.isDarkMode;
    final isFrench = localeProvider.locale.languageCode == 'fr';

    final fullName = authProvider.currentUser?.fullName ?? l10n.guestUser;
    final role = authProvider.currentUser?.role ?? l10n.admin;
    final initial = fullName.isNotEmpty ? fullName[0].toUpperCase() : 'A';

    return PopupMenuButton<String>(
      offset: const Offset(0, 52),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      elevation: 8,
      color: colors.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (!tight) ...[
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 6),
              Icon(Icons.keyboard_arrow_down, color: colors.onSurfaceVariant),
            ],
          ],
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  initial,
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
                      fullName,
                      style: TextStyle(
                        color: colors.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'theme',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Icon(
                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                size: 20,
                color: colors.onSurface,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isDark
                      ? (isFrench ? 'Mode Clair' : 'Light Mode')
                      : (isFrench ? 'Mode Sombre' : 'Dark Mode'),
                  style: TextStyle(fontSize: 14, color: colors.onSurface),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 42,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isDark ? AppColors.primary : colors.outline,
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  alignment:
                      isDark ? Alignment.centerRight : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'lang_en',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Text('EN',
                  style: TextStyle(fontSize: 14, color: colors.onSurface)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isFrench ? 'Anglais' : 'English',
                  style: TextStyle(fontSize: 14, color: colors.onSurface),
                ),
              ),
              if (!isFrench)
                const Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'lang_fr',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Text('FR',
                  style: TextStyle(fontSize: 14, color: colors.onSurface)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isFrench ? 'Francais' : 'French',
                  style: TextStyle(fontSize: 14, color: colors.onSurface),
                ),
              ),
              if (isFrench)
                const Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'logout',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              const Icon(Icons.logout_rounded,
                  size: 20, color: Colors.redAccent),
              const SizedBox(width: 12),
              Text(
                isFrench ? 'Deconnexion' : 'Logout',
                style: const TextStyle(fontSize: 14, color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) async {
        switch (value) {
          case 'theme':
            context.read<ThemeProvider>().toggleTheme();
            break;
          case 'lang_en':
            context.read<LocaleProvider>().setLocale(const Locale('en'));
            break;
          case 'lang_fr':
            context.read<LocaleProvider>().setLocale(const Locale('fr'));
            break;
          case 'logout':
            await _confirmLogout(context, isFrench);
            break;
        }
      },
    );
  }

  Future<void> _confirmLogout(BuildContext context, bool isFrench) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 22),
            const SizedBox(width: 10),
            Text(
              isFrench ? 'Deconnexion' : 'Logout',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          isFrench
              ? 'Etes-vous sur de vouloir vous deconnecter ?'
              : 'Are you sure you want to logout?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(isFrench ? 'Annuler' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(isFrench ? 'Deconnexion' : 'Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthProvider>().logout();
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (_) => false,
        );
      }
    }
  }
}
