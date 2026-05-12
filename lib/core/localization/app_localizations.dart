import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _translations = {
    'en': {
      'appName': 'Phone Shop',
      'login': 'Login',
      'loginSubtitle': 'Sign in to your account',
      'version': 'Version 1.0.0',
      'logout': 'Logout',
      'username': 'Username',
      'password': 'Password',
      'loginButton': 'Sign In',
      'invalidCredentials': 'Invalid username or password',
      'dashboard': 'Dashboard',
      'todaySales': "Today's Sales",
      'usernameHint': 'Enter your username',
      'passwordHint': 'Enter your password',
      'rememberMe': 'Remember me',
      'defaultCredentials': 'Default credentials:',
      'defaultUser': 'Username: admin',
      'defaultPassword': 'Password: admin123',
      'todayProfit': "Today's Profit",
      'transactions': 'Transactions',
      'dashboardSubtitle': 'Overview of your phone shop performance',
      'vsYesterday': 'vs yesterday',
      'totalProducts': 'Total Products',
      'items': 'Items',
      'lowStockAlerts': 'Low Stock Alerts',
      'bestSellingProducts': 'Best Selling Products',
      'salesTrend': '7-Day Sales Trend',
      'categories': 'Categories',
      'addCategory': 'Add Category',
      'editCategory': 'Edit Category',
      'deleteCategory': 'Delete Category',
      'categoryName': 'Category Name',
      'noCategories': 'No categories found',
      'products': 'Products',
      'addProduct': 'Add Product',
      'editProduct': 'Edit Product',
      'deleteProduct': 'Delete Product',
      'productName': 'Product Name',
      'barcode': 'Barcode',
      'buyingPrice': 'Buying Price',
      'sellingPrice': 'Selling Price',
      'quantity': 'Quantity',
      'inStock': 'In Stock',
      'lowStock': 'Low Stock',
      'outOfStock': 'Out of Stock',
      'noProducts': 'No products found',
      'pos': 'Point of Sale',
      'cart': 'Cart',
      'addToCart': 'Add to Cart',
      'removeFromCart': 'Remove',
      'clearCart': 'Clear Cart',
      'subtotal': 'Subtotal',
      'discount': 'Discount',
      'total': 'Total',
      'checkout': 'Checkout',
      'searchProduct': 'Search product or scan barcode...',
      'selectCustomer': 'Select Customer (optional)',
      'paymentMethod': 'Payment Method',
      'cash': 'Cash',
      'card': 'Card',
      'debt': 'Credit/Debt',
      'mixed': 'Mixed',
      'amountPaid': 'Amount Paid',
      'change': 'Change',
      'processPayment': 'Process Payment',
      'saleSuccess': 'Sale completed successfully!',
      'invoiceNumber': 'Invoice',
      'fixedDiscount': 'Fixed Amount',
      'percentageDiscount': 'Percentage',
      'customers': 'Customers',
      'addCustomer': 'Add Customer',
      'editCustomer': 'Edit Customer',
      'deleteCustomer': 'Delete Customer',
      'customerName': 'Full Name',
      'phone': 'Phone Number',
      'email': 'Email',
      'address': 'Address',
      'totalDebt': 'Total Debt',
      'totalPurchases': 'Total Purchases',
      'noCustomers': 'No customers found',
      'recordPayment': 'Record Payment',
      'sales': 'Sales History',
      'today': 'Today',
      'thisWeek': 'This Week',
      'thisMonth': 'This Month',
      'allTime': 'All Time',
      'customRange': 'Custom Range',
      'totalSales': 'Total Sales',
      'totalProfit': 'Total Profit',
      'transactionCount': 'Transactions',
      'averageSale': 'Average Sale',
      'searchInvoice': 'Search by invoice or customer...',
      'saleDetails': 'Sale Details',
      'noSales': 'No sales found',
      'debts': 'Debts',
      'allDebts': 'All',
      'unpaid': 'Unpaid',
      'partial': 'Partial',
      'paid': 'Paid',
      'addPayment': 'Add Payment',
      'paymentHistory': 'Payment History',
      'remainingAmount': 'Remaining',
      'paidAmount': 'Paid',
      'noDebts': 'No debts found',
      'debtStatus': 'Status',
      'expenses': 'Expenses',
      'addExpense': 'Add Expense',
      'editExpense': 'Edit Expense',
      'deleteExpense': 'Delete Expense',
      'expenseCategory': 'Category',
      'amount': 'Amount',
      'description': 'Description',
      'date': 'Date',
      'rent': 'Rent',
      'utilities': 'Utilities',
      'salaries': 'Salaries',
      'supplies': 'Supplies',
      'marketing': 'Marketing',
      'maintenance': 'Maintenance',
      'transport': 'Transport',
      'other': 'Other',
      'noExpenses': 'No expenses found',
      'revenueVsExpenses': 'Revenue vs Expenses',
      'netProfit': 'Net Profit',
      'stock': 'Stock Management',
      'addStock': 'Add Stock',
      'removeStock': 'Remove Stock',
      'stockHistory': 'Stock History',
      'adjustmentType': 'Adjustment Type',
      'reason': 'Reason',
      'restock': 'Restock',
      'returnFromCustomer': 'Return from Customer',
      'correction': 'Correction',
      'damage': 'Damage',
      'theft': 'Theft',
      'returnToSupplier': 'Return to Supplier',
      'stockValue': 'Stock Value',
      'noAdjustments': 'No stock adjustments found',
      'settings': 'Settings',
      'language': 'Language',
      'english': 'English',
      'french': 'French',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'add': 'Add',
      'search': 'Search',
      'filter': 'Filter',
      'confirm': 'Confirm',
      'confirmDelete': 'Are you sure you want to delete this?',
      'yes': 'Yes',
      'no': 'No',
      'error': 'Error',
      'success': 'Success',
      'loading': 'Loading...',
      'noData': 'No data available',
      'required': 'This field is required',
      'invalidPhone': 'Invalid phone number',
      'invalidPrice': 'Invalid price',
      'invalidQuantity': 'Invalid quantity',
      'admin': 'Administrator',
      'employee': 'Employee',
      'role': 'Role',
      'profit': 'Profit',
      'revenue': 'Revenue',
      'currency': 'DA',
    },
    'fr': {
      'appName': 'Boutique Téléphones',
      'login': 'Connexion',
      'logout': 'Déconnexion',
      'loginSubtitle': 'Connectez-vous à votre compte',
      'version': 'Version 1.0.0',
      'username': "Nom d'utilisateur",
      'dashboardSubtitle': 'Aperçu des performances de votre boutique',
      'vsYesterday': 'vs hier',
      'totalProducts': 'Total produits',
      'items': 'Articles',
      'password': 'Mot de passe',
      'usernameHint': 'Entrez votre nom d\'utilisateur',
      'passwordHint': 'Entrez votre mot de passe',
      'rememberMe': 'Se souvenir de moi',
      'defaultCredentials': 'Identifiants par défaut:',
      'defaultUser': 'Utilisateur: admin',
      'defaultPassword': 'Mot de passe: admin123',
      'loginButton': 'Se connecter',
      'invalidCredentials': "Nom d'utilisateur ou mot de passe incorrect",
      'dashboard': 'Tableau de bord',
      'todaySales': 'Ventes du jour',
      'todayProfit': 'Bénéfice du jour',
      'transactions': 'Transactions',
      'lowStockAlerts': 'Alertes stock faible',
      'bestSellingProducts': 'Produits les plus vendus',
      'salesTrend': 'Tendance des ventes (7 jours)',
      'categories': 'Catégories',
      'addCategory': 'Ajouter une catégorie',
      'editCategory': 'Modifier la catégorie',
      'deleteCategory': 'Supprimer la catégorie',
      'categoryName': 'Nom de la catégorie',
      'noCategories': 'Aucune catégorie trouvée',
      'products': 'Produits',
      'addProduct': 'Ajouter un produit',
      'editProduct': 'Modifier le produit',
      'deleteProduct': 'Supprimer le produit',
      'productName': 'Nom du produit',
      'barcode': 'Code-barres',
      'buyingPrice': "Prix d'achat",
      'sellingPrice': 'Prix de vente',
      'quantity': 'Quantité',
      'inStock': 'En stock',
      'lowStock': 'Stock faible',
      'outOfStock': 'Rupture de stock',
      'noProducts': 'Aucun produit trouvé',
      'pos': 'Point de vente',
      'cart': 'Panier',
      'addToCart': 'Ajouter au panier',
      'removeFromCart': 'Retirer',
      'clearCart': 'Vider le panier',
      'subtotal': 'Sous-total',
      'discount': 'Remise',
      'total': 'Total',
      'checkout': 'Valider',
      'searchProduct': 'Chercher un produit ou scanner...',
      'selectCustomer': 'Sélectionner un client (optionnel)',
      'paymentMethod': 'Mode de paiement',
      'cash': 'Espèces',
      'card': 'Carte',
      'debt': 'Crédit/Dette',
      'mixed': 'Mixte',
      'amountPaid': 'Montant payé',
      'change': 'Monnaie rendue',
      'processPayment': 'Valider le paiement',
      'saleSuccess': 'Vente effectuée avec succès !',
      'invoiceNumber': 'Facture',
      'fixedDiscount': 'Montant fixe',
      'percentageDiscount': 'Pourcentage',
      'customers': 'Clients',
      'addCustomer': 'Ajouter un client',
      'editCustomer': 'Modifier le client',
      'deleteCustomer': 'Supprimer le client',
      'customerName': 'Nom complet',
      'phone': 'Numéro de téléphone',
      'email': 'E-mail',
      'address': 'Adresse',
      'totalDebt': 'Dette totale',
      'totalPurchases': 'Achats totaux',
      'noCustomers': 'Aucun client trouvé',
      'recordPayment': 'Enregistrer un paiement',
      'sales': 'Historique des ventes',
      'today': "Aujourd'hui",
      'thisWeek': 'Cette semaine',
      'thisMonth': 'Ce mois',
      'allTime': 'Tout',
      'customRange': 'Plage personnalisée',
      'totalSales': 'Total des ventes',
      'totalProfit': 'Bénéfice total',
      'transactionCount': 'Transactions',
      'averageSale': 'Vente moyenne',
      'searchInvoice': 'Chercher par facture ou client...',
      'saleDetails': 'Détails de la vente',
      'noSales': 'Aucune vente trouvée',
      'debts': 'Dettes',
      'allDebts': 'Toutes',
      'unpaid': 'Non payé',
      'partial': 'Partiel',
      'paid': 'Payé',
      'addPayment': 'Ajouter un paiement',
      'paymentHistory': 'Historique des paiements',
      'remainingAmount': 'Reste',
      'paidAmount': 'Payé',
      'noDebts': 'Aucune dette trouvée',
      'debtStatus': 'Statut',
      'expenses': 'Dépenses',
      'addExpense': 'Ajouter une dépense',
      'editExpense': 'Modifier la dépense',
      'deleteExpense': 'Supprimer la dépense',
      'expenseCategory': 'Catégorie',
      'amount': 'Montant',
      'description': 'Description',
      'date': 'Date',
      'rent': 'Loyer',
      'utilities': 'Services publics',
      'salaries': 'Salaires',
      'supplies': 'Fournitures',
      'marketing': 'Marketing',
      'maintenance': 'Maintenance',
      'transport': 'Transport',
      'other': 'Autre',
      'noExpenses': 'Aucune dépense trouvée',
      'revenueVsExpenses': 'Revenus vs Dépenses',
      'netProfit': 'Bénéfice net',
      'stock': 'Gestion du stock',
      'addStock': 'Ajouter du stock',
      'removeStock': 'Retirer du stock',
      'stockHistory': 'Historique du stock',
      'adjustmentType': "Type d'ajustement",
      'reason': 'Raison',
      'restock': 'Réapprovisionnement',
      'returnFromCustomer': 'Retour client',
      'correction': 'Correction',
      'damage': 'Dommage',
      'theft': 'Vol',
      'returnToSupplier': 'Retour fournisseur',
      'stockValue': 'Valeur du stock',
      'noAdjustments': 'Aucun ajustement trouvé',
      'settings': 'Paramètres',
      'language': 'Langue',
      'english': 'Anglais',
      'french': 'Français',
      'save': 'Enregistrer',
      'cancel': 'Annuler',
      'delete': 'Supprimer',
      'edit': 'Modifier',
      'add': 'Ajouter',
      'search': 'Rechercher',
      'filter': 'Filtrer',
      'confirm': 'Confirmer',
      'confirmDelete': 'Êtes-vous sûr de vouloir supprimer ceci ?',
      'yes': 'Oui',
      'no': 'Non',
      'error': 'Erreur',
      'success': 'Succès',
      'loading': 'Chargement...',
      'noData': 'Aucune donnée disponible',
      'required': 'Ce champ est obligatoire',
      'invalidPhone': 'Numéro de téléphone invalide',
      'invalidPrice': 'Prix invalide',
      'invalidQuantity': 'Quantité invalide',
      'admin': 'Administrateur',
      'employee': 'Employé',
      'role': 'Rôle',
      'profit': 'Bénéfice',
      'revenue': 'Revenus',
      'currency': 'DA',
    },
  };

  String get appName => _t('appName');
  String get login => _t('login');
  String get logout => _t('logout');
  String get username => _t('username');
  String get password => _t('password');
  String get loginButton => _t('loginButton');
  String get invalidCredentials => _t('invalidCredentials');
  String get dashboard => _t('dashboard');
  String get todaySales => _t('todaySales');
  String get todayProfit => _t('todayProfit');
  String get transactions => _t('transactions');
  String get lowStockAlerts => _t('lowStockAlerts');
  String get bestSellingProducts => _t('bestSellingProducts');
  String get salesTrend => _t('salesTrend');
  String get categories => _t('categories');
  String get addCategory => _t('addCategory');
  String get editCategory => _t('editCategory');
  String get deleteCategory => _t('deleteCategory');
  String get categoryName => _t('categoryName');
  String get usernameHint => _t('usernameHint');
  String get passwordHint => _t('passwordHint');
  String get rememberMe => _t('rememberMe');
  String get defaultCredentials => _t('defaultCredentials');
  String get defaultUser => _t('defaultUser');
  String get defaultPassword => _t('defaultPassword');
  String get noCategories => _t('noCategories');
  String get products => _t('products');
  String get addProduct => _t('addProduct');
  String get editProduct => _t('editProduct');
  String get deleteProduct => _t('deleteProduct');
  String get productName => _t('productName');
  String get barcode => _t('barcode');
  String get buyingPrice => _t('buyingPrice');
  String get sellingPrice => _t('sellingPrice');
  String get quantity => _t('quantity');
  String get inStock => _t('inStock');
  String get lowStock => _t('lowStock');
  String get outOfStock => _t('outOfStock');
  String get noProducts => _t('noProducts');
  String get pos => _t('pos');
  String get cart => _t('cart');
  String get addToCart => _t('addToCart');
  String get removeFromCart => _t('removeFromCart');
  String get clearCart => _t('clearCart');
  String get subtotal => _t('subtotal');
  String get discount => _t('discount');
  String get total => _t('total');
  String get checkout => _t('checkout');
  String get searchProduct => _t('searchProduct');
  String get selectCustomer => _t('selectCustomer');
  String get paymentMethod => _t('paymentMethod');
  String get dashboardSubtitle => _t('dashboardSubtitle');
  String get vsYesterday => _t('vsYesterday');
  String get totalProducts => _t('totalProducts');
  String get items => _t('items');
  String get cash => _t('cash');
  String get card => _t('card');
  String get debt => _t('debt');
  String get mixed => _t('mixed');
  String get amountPaid => _t('amountPaid');
  String get change => _t('change');
  String get processPayment => _t('processPayment');
  String get saleSuccess => _t('saleSuccess');
  String get invoiceNumber => _t('invoiceNumber');
  String get fixedDiscount => _t('fixedDiscount');
  String get percentageDiscount => _t('percentageDiscount');
  String get customers => _t('customers');
  String get addCustomer => _t('addCustomer');
  String get editCustomer => _t('editCustomer');
  String get deleteCustomer => _t('deleteCustomer');
  String get customerName => _t('customerName');
  String get phone => _t('phone');
  String get email => _t('email');
  String get address => _t('address');
  String get totalDebt => _t('totalDebt');
  String get totalPurchases => _t('totalPurchases');
  String get noCustomers => _t('noCustomers');
  String get recordPayment => _t('recordPayment');
  String get loginSubtitle => _t('loginSubtitle');
  String get version => _t('version');
  String get sales => _t('sales');
  String get today => _t('today');
  String get thisWeek => _t('thisWeek');
  String get thisMonth => _t('thisMonth');
  String get allTime => _t('allTime');
  String get customRange => _t('customRange');
  String get totalSales => _t('totalSales');
  String get totalProfit => _t('totalProfit');
  String get transactionCount => _t('transactionCount');
  String get averageSale => _t('averageSale');
  String get searchInvoice => _t('searchInvoice');
  String get saleDetails => _t('saleDetails');
  String get noSales => _t('noSales');
  String get debts => _t('debts');
  String get allDebts => _t('allDebts');
  String get unpaid => _t('unpaid');
  String get partial => _t('partial');
  String get paid => _t('paid');
  String get addPayment => _t('addPayment');
  String get paymentHistory => _t('paymentHistory');
  String get remainingAmount => _t('remainingAmount');
  String get paidAmount => _t('paidAmount');
  String get noDebts => _t('noDebts');
  String get debtStatus => _t('debtStatus');
  String get expenses => _t('expenses');
  String get addExpense => _t('addExpense');
  String get editExpense => _t('editExpense');
  String get deleteExpense => _t('deleteExpense');
  String get expenseCategory => _t('expenseCategory');
  String get amount => _t('amount');
  String get description => _t('description');
  String get date => _t('date');
  String get rent => _t('rent');
  String get utilities => _t('utilities');
  String get salaries => _t('salaries');
  String get supplies => _t('supplies');
  String get marketing => _t('marketing');
  String get maintenance => _t('maintenance');
  String get transport => _t('transport');
  String get other => _t('other');
  String get noExpenses => _t('noExpenses');
  String get revenueVsExpenses => _t('revenueVsExpenses');
  String get netProfit => _t('netProfit');
  String get stock => _t('stock');
  String get addStock => _t('addStock');
  String get removeStock => _t('removeStock');
  String get stockHistory => _t('stockHistory');
  String get adjustmentType => _t('adjustmentType');
  String get reason => _t('reason');
  String get restock => _t('restock');
  String get returnFromCustomer => _t('returnFromCustomer');
  String get correction => _t('correction');
  String get damage => _t('damage');
  String get theft => _t('theft');
  String get returnToSupplier => _t('returnToSupplier');
  String get stockValue => _t('stockValue');
  String get noAdjustments => _t('noAdjustments');
  String get settings => _t('settings');
  String get language => _t('language');
  String get english => _t('english');
  String get french => _t('french');
  String get save => _t('save');
  String get cancel => _t('cancel');
  String get delete => _t('delete');
  String get edit => _t('edit');
  String get add => _t('add');
  String get search => _t('search');
  String get filter => _t('filter');
  String get confirm => _t('confirm');
  String get confirmDelete => _t('confirmDelete');
  String get yes => _t('yes');
  String get no => _t('no');
  String get error => _t('error');
  String get success => _t('success');
  String get loading => _t('loading');
  String get noData => _t('noData');
  String get required => _t('required');
  String get invalidPhone => _t('invalidPhone');
  String get invalidPrice => _t('invalidPrice');
  String get invalidQuantity => _t('invalidQuantity');
  String get admin => _t('admin');
  String get employee => _t('employee');
  String get role => _t('role');
  String get profit => _t('profit');
  String get revenue => _t('revenue');
  String get currency => _t('currency');

  String _t(String key) {
    return _translations[locale.languageCode]?[key] ??
        _translations['en']?[key] ??
        key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
