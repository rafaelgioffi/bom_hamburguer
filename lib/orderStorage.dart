import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'main.dart';

class OrderStorage {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'orders.db');
  
  return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customerName TEXT,
            items TEXT,
            total REAL,
            date TEXT
          )
        ''');
      },
    );
  }

static Future<void> saveOrder(String customerName, Map<ItemType, MenuItem?> items, double total) async {
    final db = await database;
    final itemsString = items.values
        .whereType<MenuItem>()
        .map((item) => item.name)
        .join(', ');

    await db.insert(
      'orders',
      {
        'customerName': customerName,
        'items': itemsString,
        'total': total,
        'date': DateTime.now().toIso8601String(),
      });
  }

  static Future<List<Map<String, dynamic>>> fetchOrders() async {
    final db = await database;
    return await db.query('orders', orderBy: 'date DESC');
  }
  
  static Future<void> clearOrders() async {
    final db = await database;
    await db.delete('orders');
   }
   
}