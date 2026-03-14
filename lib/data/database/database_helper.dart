// lib/data/database/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tables.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('magasin.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    print('📁 Database path: $path'); // Debug log

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onOpen: (db) {
        print('✅ Database opened successfully');
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    print('🔨 Creating database tables...');

    // Users table
    await db.execute('''
      CREATE TABLE ${Tables.users} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        full_name TEXT NOT NULL,
        role TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    print('✅ Users table created');

    // Categories table
    await db.execute('''
      CREATE TABLE ${Tables.categories} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        description TEXT,
        created_at TEXT NOT NULL
      )
    ''');
    print('✅ Categories table created');

    // Products table
    await db.execute('''
      CREATE TABLE ${Tables.products} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        brand TEXT,
        purchase_price REAL NOT NULL,
        selling_price REAL NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 0,
        min_quantity INTEGER DEFAULT 5,
        barcode TEXT UNIQUE,
        image_path TEXT,
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES ${Tables.categories}(id)
      )
    ''');
    print('✅ Products table created');

    // Customers table
    await db.execute('''
      CREATE TABLE ${Tables.customers} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL UNIQUE,
        address TEXT,
        total_purchases REAL DEFAULT 0,
        total_debt REAL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');
    print('✅ Customers table created');

    // Sales table
    await db.execute('''
      CREATE TABLE ${Tables.sales} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        invoice_number TEXT NOT NULL UNIQUE,
        customer_id INTEGER,
        user_id INTEGER NOT NULL,
        subtotal REAL NOT NULL,
        discount REAL DEFAULT 0,
        total REAL NOT NULL,
        payment_method TEXT NOT NULL,
        paid_amount REAL NOT NULL,
        remaining_debt REAL DEFAULT 0,
        profit REAL NOT NULL,
        sale_date TEXT NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES ${Tables.customers}(id),
        FOREIGN KEY (user_id) REFERENCES ${Tables.users}(id)
      )
    ''');
    print('✅ Sales table created');

    // Sale Items table
    await db.execute('''
      CREATE TABLE ${Tables.saleItems} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sale_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        product_name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        total_price REAL NOT NULL,
        profit REAL NOT NULL,
        FOREIGN KEY (sale_id) REFERENCES ${Tables.sales}(id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES ${Tables.products}(id)
      )
    ''');
    print('✅ Sale Items table created');

    // Debts table
    await db.execute('''
      CREATE TABLE ${Tables.debts} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        sale_id INTEGER NOT NULL,
        total_amount REAL NOT NULL,
        paid_amount REAL DEFAULT 0,
        remaining_amount REAL NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES ${Tables.customers}(id),
        FOREIGN KEY (sale_id) REFERENCES ${Tables.sales}(id)
      )
    ''');
    print('✅ Debts table created');

    // Debt Payments table
    await db.execute('''
      CREATE TABLE ${Tables.debtPayments} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        debt_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        payment_date TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (debt_id) REFERENCES ${Tables.debts}(id)
      )
    ''');
    print('✅ Debt Payments table created');

    // Expenses table
    await db.execute('''
      CREATE TABLE ${Tables.expenses} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        description TEXT,
        expense_date TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    print('✅ Expenses table created');

    // Stock Adjustments table
    await db.execute('''
      CREATE TABLE ${Tables.stockAdjustments} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        quantity_change INTEGER NOT NULL,
        reason TEXT NOT NULL,
        notes TEXT,
        user_id INTEGER NOT NULL,
        adjustment_date TEXT NOT NULL,
        FOREIGN KEY (product_id) REFERENCES ${Tables.products}(id),
        FOREIGN KEY (user_id) REFERENCES ${Tables.users}(id)
      )
    ''');
    print('✅ Stock Adjustments table created');

    // Insert default admin user
    print('👤 Creating default admin user...');
    await db.insert(Tables.users, {
      'username': 'admin',
      'password': 'admin123', // In production, hash this!
      'full_name': 'Administrator',
      'role': 'admin',
      'created_at': DateTime.now().toIso8601String(),
    });
    print('✅ Default admin user created (username: admin, password: admin123)');

    // Insert default categories
    print('📂 Creating default categories...');
    final defaultCategories = [
      'Smartphones',
      'Chargers',
      'Headphones',
      'Phone Cases',
      'Screen Protectors',
      'Cables',
      'Power Banks',
      'Accessories',
    ];

    for (var category in defaultCategories) {
      await db.insert(Tables.categories, {
        'name': category,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
    print('✅ ${defaultCategories.length} default categories created');

    print('🎉 Database setup complete!');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
