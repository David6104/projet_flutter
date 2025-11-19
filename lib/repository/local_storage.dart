import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalStorage {
  static const dbName = 'bloc2_store.db';
  static const favoritesTable = 'favorites';
  static const cartTable = 'cart';

  Database? _db;

  Future<Database> _getDb() async {
    if (_db != null) return _db!;
    _db = await openDatabase(
      join(await getDatabasesPath(), dbName),
      version: 1,
      onCreate: (db, v) async {
        await db.execute(
          'CREATE TABLE $favoritesTable (id INTEGER PRIMARY KEY)',
        );
        await db.execute(
          'CREATE TABLE $cartTable (id INTEGER PRIMARY KEY, qty INTEGER NOT NULL)',
        );
      },
    );
    return _db!;
  }

  // Favorites
  Future<List<int>> getFavorites() async {
    final db = await _getDb();
    final rows = await db.query(favoritesTable);
    return rows.map((r) => r['id'] as int).toList();
  }

  Future<void> addFavorite(int id) async {
    final db = await _getDb();
    await db.insert(favoritesTable, {
      'id': id,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> removeFavorite(int id) async {
    final db = await _getDb();
    await db.delete(favoritesTable, where: 'id=?', whereArgs: [id]);
  }

  // Cart
  Future<Map<int, int>> getCart() async {
    final db = await _getDb();
    final rows = await db.query(cartTable);
    return {for (var r in rows) r['id'] as int: r['qty'] as int};
  }

  Future<void> setCartQty(int id, int qty) async {
    final db = await _getDb();
    if (qty <= 0) {
      await db.delete(cartTable, where: 'id=?', whereArgs: [id]);
    } else {
      await db.insert(cartTable, {
        'id': id,
        'qty': qty,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> clearCart() async {
    final db = await _getDb();
    await db.delete(cartTable);
  }
}
