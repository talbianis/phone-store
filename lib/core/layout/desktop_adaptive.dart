// lib/core/layout/desktop_adaptive.dart
//
// Responsive helpers for Flutter Desktop: window resize, multi-monitor widths,
// and ultrawide layouts without mobile-first assumptions.

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Logical breakpoints for **desktop window** width (not mobile breakpoints).
abstract final class DesktopBreakpoints {
  static const double compact = 920;
  static const double medium = 1280;
  static const double comfortable = 1600;
  static const double ultrawide = 2200;
}

double _clampDouble(double v, double min, double max) =>
    math.min(math.max(v, min), max);

/// Full scaffold width (typically MediaQuery.sizeOf(context).width).
double desktopViewportWidth(BuildContext context) =>
    MediaQuery.sizeOf(context).width;

double desktopViewportHeight(BuildContext context) =>
    MediaQuery.sizeOf(context).height;

bool desktopIsCompactWidth(BuildContext context) =>
    desktopViewportWidth(context) < DesktopBreakpoints.compact;

bool desktopIsMediumWidth(BuildContext context) {
  final w = desktopViewportWidth(context);
  return w >= DesktopBreakpoints.compact && w < DesktopBreakpoints.medium;
}

/// Sidebar: scales slightly with window, clamped for readability.
double desktopSidebarWidth(double totalViewportWidth) {
  return _clampDouble(totalViewportWidth * 0.132, 208.0, 288.0);
}

/// Top app bar height scales modestly with window height.
double desktopTopBarHeight(BuildContext context) {
  final h = desktopViewportHeight(context);
  return _clampDouble(h * 0.065, 56.0, 78.0);
}

/// Page padding scales with window; avoids huge gutters on ultrawide when used
/// inside a max-width content column.
EdgeInsets desktopPagePadding(BuildContext context) {
  final w = desktopViewportWidth(context);
  final h = desktopViewportHeight(context);
  final horizontal = _clampDouble(w * 0.0125, 12.0, 32.0);
  final vertical = _clampDouble(h * 0.018, 12.0, 28.0);
  return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
}

/// Primary page titles (dashboard, POS, etc.)
double desktopPageTitleFontSize(BuildContext context) {
  final w = desktopViewportWidth(context);
  return _clampDouble(w * 0.0175, 22.0, 30.0);
}

double desktopPageSubtitleFontSize(BuildContext context) {
  final w = desktopViewportWidth(context);
  return _clampDouble(w * 0.009, 13.0, 15.0);
}

double desktopSectionTitleFontSize(BuildContext context) {
  final w = desktopViewportWidth(context);
  return _clampDouble(w * 0.011, 16.0, 19.0);
}

/// Search field in shell top bar: caps width so ultrawide does not stretch inputs.
double desktopTopSearchMaxWidth(double contentAreaWidth) {
  return math.min(440.0, contentAreaWidth * 0.42);
}

/// Padding inside the sidebar chrome (logo / menu sections).
EdgeInsets desktopSidebarInset(BuildContext context) {
  final inset =
      _clampDouble(desktopViewportWidth(context) * 0.013, 16.0, 28.0);
  return EdgeInsets.all(inset);
}

/// Optional max width for centered content on very wide monitors.
double? desktopContentMaxWidth(BuildContext context) {
  final w = desktopViewportWidth(context);
  if (w > DesktopBreakpoints.ultrawide) return 1760;
  return null;
}

/// Wraps [child] in a centered [ConstrainedBox] when ultrawide limits apply.
Widget desktopConstrainContent(BuildContext context, Widget child) {
  final maxW = desktopContentMaxWidth(context);
  if (maxW == null) return child;
  return Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxW),
      child: child,
    ),
  );
}

/// How many columns for dashboard-style stat cards.
int desktopStatColumns(double contentWidth) {
  if (contentWidth < 720) return 1;
  if (contentWidth < 1100) return 2;
  if (contentWidth < DesktopBreakpoints.medium) return 3;
  return 4;
}

/// Whether chart + side panel should stack vertically.
bool desktopShouldStackDashboardCharts(double contentWidth) =>
    contentWidth < DesktopBreakpoints.compact + 80;
