# 📱 Phone Shop — Project Guide

> **Purpose**: This file exists to guide AI assistants (Antigravity / Gemini) on the structure, conventions, patterns, and decisions made in this project. Read this before making any changes.

---

## 🗂️ Project Overview

| Field | Value |
|---|---|
| **App Name** | Magasin Pro (`phone_shop`) |
| **Framework** | Flutter (Dart) |
| **Target Platforms** | Windows Desktop, Android, iOS |
| **Database** | SQLite via `sqflite` + `sqflite_common_ffi` (for desktop) |
| **State Management** | Provider (`provider ^6.1.2`) |
| **Architecture** | MVVM-inspired (Models → Repositories → Providers → Views) |
| **Design Size** | 1920×1080 (ScreenUtil base) |
| **Version** | 1.0.0+1 |

---

## 🧱 Architecture

```
lib/
├── main.dart                   # App entry, DB init, Provider tree, MaterialApp
├── routes/
│   └── app_router.dart         # Centralized named-route generator (AppRouter.generateRoute)
├── core/
│   ├── constants/
│   │   ├── app_routes.dart     # All named route strings (AppRoutes.xxx)
│   │   ├── app_colors.dart     # Color palette
│   │   ├── app_constants.dart  # Global app-wide constants
│   │   └── app_strings.dart    # Hardcoded string keys (fallback for i18n)
│   ├── themes/
│   │   ├── app_theme.dart      # Theme definitions (light/dark) — currently minimal
│   │   └── text_styles.dart    # Shared TextStyle definitions
│   ├── localization/
│   │   └── app_localizations.dart  # Custom localization delegate (EN + FR)
│   ├── errors/                 # Error types/handlers (explore as needed)
│   └── utils/                  # Utility functions (explore as needed)
├── data/
│   ├── database/
│   │   ├── database_helper.dart  # Singleton DB helper (SQLite, migrations, CRUD helpers)
│   │   └── tables.dart           # Table name constants
│   ├── models/                   # Pure data classes with fromMap/toMap
│   │   ├── product_model.dart
│   │   ├── category_model.dart
│   │   ├── customer_model.dart
│   │   ├── sales_model.dart
│   │   ├── sales_item_model.dart
│   │   ├── debt_model.dart
│   │   ├── debt_payement_model.dart
│   │   ├── expense_model.dart
│   │   ├── stock_adjustment_model.dart
│   │   ├── cart_item_model.dart
│   │   ├── dashboard_stats_model.dart
│   │   ├── payment_method.dart
│   │   └── user_model.dart
│   └── repositories/             # All DB I/O logic; called by Providers
│       ├── product_repository.dart
│       ├── category_repository.dart
│       ├── customer_repository.dart
│       ├── sale_repository.dart
│       ├── debt_repository.dart
│       ├── expense_repository.dart
│       ├── stock_repository.dart
│       └── user_repository.dart
├── providers/                    # ChangeNotifier classes; bridge between repo & UI
│   ├── auth_provider.dart
│   ├── product_provider.dart
│   ├── category_provider.dart
│   ├── customer_provider.dart
│   ├── cart_provider.dart
│   ├── sale_provider.dart
│   ├── debt_provider.dart
│   ├── expense_provider.dart
│   ├── stock_provider.dart
│   ├── dashborad_provider.dart   # NOTE: typo in filename — keep for consistency
│   ├── theme_provider.dart
│   └── locale_provider.dart
├── viewmodels/                   # Currently empty — reserved for future ViewModel classes
├── views/                        # UI screens, one folder per feature
│   ├── auth/
│   │   ├── splash_screen.dart
│   │   └── login_screen.dart
│   ├── dashboard/
│   │   └── dashbord_screen.dart  # NOTE: typo — keep for consistency
│   ├── products/
│   │   └── product_Screen.dart
│   ├── categories/
│   │   └── categories_Screen.dart
│   ├── pos/
│   │   └── pos_screen.dart       # Point of Sale / cashier screen
│   ├── customers/
│   │   └── customers_screen.dart
│   ├── sales/
│   │   └── sales_screens.dart
│   ├── debts/
│   │   └── debts_screen.dart
│   ├── expenses/
│   │   └── expenses_screen.dart
│   ├── stock/
│   │   └── stock_screen.dart
│   └── shared/                   # Shared/reusable widgets used across screens
└── l10n/                         # (ARB localization files, if any)
```

---

## 🚦 Routing

All routes are **named routes** defined in `AppRoutes` (`core/constants/app_routes.dart`) and registered in `AppRouter.generateRoute` (`routes/app_router.dart`).

