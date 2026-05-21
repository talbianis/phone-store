import 'package:flutter/material.dart';

class ThemedScreenSections {
  const ThemedScreenSections._();

  static Color surface(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  static Color mutedText(BuildContext context) {
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  static Color bodyText(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  static Color subtleSurface(BuildContext context, {Color? accentColor}) {
    final theme = Theme.of(context);
    if (accentColor != null) {
      return accentColor.withOpacity(
        theme.brightness == Brightness.dark ? 0.14 : 0.07,
      );
    }
    return theme.colorScheme.surfaceVariant.withOpacity(
      theme.brightness == Brightness.dark ? 0.55 : 0.75,
    );
  }

  static Color emptyIcon(BuildContext context) {
    return Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.45);
  }

  static BoxDecoration cardDecoration(
    BuildContext context, {
    double radius = 12,
    Color? borderColor,
    double borderWidth = 1,
    bool shadow = true,
  }) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderColor ?? theme.dividerColor,
        width: borderWidth,
      ),
      boxShadow: shadow
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(
                  theme.brightness == Brightness.dark ? 0.22 : 0.08,
                ),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );
  }

  static BoxDecoration panelDecoration(
    BuildContext context, {
    double radius = 8,
    Color? color,
  }) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: color ?? theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: theme.dividerColor),
    );
  }

  static TextStyle titleStyle(
    BuildContext context, {
    required double fontSize,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle subtitleStyle(
    BuildContext context, {
    required double fontSize,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}
