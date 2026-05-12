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
      'magasinPro': 'Magasin Pro',
      'splashTagline': 'Store Management',
      'sidebarTitleShort': 'Magasin',
      'sidebarSubtitle': 'Phone Shop Manager',
      'mainMenu': 'MAIN MENU',
      'searchShortcut': 'Ctrl+K',
      'langCodeEn': 'EN',
      'langCodeFr': 'FR',
      'loginFailed': 'Login failed',
      'guestUser': 'User',
      'categoryAddSuccess': 'Category added successfully',
      'categoryUpdateSuccess': 'Category updated successfully',
      'categoryDeleteSuccess': 'Category deleted successfully',
      'cannotDeleteCategoryHasProducts':
          'Cannot delete category with existing products',
      'failedDeleteCategory': 'Failed to delete category',
      'productAddSuccess': 'Product added successfully',
      'productUpdateSuccess': 'Product updated successfully',
      'productDeleteSuccess': 'Product deleted successfully',
      'failedAddProduct': 'Failed to add product',
      'failedUpdateProduct': 'Failed to update product',
      'failedDeleteProduct': 'Failed to delete product',
      'customerAddSuccess': 'Customer added successfully',
      'customerUpdateSuccess': 'Customer updated successfully',
      'customerDeleteSuccess': 'Customer deleted successfully',
      'failedAddCustomer': 'Failed to add customer',
      'failedUpdateCustomer': 'Failed to update customer',
      'failedDeleteCustomer': 'Failed to delete customer',
      'expenseAddSuccess': 'Expense added successfully',
      'expenseUpdateSuccess': 'Expense updated successfully',
      'failedAddExpense': 'Failed to add expense',
      'failedUpdateExpense': 'Failed to update expense',
      'expenseDeleteSuccess': 'Expense deleted successfully',
      'failedDeleteExpense': 'Failed to delete expense',
      'failedPickImage': 'Failed to pick image',
      'deleteCategoryMessage': 'Are you sure you want to delete this category?',
      'deleteProductMessage': 'Are you sure you want to delete this product?',
      'deleteProductNamed': 'Are you sure you want to delete "{name}"?',
      'deleteCustomerMessage': 'Are you sure you want to delete this customer?',
      'deleteExpenseConfirmIntro':
          'Are you sure you want to delete this expense?',
      'period': 'Period',
      'avgSaleShort': 'Avg. Sale',
      'goToPos': 'Go to POS',
      'noSalesRecordedToday': 'No sales recorded today',
      'noSalesThisWeek': 'No sales this week',
      'noSalesThisMonth': 'No sales this month',
      'noSalesInSelectedRange': 'No sales in selected date range',
      'noSalesDefaultHint': 'Start making sales to see them here',
      'stockStatus': 'Stock Status',
      'normalStock': 'Normal Stock',
      'allProducts': 'All Products',
      'viewHistory': 'View History',
      'stockEmptySubtitle': 'Add products to start managing inventory',
      'stockSearchHint': 'Search products by name or barcode...',
      'stockAdjustmentHistory': 'Stock Adjustment History',
      'noStockHistory': 'No adjustment history',
      'adjustStock': 'Adjust Stock',
      'quantityLabel': 'Quantity *',
      'enterQuantity': 'Enter quantity',
      'valPleaseEnterQuantity': 'Please enter quantity',
      'valPleaseValidQuantity': 'Please enter a valid quantity',
      'valCannotRemoveMoreStock': 'Cannot remove more than current stock',
      'reasonLabel': 'Reason *',
      'additionalNotes': 'Additional Notes',
      'specifyReason': 'Specify the reason',
      'valPleaseSpecifyReason': 'Please specify the reason',
      'newStockLevel': 'New Stock Level:',
      'unitsSuffix': 'units',
      'onlyAvailableInStock': 'Only {count} available in stock',
      'cannotAddMoreInStock': 'Cannot add more. Only {count} in stock.',
      'productAddedToCart': '{name} added to cart',
      'insufficientCash': 'Insufficient: {amount} DA short',
      'amountAddedToDebt': 'Amount to be added to debt: {amount}',
      'paymentRecordedRemaining': 'Payment recorded! Remaining: {amount}',
      'stockAdjustedNewUnits':
          'Stock adjusted successfully! New stock: {count} units',
      'invoiceHash': 'Invoice #{id}',
      'productHash': 'Product #{id}',
      'unitsCount': '{count} units',
      'errorWithMessage': 'Error: {message}',
      'fieldRequiredFor': '{field} is required',
      'usernameTooShort':
          'Username is too short (min {min} characters)',
      'usernameTooLong':
          'Username is too long (max {max} characters)',
      'passwordTooLong':
          'Password is too long (max {max} characters)',
      'enterValidNumber': 'Please enter a valid number',
      'numberCannotBeNegative': 'Number cannot be negative',
      'enterValidPriceMsg': 'Please enter a valid price',
      'priceCannotBeNegative': 'Price cannot be negative',
      'enterValidQuantityMsg': 'Please enter a valid quantity',
      'quantityCannotBeNegative': 'Quantity cannot be negative',
      'enterValidPercentage': 'Please enter a valid percentage',
      'percentageRange': 'Percentage must be between 0 and 100',
      'invalidBarcodeFormat':
          'Invalid barcode (letters and numbers only)',
      'passwordTooShort':
          'Password is too short (min {min} characters)',
      'debtsManagement': 'Debts Management',
      'debtsSearchHint': 'Search by customer name or invoice...',
      'noUnpaidDebts': 'No unpaid debts',
      'noPartialDebts': 'No partially paid debts',
      'noPaidDebts': 'No paid debts',
      'debtsEmptyHint': 'Debts from credit sales will appear here',
      'debtDetails': 'Debt Details',
      'unknownCustomer': 'Unknown Customer',
      'alreadyPaid': 'Already Paid',
      'paymentAmountField': 'Payment Amount *',
      'newRemainingDebt': 'New Remaining Debt',
      'valEnterPaymentAmount': 'Please enter payment amount',
      'valValidPaymentAmount': 'Please enter a valid amount',
      'valPaymentExceedsDebt': 'Payment cannot exceed remaining debt',
      'failedAddPayment': 'Failed to add payment',
      'expensesManagement': 'Expenses Management',
      'addExpenseFab': 'Add Expense',
      'searchExpenseHint': 'Search by description or category...',
      'totalExpenses': 'Total Expenses',
      'thisMonthLabel': 'This Month',
      'avgExpense': 'Avg. Expense',
      'topCategory': 'Top Category',
      'noExpensesHint': 'Start tracking your business expenses',
      'addFirstExpense': 'Add First Expense',
      'categoryRequired': 'Category *',
      'descriptionOptional': 'Description (Optional)',
      'expenseDate': 'Expense Date *',
      'valEnterAmount': 'Please enter amount',
      'valValidAmount': 'Please enter a valid amount',
      'selectDateRange': 'Select Date Range',
      'startDate': 'Start Date',
      'endDate': 'End Date',
      'applyFilter': 'Apply Filter',
      'dateRangeInvalid': 'Start date must be before end date',
      'updateExpense': 'Update Expense',
      'allCustomers': 'All Customers',
      'withDebt': 'With Debt',
      'noDebtLabel': 'No Debt',
      'customerDetails': 'Customer Details',
      'debtShort': 'Debt',
      'searchCustomerHint': 'Search by name, phone, or email...',
      'hintFullNameExample': 'e.g., Ahmed Benali',
      'hintPhoneExample': 'e.g., 0555123456',
      'hintAddress': 'Customer address',
      'customerId': 'Customer ID',
      'customerInformation': 'Customer Information',
      'memberSince': 'Member Since',
      'totalSpent': 'Total Spent',
      'lastPurchase': 'Last Purchase',
      'purchaseHistory': 'Purchase History',
      'noPurchasesYet': 'No purchases yet',
      'purchaseHistoryHint': 'Purchase history will appear here',
      'editCustomerTooltip': 'Edit Customer',
      'addNewProduct': 'Add New Product',
      'productDetails': 'Product Details',
      'productIdLabel': 'Product ID',
      'timestampsCreated': 'Created',
      'timestampsLastUpdated': 'Last Updated',
      'searchProductListHint': 'Search by name, brand, or barcode...',
      'allCategories': 'All Categories',
      'hintProductNameEx': 'e.g., iPhone 15 Pro Max',
      'hintBrandEx': 'e.g., Apple, Samsung',
      'hintPriceZero': '0.00',
      'hintQuantityZero': '0',
      'hintMinStock': '5',
      'hintBarcode': 'Scan or enter barcode',
      'hintProductNotes': 'Additional details about the product',
      'brand': 'Brand',
      'notes': 'Notes',
      'minStockLevel': 'Min Stock Level',
      'selectCategory': 'Category *',
      'hintCategoryName': 'e.g., Smartphones',
      'hintCategoryDesc': 'Brief description of the category',
      'gallery': 'Gallery',
      'camera': 'Camera',
      'removeImage': 'Remove Image',
      'failedAdjustStock': 'Failed to adjust stock',
      'completePayment': 'Complete Payment',
      'completeSale': 'Complete Sale',
      'cashReceived': 'Cash Received',
      'cardPayment': 'Card Payment',
      'cashAmount': 'Cash Amount',
      'cardAmount': 'Card Amount',
      'selectCustomerCreditWarning':
          'Please select a customer to use credit payment',
      'pleaseSelectCustomerCredit':
          'Please select a customer for credit payment',
      'insufficientCashReceived': 'Insufficient cash received',
      'totalPaymentLessThanOrder': 'Total payment is less than order total',
      'failedCompleteSale': 'Failed to complete sale',
      'paymentOnCredit': 'On Credit (Debt)',
      'paymentMixedDetail': 'Mixed (Cash + Card)',
      'totalPaymentLabel': 'Total Payment:',
      'remainingLabel': 'Remaining:',
      'changeToReturn': 'Change to return',
      'ok': 'OK',
      'orderItems': 'Items',
      'orderSubtotal': 'Subtotal',
      'orderDiscount': 'Discount',
      'orderTotal': 'Total',
      'orderProfit': 'Profit',
      'applyDiscount': 'Apply Discount',
      'removeDiscount': 'Remove Discount',
      'apply': 'Apply',
      'subtotalColon': 'Subtotal:',
      'discountColon': 'Discount:',
      'walkInCustomer': 'Walk-in Customer',
      'noCustomerRecord': 'No customer record',
      'close': 'Close',
      'selectCustomerTitle': 'Select Customer',
      'allProductsPos': 'All Products',
      'searchPosHint': 'Search by name, brand, or scan barcode...',
      'adjust': 'Adjust',
      'paymentAmount': 'Payment Amount',
      'addPaymentTitle': 'Add Payment',
      'printComingSoon': 'Print functionality coming soon!',
      'discountExceedsSubtotal': 'Discount cannot exceed subtotal',
      'failedUpdateCategory': 'Failed to update category',
      'failedAddCategory': 'Failed to add category',
      'topSellersThisMonth': "This month's top sellers",
      'searchInvoiceNumberHint': 'Search by invoice number or customer...',
      'allDebtsFilter': 'All Debts',
      'updateCategory': 'Update Category',
      'barcodePrefix': 'Barcode:',
      'valuePrefix': 'Value:',
      'operationFailed': 'Something went wrong. Please try again.',
      'basicInformation': 'Basic Information',
      'pricingSection': 'Pricing',
      'inventorySection': 'Inventory',
      'additionalInformation': 'Additional Information',
      'productImage': 'Product Image',
      'profitSummary': 'Profit Summary',
      'initialQuantity': 'Initial Quantity *',
      'minQuantityAlert': 'Min Quantity (Alert)',
      'barcodeOptional': 'Barcode (Optional)',
      'notesOptional': 'Notes (Optional)',
      'pleaseSelectCategory': 'Please select a category',
      'productNameRequired': 'Product Name *',
      'addressOptional': 'Address (Optional)',
      'updateCustomer': 'Update Customer',
      'noImageSelected': 'No image selected',
      'profitPerUnit': 'Profit per Unit',
      'profitMarginLabel': 'Profit Margin',
      'updateButton': 'Update',
      'noImageShort': 'No image',
      'minQuantityLabel': 'Min Quantity',
      'categoriesSubtitle': 'Manage product categories',
      'noCategoriesYet': 'No categories yet',
      'addFirstCategoryHint': 'Add your first category to get started',
      'noBrand': 'No brand',
      'unknownCategory': 'Unknown',
      'profitLabelShort': 'Profit:',
      'stockQtyShort': 'Stock:',
      'lowQtyShort': 'Low:',
      'productsCountInventory': '{count} products in inventory',
      'noProductsYet': 'No products yet',
      'addFirstProductHint': 'Add your first product to get started',
      'categoryFilter': 'Category',
      'gridView': 'Grid view',
      'listView': 'List view',
      'currency': 'DA',
      'posSubtitle': 'Scan or select products to add to cart',
      'cartWithItemsCount': 'Cart ({count} items)',
      'cartIsEmptyTitle': 'Cart is empty',
      'cartGetStartedSubtitle': 'Add products to get started',
      'customerSectionLabel': 'Customer',
      'noProductsAvailable': 'No products available',
      'noProductsInStockPos': 'No products in stock',
      'clearCartConfirmMessage':
          'Are you sure you want to remove all items from the cart?',
      'totalColon': 'Total:',
      'discountFieldPercent': 'Discount (%)',
      'discountFieldAmount': 'Discount Amount',
      'hintDiscountPercentEx': 'e.g., 10',
      'hintDiscountAmountEx': 'e.g., 5000',
      'hintExpenseAmountEx': 'e.g., 50000',
      'expenseDescriptionHint': 'Brief description of the expense',
      'currentStockColon': 'Current Stock:',
      'stockValueColon': 'Stock Value:',
      'ofMaxStock': 'of {count}',
      'productCountInCategory': '{count} products',
      'customersRegisteredCount': '{count} customers registered',
      'noCustomersYetTitle': 'No customers yet',
      'addFirstCustomerHint': 'Add your first customer to get started',
      'cartItemProfitAmount': 'Profit: {amount}',
      'salesRecordedCount': '{count} sales recorded',
      'invoiceHeading': 'INVOICE',
      'printInvoiceTooltip': 'Print Invoice',
      'totalAmountLabel': 'Total Amount',
      'saleItemsTitle': 'Sale Items',
      'itemsCountShort': '{count} items',
      'tableProduct': 'Product',
      'tablePrice': 'Price',
      'tableQtyShort': 'Qty',
      'paymentDetailsTitle': 'Payment Details',
      'remainingDebt': 'Remaining Debt',
      'saleSummaryTitle': 'Sale Summary',
      'paymentMixedShort': 'Mixed Payment',
      'paymentOnCreditShort': 'On Credit',
      'expensesRecordedCount': '{count} expenses recorded',
      'notApplicable': 'N/A',
      'debtsTrackedCount': '{count} debts tracked',
      'debtInformationSection': 'Debt Information',
      'debtIdLabel': 'Debt ID',
      'createdDateLabel': 'Created Date',
      'paymentsMadeLabel': 'Payments Made',
      'statusField': 'Status',
      'invoiceColon': 'Invoice: {number}',
      'noPaymentsYetDebt': 'No payments yet',
      'customerLabelDetail': 'Customer',
      'invoiceNumberLabel': 'Invoice Number',
      'salesChartSubtitle': 'Revenue and profit overview',
      'lastPurchaseNever': 'Never',
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
      'magasinPro': 'Magasin Pro',
      'splashTagline': 'Gestion de magasin',
      'sidebarTitleShort': 'Magasin',
      'sidebarSubtitle': 'Gestion boutique téléphones',
      'mainMenu': 'MENU PRINCIPAL',
      'searchShortcut': 'Ctrl+K',
      'langCodeEn': 'EN',
      'langCodeFr': 'FR',
      'loginFailed': 'Échec de la connexion',
      'guestUser': 'Utilisateur',
      'categoryAddSuccess': 'Catégorie ajoutée avec succès',
      'categoryUpdateSuccess': 'Catégorie mise à jour avec succès',
      'categoryDeleteSuccess': 'Catégorie supprimée avec succès',
      'cannotDeleteCategoryHasProducts':
          'Impossible de supprimer une catégorie contenant des produits',
      'failedDeleteCategory': 'Échec de la suppression de la catégorie',
      'productAddSuccess': 'Produit ajouté avec succès',
      'productUpdateSuccess': 'Produit mis à jour avec succès',
      'productDeleteSuccess': 'Produit supprimé avec succès',
      'failedAddProduct': 'Échec de l\'ajout du produit',
      'failedUpdateProduct': 'Échec de la mise à jour du produit',
      'failedDeleteProduct': 'Échec de la suppression du produit',
      'customerAddSuccess': 'Client ajouté avec succès',
      'customerUpdateSuccess': 'Client mis à jour avec succès',
      'customerDeleteSuccess': 'Client supprimé avec succès',
      'failedAddCustomer': 'Échec de l\'ajout du client',
      'failedUpdateCustomer': 'Échec de la mise à jour du client',
      'failedDeleteCustomer': 'Échec de la suppression du client',
      'expenseAddSuccess': 'Dépense ajoutée avec succès',
      'expenseUpdateSuccess': 'Dépense mise à jour avec succès',
      'failedAddExpense': 'Échec de l\'ajout de la dépense',
      'failedUpdateExpense': 'Échec de la mise à jour de la dépense',
      'expenseDeleteSuccess': 'Dépense supprimée avec succès',
      'failedDeleteExpense': 'Échec de la suppression de la dépense',
      'failedPickImage': 'Échec de la sélection de l\'image',
      'deleteCategoryMessage':
          'Êtes-vous sûr de vouloir supprimer cette catégorie ?',
      'deleteProductMessage':
          'Êtes-vous sûr de vouloir supprimer ce produit ?',
      'deleteProductNamed':
          'Êtes-vous sûr de vouloir supprimer « {name} » ?',
      'deleteCustomerMessage':
          'Êtes-vous sûr de vouloir supprimer ce client ?',
      'deleteExpenseConfirmIntro':
          'Êtes-vous sûr de vouloir supprimer cette dépense ?',
      'period': 'Période',
      'avgSaleShort': 'Vente moy.',
      'goToPos': 'Aller au point de vente',
      'noSalesRecordedToday': 'Aucune vente enregistrée aujourd\'hui',
      'noSalesThisWeek': 'Aucune vente cette semaine',
      'noSalesThisMonth': 'Aucune vente ce mois-ci',
      'noSalesInSelectedRange':
          'Aucune vente sur la plage de dates sélectionnée',
      'noSalesDefaultHint': 'Effectuez des ventes pour les voir ici',
      'stockStatus': 'État du stock',
      'normalStock': 'Stock normal',
      'allProducts': 'Tous les produits',
      'viewHistory': 'Voir l\'historique',
      'stockEmptySubtitle':
          'Ajoutez des produits pour commencer à gérer l\'inventaire',
      'stockSearchHint':
          'Rechercher des produits par nom ou code-barres...',
      'stockAdjustmentHistory': 'Historique des ajustements de stock',
      'noStockHistory': 'Aucun historique d\'ajustement',
      'adjustStock': 'Ajuster le stock',
      'quantityLabel': 'Quantité *',
      'enterQuantity': 'Entrez la quantité',
      'valPleaseEnterQuantity': 'Veuillez entrer la quantité',
      'valPleaseValidQuantity': 'Veuillez entrer une quantité valide',
      'valCannotRemoveMoreStock':
          'Impossible de retirer plus que le stock actuel',
      'reasonLabel': 'Raison *',
      'additionalNotes': 'Notes supplémentaires',
      'specifyReason': 'Précisez la raison',
      'valPleaseSpecifyReason': 'Veuillez préciser la raison',
      'newStockLevel': 'Nouveau niveau de stock :',
      'unitsSuffix': 'unités',
      'onlyAvailableInStock':
          'Seulement {count} disponible(s) en stock',
      'cannotAddMoreInStock':
          'Impossible d\'en ajouter plus. Seulement {count} en stock.',
      'productAddedToCart': '{name} ajouté au panier',
      'insufficientCash': 'Insuffisant : {amount} DA manquants',
      'amountAddedToDebt': 'Montant à ajouter à la dette : {amount}',
      'paymentRecordedRemaining': 'Paiement enregistré ! Reste : {amount}',
      'stockAdjustedNewUnits':
          'Stock ajusté avec succès ! Nouveau stock : {count} unités',
      'invoiceHash': 'Facture n°{id}',
      'productHash': 'Produit n°{id}',
      'unitsCount': '{count} unités',
      'errorWithMessage': 'Erreur : {message}',
      'fieldRequiredFor': '{field} est obligatoire',
      'usernameTooShort':
          'Nom d\'utilisateur trop court (min {min} caractères)',
      'usernameTooLong':
          'Nom d\'utilisateur trop long (max {max} caractères)',
      'passwordTooLong':
          'Mot de passe trop long (max {max} caractères)',
      'enterValidNumber': 'Veuillez entrer un nombre valide',
      'numberCannotBeNegative': 'Le nombre ne peut pas être négatif',
      'enterValidPriceMsg': 'Veuillez entrer un prix valide',
      'priceCannotBeNegative': 'Le prix ne peut pas être négatif',
      'enterValidQuantityMsg': 'Veuillez entrer une quantité valide',
      'quantityCannotBeNegative': 'La quantité ne peut pas être négative',
      'enterValidPercentage': 'Veuillez entrer un pourcentage valide',
      'percentageRange': 'Le pourcentage doit être entre 0 et 100',
      'invalidBarcodeFormat':
          'Code-barres invalide (lettres et chiffres uniquement)',
      'passwordTooShort':
          'Mot de passe trop court (min {min} caractères)',
      'debtsManagement': 'Gestion des dettes',
      'debtsSearchHint':
          'Rechercher par nom de client ou facture...',
      'noUnpaidDebts': 'Aucune dette impayée',
      'noPartialDebts': 'Aucune dette partiellement payée',
      'noPaidDebts': 'Aucune dette payée',
      'debtsEmptyHint':
          'Les dettes des ventes à crédit apparaîtront ici',
      'debtDetails': 'Détails de la dette',
      'unknownCustomer': 'Client inconnu',
      'alreadyPaid': 'Déjà payé',
      'paymentAmountField': 'Montant du paiement *',
      'newRemainingDebt': 'Nouveau reste dû',
      'valEnterPaymentAmount': 'Veuillez entrer le montant du paiement',
      'valValidPaymentAmount': 'Veuillez entrer un montant valide',
      'valPaymentExceedsDebt':
          'Le paiement ne peut pas dépasser le reste dû',
      'failedAddPayment': 'Échec de l\'ajout du paiement',
      'expensesManagement': 'Gestion des dépenses',
      'addExpenseFab': 'Ajouter une dépense',
      'searchExpenseHint':
          'Rechercher par description ou catégorie...',
      'totalExpenses': 'Total des dépenses',
      'thisMonthLabel': 'Ce mois',
      'avgExpense': 'Dépense moy.',
      'topCategory': 'Catégorie principale',
      'noExpensesHint': 'Commencez à suivre vos dépenses professionnelles',
      'addFirstExpense': 'Ajouter une première dépense',
      'categoryRequired': 'Catégorie *',
      'descriptionOptional': 'Description (optionnel)',
      'expenseDate': 'Date de la dépense *',
      'valEnterAmount': 'Veuillez entrer le montant',
      'valValidAmount': 'Veuillez entrer un montant valide',
      'selectDateRange': 'Sélectionner la plage de dates',
      'startDate': 'Date de début',
      'endDate': 'Date de fin',
      'applyFilter': 'Appliquer le filtre',
      'dateRangeInvalid':
          'La date de début doit être antérieure à la date de fin',
      'updateExpense': 'Mettre à jour la dépense',
      'allCustomers': 'Tous les clients',
      'withDebt': 'Avec dette',
      'noDebtLabel': 'Sans dette',
      'customerDetails': 'Détails du client',
      'debtShort': 'Dette',
      'searchCustomerHint':
          'Rechercher par nom, téléphone ou e-mail...',
      'hintFullNameExample': 'ex. Ahmed Benali',
      'hintPhoneExample': 'ex. 0555123456',
      'hintAddress': 'Adresse du client',
      'customerId': 'ID client',
      'customerInformation': 'Informations client',
      'memberSince': 'Membre depuis',
      'totalSpent': 'Total dépensé',
      'lastPurchase': 'Dernier achat',
      'purchaseHistory': 'Historique des achats',
      'noPurchasesYet': 'Aucun achat pour le moment',
      'purchaseHistoryHint': 'L\'historique des achats apparaîtra ici',
      'editCustomerTooltip': 'Modifier le client',
      'addNewProduct': 'Ajouter un nouveau produit',
      'productDetails': 'Détails du produit',
      'productIdLabel': 'ID produit',
      'timestampsCreated': 'Créé',
      'timestampsLastUpdated': 'Dernière mise à jour',
      'searchProductListHint':
          'Rechercher par nom, marque ou code-barres...',
      'allCategories': 'Toutes les catégories',
      'hintProductNameEx': 'ex. iPhone 15 Pro Max',
      'hintBrandEx': 'ex. Apple, Samsung',
      'hintPriceZero': '0.00',
      'hintQuantityZero': '0',
      'hintMinStock': '5',
      'hintBarcode': 'Scanner ou saisir le code-barres',
      'hintProductNotes': 'Détails supplémentaires sur le produit',
      'brand': 'Marque',
      'notes': 'Notes',
      'minStockLevel': 'Stock minimum',
      'selectCategory': 'Catégorie *',
      'hintCategoryName': 'ex. Smartphones',
      'hintCategoryDesc': 'Brève description de la catégorie',
      'gallery': 'Galerie',
      'camera': 'Caméra',
      'removeImage': 'Supprimer l\'image',
      'failedAdjustStock': 'Échec de l\'ajustement du stock',
      'completePayment': 'Finaliser le paiement',
      'completeSale': 'Finaliser la vente',
      'cashReceived': 'Espèces reçues',
      'cardPayment': 'Paiement par carte',
      'cashAmount': 'Montant espèces',
      'cardAmount': 'Montant carte',
      'selectCustomerCreditWarning':
          'Veuillez sélectionner un client pour le paiement à crédit',
      'pleaseSelectCustomerCredit':
          'Veuillez sélectionner un client pour le paiement à crédit',
      'insufficientCashReceived': 'Espèces reçues insuffisantes',
      'totalPaymentLessThanOrder':
          'Le paiement total est inférieur au total de la commande',
      'failedCompleteSale': 'Échec de la finalisation de la vente',
      'paymentOnCredit': 'À crédit (dette)',
      'paymentMixedDetail': 'Mixte (espèces + carte)',
      'totalPaymentLabel': 'Paiement total :',
      'remainingLabel': 'Reste :',
      'changeToReturn': 'Monnaie à rendre',
      'ok': 'OK',
      'orderItems': 'Articles',
      'orderSubtotal': 'Sous-total',
      'orderDiscount': 'Remise',
      'orderTotal': 'Total',
      'orderProfit': 'Bénéfice',
      'applyDiscount': 'Appliquer une remise',
      'removeDiscount': 'Retirer la remise',
      'apply': 'Appliquer',
      'subtotalColon': 'Sous-total :',
      'discountColon': 'Remise :',
      'walkInCustomer': 'Client sans compte',
      'noCustomerRecord': 'Aucune fiche client',
      'close': 'Fermer',
      'selectCustomerTitle': 'Sélectionner un client',
      'allProductsPos': 'Tous les produits',
      'searchPosHint':
          'Rechercher par nom, marque ou scanner le code-barres...',
      'adjust': 'Ajuster',
      'paymentAmount': 'Montant du paiement',
      'addPaymentTitle': 'Ajouter un paiement',
      'printComingSoon': 'Impression bientôt disponible !',
      'discountExceedsSubtotal':
          'La remise ne peut pas dépasser le sous-total',
      'failedUpdateCategory': 'Échec de la mise à jour de la catégorie',
      'failedAddCategory': 'Échec de l\'ajout de la catégorie',
      'topSellersThisMonth': 'Meilleures ventes du mois',
      'searchInvoiceNumberHint':
          'Rechercher par numéro de facture ou client...',
      'allDebtsFilter': 'Toutes les dettes',
      'updateCategory': 'Mettre à jour la catégorie',
      'barcodePrefix': 'Code-barres :',
      'valuePrefix': 'Valeur :',
      'operationFailed': 'Une erreur s\'est produite. Réessayez.',
      'basicInformation': 'Informations de base',
      'pricingSection': 'Tarification',
      'inventorySection': 'Inventaire',
      'additionalInformation': 'Informations supplémentaires',
      'productImage': 'Image du produit',
      'profitSummary': 'Résumé du bénéfice',
      'initialQuantity': 'Quantité initiale *',
      'minQuantityAlert': 'Quantité min. (alerte)',
      'barcodeOptional': 'Code-barres (optionnel)',
      'notesOptional': 'Notes (optionnel)',
      'pleaseSelectCategory': 'Veuillez sélectionner une catégorie',
      'productNameRequired': 'Nom du produit *',
      'addressOptional': 'Adresse (optionnel)',
      'updateCustomer': 'Mettre à jour le client',
      'noImageSelected': 'Aucune image sélectionnée',
      'profitPerUnit': 'Bénéfice par unité',
      'profitMarginLabel': 'Marge bénéficiaire',
      'updateButton': 'Mettre à jour',
      'noImageShort': 'Aucune image',
      'minQuantityLabel': 'Quantité min.',
      'categoriesSubtitle': 'Gérer les catégories de produits',
      'noCategoriesYet': 'Aucune catégorie pour le moment',
      'addFirstCategoryHint': 'Ajoutez votre première catégorie pour commencer',
      'noBrand': 'Sans marque',
      'unknownCategory': 'Inconnu',
      'profitLabelShort': 'Bénéfice :',
      'stockQtyShort': 'Stock :',
      'lowQtyShort': 'Faible :',
      'productsCountInventory': '{count} produits en inventaire',
      'noProductsYet': 'Aucun produit pour le moment',
      'addFirstProductHint': 'Ajoutez votre premier produit pour commencer',
      'categoryFilter': 'Catégorie',
      'gridView': 'Vue grille',
      'listView': 'Vue liste',
      'currency': 'DA',
      'posSubtitle':
          'Scannez ou sélectionnez des produits à ajouter au panier',
      'cartWithItemsCount': 'Panier ({count} articles)',
      'cartIsEmptyTitle': 'Panier vide',
      'cartGetStartedSubtitle': 'Ajoutez des produits pour commencer',
      'customerSectionLabel': 'Client',
      'noProductsAvailable': 'Aucun produit disponible',
      'noProductsInStockPos': 'Aucun produit en stock',
      'clearCartConfirmMessage':
          'Voulez-vous vraiment retirer tous les articles du panier ?',
      'totalColon': 'Total :',
      'discountFieldPercent': 'Remise (%)',
      'discountFieldAmount': 'Montant de la remise',
      'hintDiscountPercentEx': 'ex. 10',
      'hintDiscountAmountEx': 'ex. 5000',
      'hintExpenseAmountEx': 'ex. 50000',
      'expenseDescriptionHint': 'Brève description de la dépense',
      'currentStockColon': 'Stock actuel :',
      'stockValueColon': 'Valeur du stock :',
      'ofMaxStock': 'sur {count}',
      'productCountInCategory': '{count} produits',
      'customersRegisteredCount': '{count} clients enregistrés',
      'noCustomersYetTitle': 'Aucun client pour le moment',
      'addFirstCustomerHint': 'Ajoutez votre premier client pour commencer',
      'cartItemProfitAmount': 'Bénéfice : {amount}',
      'salesRecordedCount': '{count} ventes enregistrées',
      'invoiceHeading': 'FACTURE',
      'printInvoiceTooltip': 'Imprimer la facture',
      'totalAmountLabel': 'Montant total',
      'saleItemsTitle': 'Articles de la vente',
      'itemsCountShort': '{count} articles',
      'tableProduct': 'Produit',
      'tablePrice': 'Prix',
      'tableQtyShort': 'Qté',
      'paymentDetailsTitle': 'Détails du paiement',
      'remainingDebt': 'Dette restante',
      'saleSummaryTitle': 'Résumé de la vente',
      'paymentMixedShort': 'Paiement mixte',
      'paymentOnCreditShort': 'À crédit',
      'expensesRecordedCount': '{count} dépenses enregistrées',
      'notApplicable': 'N/D',
      'debtsTrackedCount': '{count} dettes suivies',
      'debtInformationSection': 'Informations sur la dette',
      'debtIdLabel': 'ID dette',
      'createdDateLabel': 'Date de création',
      'paymentsMadeLabel': 'Paiements effectués',
      'statusField': 'Statut',
      'invoiceColon': 'Facture : {number}',
      'noPaymentsYetDebt': 'Aucun paiement pour le moment',
      'customerLabelDetail': 'Client',
      'invoiceNumberLabel': 'Numéro de facture',
      'salesChartSubtitle': 'Aperçu des revenus et bénéfices',
      'lastPurchaseNever': 'Jamais',
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

  String get magasinPro => _t('magasinPro');
  String get splashTagline => _t('splashTagline');
  String get sidebarTitleShort => _t('sidebarTitleShort');
  String get sidebarSubtitle => _t('sidebarSubtitle');
  String get mainMenu => _t('mainMenu');
  String get searchShortcut => _t('searchShortcut');
  String get langCodeEn => _t('langCodeEn');
  String get langCodeFr => _t('langCodeFr');
  String get loginFailed => _t('loginFailed');
  String get guestUser => _t('guestUser');
  String get categoryAddSuccess => _t('categoryAddSuccess');
  String get categoryUpdateSuccess => _t('categoryUpdateSuccess');
  String get categoryDeleteSuccess => _t('categoryDeleteSuccess');
  String get cannotDeleteCategoryHasProducts =>
      _t('cannotDeleteCategoryHasProducts');
  String get failedDeleteCategory => _t('failedDeleteCategory');
  String get productAddSuccess => _t('productAddSuccess');
  String get productUpdateSuccess => _t('productUpdateSuccess');
  String get productDeleteSuccess => _t('productDeleteSuccess');
  String get failedAddProduct => _t('failedAddProduct');
  String get failedUpdateProduct => _t('failedUpdateProduct');
  String get failedDeleteProduct => _t('failedDeleteProduct');
  String get customerAddSuccess => _t('customerAddSuccess');
  String get customerUpdateSuccess => _t('customerUpdateSuccess');
  String get customerDeleteSuccess => _t('customerDeleteSuccess');
  String get failedAddCustomer => _t('failedAddCustomer');
  String get failedUpdateCustomer => _t('failedUpdateCustomer');
  String get failedDeleteCustomer => _t('failedDeleteCustomer');
  String get expenseAddSuccess => _t('expenseAddSuccess');
  String get expenseUpdateSuccess => _t('expenseUpdateSuccess');
  String get failedAddExpense => _t('failedAddExpense');
  String get failedUpdateExpense => _t('failedUpdateExpense');
  String get expenseDeleteSuccess => _t('expenseDeleteSuccess');
  String get failedDeleteExpense => _t('failedDeleteExpense');
  String get failedPickImage => _t('failedPickImage');
  String get deleteCategoryMessage => _t('deleteCategoryMessage');
  String get deleteProductMessage => _t('deleteProductMessage');

  String deleteProductNamed(String name) =>
      _t('deleteProductNamed').replaceAll('{name}', name);
  String get deleteCustomerMessage => _t('deleteCustomerMessage');
  String get deleteExpenseConfirmIntro => _t('deleteExpenseConfirmIntro');
  String get period => _t('period');
  String get avgSaleShort => _t('avgSaleShort');
  String get goToPos => _t('goToPos');
  String get noSalesRecordedToday => _t('noSalesRecordedToday');
  String get noSalesThisWeek => _t('noSalesThisWeek');
  String get noSalesThisMonth => _t('noSalesThisMonth');
  String get noSalesInSelectedRange => _t('noSalesInSelectedRange');
  String get noSalesDefaultHint => _t('noSalesDefaultHint');
  String get stockStatus => _t('stockStatus');
  String get normalStock => _t('normalStock');
  String get allProducts => _t('allProducts');
  String get viewHistory => _t('viewHistory');
  String get stockEmptySubtitle => _t('stockEmptySubtitle');
  String get stockSearchHint => _t('stockSearchHint');
  String get stockAdjustmentHistory => _t('stockAdjustmentHistory');
  String get noStockHistory => _t('noStockHistory');
  String get adjustStock => _t('adjustStock');
  String get quantityLabel => _t('quantityLabel');
  String get enterQuantity => _t('enterQuantity');
  String get valPleaseEnterQuantity => _t('valPleaseEnterQuantity');
  String get valPleaseValidQuantity => _t('valPleaseValidQuantity');
  String get valCannotRemoveMoreStock => _t('valCannotRemoveMoreStock');
  String get reasonLabel => _t('reasonLabel');
  String get additionalNotes => _t('additionalNotes');
  String get specifyReason => _t('specifyReason');
  String get valPleaseSpecifyReason => _t('valPleaseSpecifyReason');
  String get newStockLevel => _t('newStockLevel');
  String get unitsSuffix => _t('unitsSuffix');
  String get debtsManagement => _t('debtsManagement');
  String get debtsSearchHint => _t('debtsSearchHint');
  String get noUnpaidDebts => _t('noUnpaidDebts');
  String get noPartialDebts => _t('noPartialDebts');
  String get noPaidDebts => _t('noPaidDebts');
  String get debtsEmptyHint => _t('debtsEmptyHint');
  String get debtDetails => _t('debtDetails');
  String get unknownCustomer => _t('unknownCustomer');
  String get alreadyPaid => _t('alreadyPaid');
  String get paymentAmountField => _t('paymentAmountField');
  String get newRemainingDebt => _t('newRemainingDebt');
  String get valEnterPaymentAmount => _t('valEnterPaymentAmount');
  String get valValidPaymentAmount => _t('valValidPaymentAmount');
  String get valPaymentExceedsDebt => _t('valPaymentExceedsDebt');
  String get failedAddPayment => _t('failedAddPayment');
  String get expensesManagement => _t('expensesManagement');
  String get addExpenseFab => _t('addExpenseFab');
  String get searchExpenseHint => _t('searchExpenseHint');
  String get totalExpenses => _t('totalExpenses');
  String get thisMonthLabel => _t('thisMonthLabel');
  String get avgExpense => _t('avgExpense');
  String get topCategory => _t('topCategory');
  String get noExpensesHint => _t('noExpensesHint');
  String get addFirstExpense => _t('addFirstExpense');
  String get categoryRequired => _t('categoryRequired');
  String get descriptionOptional => _t('descriptionOptional');
  String get expenseDate => _t('expenseDate');
  String get valEnterAmount => _t('valEnterAmount');
  String get valValidAmount => _t('valValidAmount');
  String get selectDateRange => _t('selectDateRange');
  String get startDate => _t('startDate');
  String get endDate => _t('endDate');
  String get applyFilter => _t('applyFilter');
  String get dateRangeInvalid => _t('dateRangeInvalid');
  String get updateExpense => _t('updateExpense');
  String get allCustomers => _t('allCustomers');
  String get withDebt => _t('withDebt');
  String get noDebtLabel => _t('noDebtLabel');
  String get customerDetails => _t('customerDetails');
  String get debtShort => _t('debtShort');
  String get searchCustomerHint => _t('searchCustomerHint');
  String get hintFullNameExample => _t('hintFullNameExample');
  String get hintPhoneExample => _t('hintPhoneExample');
  String get hintAddress => _t('hintAddress');
  String get customerId => _t('customerId');
  String get customerInformation => _t('customerInformation');
  String get memberSince => _t('memberSince');
  String get totalSpent => _t('totalSpent');
  String get lastPurchase => _t('lastPurchase');
  String get purchaseHistory => _t('purchaseHistory');
  String get noPurchasesYet => _t('noPurchasesYet');
  String get purchaseHistoryHint => _t('purchaseHistoryHint');
  String get editCustomerTooltip => _t('editCustomerTooltip');
  String get addNewProduct => _t('addNewProduct');
  String get productDetails => _t('productDetails');
  String get productIdLabel => _t('productIdLabel');
  String get timestampsCreated => _t('timestampsCreated');
  String get timestampsLastUpdated => _t('timestampsLastUpdated');
  String get searchProductListHint => _t('searchProductListHint');
  String get allCategories => _t('allCategories');
  String get hintProductNameEx => _t('hintProductNameEx');
  String get hintBrandEx => _t('hintBrandEx');
  String get hintPriceZero => _t('hintPriceZero');
  String get hintQuantityZero => _t('hintQuantityZero');
  String get hintMinStock => _t('hintMinStock');
  String get hintBarcode => _t('hintBarcode');
  String get hintProductNotes => _t('hintProductNotes');
  String get brand => _t('brand');
  String get notes => _t('notes');
  String get minStockLevel => _t('minStockLevel');
  String get selectCategory => _t('selectCategory');
  String get hintCategoryName => _t('hintCategoryName');
  String get hintCategoryDesc => _t('hintCategoryDesc');
  String get gallery => _t('gallery');
  String get camera => _t('camera');
  String get removeImage => _t('removeImage');
  String get failedAdjustStock => _t('failedAdjustStock');
  String get completePayment => _t('completePayment');
  String get completeSale => _t('completeSale');
  String get cashReceived => _t('cashReceived');
  String get cardPayment => _t('cardPayment');
  String get cashAmount => _t('cashAmount');
  String get cardAmount => _t('cardAmount');
  String get selectCustomerCreditWarning => _t('selectCustomerCreditWarning');
  String get pleaseSelectCustomerCredit => _t('pleaseSelectCustomerCredit');
  String get insufficientCashReceived => _t('insufficientCashReceived');
  String get totalPaymentLessThanOrder => _t('totalPaymentLessThanOrder');
  String get failedCompleteSale => _t('failedCompleteSale');
  String get paymentOnCredit => _t('paymentOnCredit');
  String get paymentMixedDetail => _t('paymentMixedDetail');
  String get totalPaymentLabel => _t('totalPaymentLabel');
  String get remainingLabel => _t('remainingLabel');
  String get changeToReturn => _t('changeToReturn');
  String get ok => _t('ok');
  String get orderItems => _t('orderItems');
  String get orderSubtotal => _t('orderSubtotal');
  String get orderDiscount => _t('orderDiscount');
  String get orderTotal => _t('orderTotal');
  String get orderProfit => _t('orderProfit');
  String get applyDiscount => _t('applyDiscount');
  String get removeDiscount => _t('removeDiscount');
  String get apply => _t('apply');
  String get subtotalColon => _t('subtotalColon');
  String get discountColon => _t('discountColon');
  String get walkInCustomer => _t('walkInCustomer');
  String get noCustomerRecord => _t('noCustomerRecord');
  String get close => _t('close');
  String get selectCustomerTitle => _t('selectCustomerTitle');
  String get allProductsPos => _t('allProductsPos');
  String get searchPosHint => _t('searchPosHint');
  String get adjust => _t('adjust');
  String get paymentAmount => _t('paymentAmount');
  String get addPaymentTitle => _t('addPaymentTitle');
  String get printComingSoon => _t('printComingSoon');
  String get discountExceedsSubtotal => _t('discountExceedsSubtotal');
  String get failedUpdateCategory => _t('failedUpdateCategory');
  String get failedAddCategory => _t('failedAddCategory');
  String get topSellersThisMonth => _t('topSellersThisMonth');
  String get searchInvoiceNumberHint => _t('searchInvoiceNumberHint');
  String get allDebtsFilter => _t('allDebtsFilter');
  String get updateCategory => _t('updateCategory');
  String get barcodePrefix => _t('barcodePrefix');
  String get valuePrefix => _t('valuePrefix');
  String get operationFailed => _t('operationFailed');
  String get basicInformation => _t('basicInformation');
  String get pricingSection => _t('pricingSection');
  String get inventorySection => _t('inventorySection');
  String get additionalInformation => _t('additionalInformation');
  String get productImage => _t('productImage');
  String get profitSummary => _t('profitSummary');
  String get initialQuantity => _t('initialQuantity');
  String get minQuantityAlert => _t('minQuantityAlert');
  String get barcodeOptional => _t('barcodeOptional');
  String get notesOptional => _t('notesOptional');
  String get pleaseSelectCategory => _t('pleaseSelectCategory');
  String get productNameRequired => _t('productNameRequired');
  String get addressOptional => _t('addressOptional');
  String get updateCustomer => _t('updateCustomer');
  String get noImageSelected => _t('noImageSelected');
  String get profitPerUnit => _t('profitPerUnit');
  String get profitMarginLabel => _t('profitMarginLabel');
  String get updateButton => _t('updateButton');
  String get noImageShort => _t('noImageShort');
  String get minQuantityLabel => _t('minQuantityLabel');
  String get categoriesSubtitle => _t('categoriesSubtitle');
  String get noCategoriesYet => _t('noCategoriesYet');
  String get addFirstCategoryHint => _t('addFirstCategoryHint');
  String get noBrand => _t('noBrand');
  String get unknownCategory => _t('unknownCategory');
  String get profitLabelShort => _t('profitLabelShort');
  String get stockQtyShort => _t('stockQtyShort');
  String get lowQtyShort => _t('lowQtyShort');
  String get addFirstProductHint => _t('addFirstProductHint');

  /// Empty state title (distinct from [noProducts] search empty).
  String get noProductsYet => _t('noProductsYet');
  String get categoryFilter => _t('categoryFilter');
  String get gridView => _t('gridView');
  String get listView => _t('listView');
  String get posSubtitle => _t('posSubtitle');
  String get cartIsEmptyTitle => _t('cartIsEmptyTitle');
  String get cartGetStartedSubtitle => _t('cartGetStartedSubtitle');
  String get customerSectionLabel => _t('customerSectionLabel');
  String get noProductsAvailable => _t('noProductsAvailable');
  String get noProductsInStockPos => _t('noProductsInStockPos');
  String get clearCartConfirmMessage => _t('clearCartConfirmMessage');
  String get totalColon => _t('totalColon');
  String get discountFieldPercent => _t('discountFieldPercent');
  String get discountFieldAmount => _t('discountFieldAmount');
  String get hintDiscountPercentEx => _t('hintDiscountPercentEx');
  String get hintDiscountAmountEx => _t('hintDiscountAmountEx');
  String get hintExpenseAmountEx => _t('hintExpenseAmountEx');
  String get expenseDescriptionHint => _t('expenseDescriptionHint');
  String get currentStockColon => _t('currentStockColon');
  String get stockValueColon => _t('stockValueColon');
  String get noCustomersYetTitle => _t('noCustomersYetTitle');
  String get addFirstCustomerHint => _t('addFirstCustomerHint');
  String get invoiceHeading => _t('invoiceHeading');
  String get printInvoiceTooltip => _t('printInvoiceTooltip');
  String get totalAmountLabel => _t('totalAmountLabel');
  String get saleItemsTitle => _t('saleItemsTitle');
  String get tableProduct => _t('tableProduct');
  String get tablePrice => _t('tablePrice');
  String get tableQtyShort => _t('tableQtyShort');
  String get paymentDetailsTitle => _t('paymentDetailsTitle');
  String get remainingDebt => _t('remainingDebt');
  String get saleSummaryTitle => _t('saleSummaryTitle');
  String get paymentMixedShort => _t('paymentMixedShort');
  String get paymentOnCreditShort => _t('paymentOnCreditShort');
  String get notApplicable => _t('notApplicable');
  String get debtInformationSection => _t('debtInformationSection');
  String get debtIdLabel => _t('debtIdLabel');
  String get createdDateLabel => _t('createdDateLabel');
  String get paymentsMadeLabel => _t('paymentsMadeLabel');
  String get statusField => _t('statusField');

  String invoiceColon(String number) =>
      _t('invoiceColon').replaceAll('{number}', number);
  String get noPaymentsYetDebt => _t('noPaymentsYetDebt');
  String get customerLabelDetail => _t('customerLabelDetail');
  String get invoiceNumberLabel => _t('invoiceNumberLabel');
  String get salesChartSubtitle => _t('salesChartSubtitle');
  String get lastPurchaseNever => _t('lastPurchaseNever');
  String get enterValidNumber => _t('enterValidNumber');

  String productsCountInventory(int count) =>
      _t('productsCountInventory').replaceAll('{count}', '$count');
  String get numberCannotBeNegative => _t('numberCannotBeNegative');
  String get enterValidPriceMsg => _t('enterValidPriceMsg');
  String get priceCannotBeNegative => _t('priceCannotBeNegative');
  String get enterValidQuantityMsg => _t('enterValidQuantityMsg');
  String get quantityCannotBeNegative => _t('quantityCannotBeNegative');
  String get enterValidPercentage => _t('enterValidPercentage');
  String get percentageRange => _t('percentageRange');
  String get invalidBarcodeFormat => _t('invalidBarcodeFormat');

  String passwordTooShortMsg(int min) =>
      _t('passwordTooShort').replaceAll('{min}', '$min');

  String expenseCategoryLabel(String key) {
    switch (key) {
      case 'Rent':
        return rent;
      case 'Utilities':
        return utilities;
      case 'Salaries':
        return salaries;
      case 'Supplies':
        return supplies;
      case 'Marketing':
        return marketing;
      case 'Maintenance':
        return maintenance;
      case 'Transport':
        return transport;
      case 'Other':
        return other;
      default:
        return key;
    }
  }

  String adjustmentReasonLabel(String key) {
    switch (key) {
      case 'Restock':
        return restock;
      case 'Return from Customer':
        return returnFromCustomer;
      case 'Correction':
        return correction;
      case 'Other':
        return other;
      case 'Damage':
        return damage;
      case 'Theft':
        return theft;
      case 'Return to Supplier':
        return returnToSupplier;
      default:
        return key;
    }
  }

  String onlyAvailableInStockCount(int count) =>
      _t('onlyAvailableInStock').replaceAll('{count}', '$count');

  String cannotAddMoreInStockCount(int count) =>
      _t('cannotAddMoreInStock').replaceAll('{count}', '$count');

  String productAddedToCartName(String name) =>
      _t('productAddedToCart').replaceAll('{name}', name);

  String insufficientCashAmount(String amount) =>
      _t('insufficientCash').replaceAll('{amount}', amount);

  String amountAddedToDebtFormatted(String amount) =>
      _t('amountAddedToDebt').replaceAll('{amount}', amount);

  String paymentRecordedRemainingFormatted(String amount) =>
      _t('paymentRecordedRemaining').replaceAll('{amount}', amount);

  String stockAdjustedNewUnitsCount(int count) =>
      _t('stockAdjustedNewUnits').replaceAll('{count}', '$count');

  String invoiceHashId(int id) => _t('invoiceHash').replaceAll('{id}', '$id');

  String productHashId(int id) => _t('productHash').replaceAll('{id}', '$id');

  String unitsCountLabel(int count) =>
      _t('unitsCount').replaceAll('{count}', '$count');

  String cartWithItemsCount(int count) =>
      _t('cartWithItemsCount').replaceAll('{count}', '$count');

  String ofMaxStockCount(int count) =>
      _t('ofMaxStock').replaceAll('{count}', '$count');

  String productCountInCategoryLabel(int count) =>
      _t('productCountInCategory').replaceAll('{count}', '$count');

  String customersRegistered(int count) =>
      _t('customersRegisteredCount').replaceAll('{count}', '$count');

  String salesRecordedCount(int count) =>
      _t('salesRecordedCount').replaceAll('{count}', '$count');

  String itemsCountShortLabel(int count) =>
      _t('itemsCountShort').replaceAll('{count}', '$count');

  String expensesRecordedCount(int count) =>
      _t('expensesRecordedCount').replaceAll('{count}', '$count');

  String debtsTrackedCount(int count) =>
      _t('debtsTrackedCount').replaceAll('{count}', '$count');

  String cartItemProfitFormatted(String amount) =>
      _t('cartItemProfitAmount').replaceAll('{amount}', amount);

  String errorWithMessageText(String message) =>
      _t('errorWithMessage').replaceAll('{message}', message);

  String fieldRequiredNamed(String field) =>
      _t('fieldRequiredFor').replaceAll('{field}', field);

  String usernameTooShortMsg(int min) =>
      _t('usernameTooShort').replaceAll('{min}', '$min');

  String usernameTooLongMsg(int max) =>
      _t('usernameTooLong').replaceAll('{max}', '$max');

  String passwordTooLongMsg(int max) =>
      _t('passwordTooLong').replaceAll('{max}', '$max');

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