**Current routes:**
| Route Name | Screen |
|---|---|
| `AppRoutes.splash` | `SplashScreen` |
| `AppRoutes.login` | `LoginScreen` |
| `AppRoutes.dashboard` | `DashboardScreen` |
| `AppRoutes.products` | `ProductsScreen` |
| `AppRoutes.categories` | `CategoriesScreen` |
| `AppRoutes.pos` | `PosScreen` |
| `AppRoutes.customers` | `CustomersScreen` |
| `AppRoutes.sales` | `SalesScreen` |
| `AppRoutes.debts` | `DebtsScreen` |
| `AppRoutes.expenses` | `ExpensesScreen` |
| `AppRoutes.stock` | `StockScreen` |

**To add a new screen:**
1. Create the screen file under `lib/views/<feature>/`.
2. Add the route string constant in `app_routes.dart`.
3. Register the route case in `app_router.dart`.

---

## 🗃️ Database

- Uses **SQLite** with `sqflite` on Android/iOS and `sqflite_common_ffi` on Windows/Linux/macOS.
- The platform switch happens in `main()` before `runApp`.
- `DatabaseHelper` is a **singleton** (`DatabaseHelper.instance`).
- Table names are defined in `tables.dart` to avoid magic strings.
- **Migration** logic (schema versioning) is handled inside `DatabaseHelper`.

---

## 🔌 State Management (Provider)

All providers are registered at the root in `main.dart` via `MultiProvider`. They are all `ChangeNotifier`-based.

**Pattern used:**
```
UI (View) → calls Provider method → Provider calls Repository → Repository queries DB → notifyListeners()
```

**Provider registration order in `main.dart`:**
`ThemeProvider` → `AuthProvider` → `CategoryProvider` → `ProductProvider` → `CustomerProvider` → `CartProvider` → `SaleProvider` → `DebtProvider` → `ExpenseProvider` → `DashboardProvider` → `StockProvider` → `LocaleProvider`

---

## 🌐 Localization

- Supports **English** (`en`) and **French** (`fr`).
- Custom delegate: `AppLocalizations` in `core/localization/app_localizations.dart`.
- Uses Flutter's standard `flutter_localizations` package for Material/Cupertino delegates.
- `LocaleProvider` manages the active locale at runtime.
- `flutter: generate: true` is set in `pubspec.yaml` (ARB-based generation enabled).

---

## 🎨 Theme & Styling

- `ThemeProvider` manages `ThemeMode` (light / dark).
- Shared colors are in `core/constants/app_colors.dart`.
- Shared text styles are in `core/themes/text_styles.dart`.
- `app_theme.dart` is currently a stub — full theme data goes there.
- **ScreenUtil** is used for responsive sizing: design base is `1920×1080`.

---

## 📦 Key Dependencies

| Package | Purpose |
|---|---|
| `provider ^6.1.2` | State management |
| `sqflite ^2.3.3+2` | SQLite (mobile) |
| `sqflite_common_ffi ^2.3.3+1` | SQLite (desktop) |
| `flutter_screenutil ^5.9.3` | Responsive UI scaling |
| `flutter_localizations` | i18n delegates |
| `intl 0.20.2` | Date/number formatting |
| `image_picker ^1.1.2` | Product image picking |
| `shared_preferences ^2.3.2` | Lightweight key-value storage |
| `fl_chart ^0.69.0` | Charts on Dashboard |
| `path_provider ^2.1.4` | File system paths |
| `path ^1.9.0` | Path manipulation |

---

## ⚠️ Known Typos / Quirks (Do NOT rename these — they break imports)

| Issue | Location |
|---|---|
| `dashborad_provider.dart` | `lib/providers/dashborad_provider.dart` (not `dashboard`) |
| `dashbord_screen.dart` | `lib/views/dashboard/dashbord_screen.dart` (not `dashboard`) |
| `assests/` folder | Root directory (duplicate of `assets/`, likely unused) |
| `viewmodels/` | Directory exists but is **empty** — reserved for future use |

---

## ✅ Conventions to Follow

1. **One screen per file**, placed in the correct feature folder under `lib/views/`.
2. **Repository layer handles all raw DB calls** — providers must NOT use `DatabaseHelper` directly.
3. **Providers handle business logic + state** — screens only read state and call provider methods.
4. **All new route strings** go in `AppRoutes` constants class, never hardcoded inline.
5. **ScreenUtil sizes**: use `.w`, `.h`, `.sp` extensions for all pixel values in UI code.
6. **Localization**: use `AppLocalizations.of(context)!.yourKey` for any user-facing text.
7. **Do not add dependencies** without checking if an existing package already solves the need.
8. **Do not rename files with typos** listed above — fix via deprecation if needed.

---

## 🔮 Pending / Future Work

- `viewmodels/` folder is empty — future screens may use ViewModel classes there.
- `app_theme.dart` needs full `ThemeData` implementation (light + dark).
- ARB files in `l10n/` may need to be expanded for new features.
- No unit tests exist yet under `test/` — this is a future priority.

---

*Last updated: 2026-05-12 | Generated by Antigravity AI assistant*
