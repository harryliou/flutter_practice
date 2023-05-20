import 'package:goods_api/goods_api.dart';
import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart' as sql;

/// {@template sqlite_goods_api}
/// A Flutter implementation of the GoodsApi that uses sqlite.
/// {@endtemplate}
class SqliteGoodsApi extends GoodsApi {
  /// {@macro sqlite_goods_api}
  SqliteGoodsApi();

  final _goodsStreamController = BehaviorSubject<List<Goods>>.seeded(const []);

  static Future<void> _createTables(sql.Database database) async {
    await database.execute('CREATE TABLE goods ('
        'id TEXT PRIMARY KEY, '
        'name TEXT, '
        'capacity INTEGER, '
        'quantity INTEGER, '
        'soldQuantity INTEGER, '
        'purchaseDate TEXT, '
        'expirationDate TEXT, '
        'atStore INTEGER '
        ')');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'goods.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await _createTables(database);
      },
    );
  }

  Future<void> init() async {
    final db = await SqliteGoodsApi.db();
    final goodsResult = await db.query('goods', orderBy: 'id');
    if (goodsResult.isNotEmpty) {
      final goods = goodsResult.map((goods) {
        return Goods(
          id: goods['id'] as String,
          name: goods['name'] as String,
          capacity: goods['capacity'] as int,
          quantity: goods['quantity'] as int,
          soldQuantity: goods['soldQuantity'] as int,
          purchaseDate: DateTime.parse(goods['purchaseDate'] as String),
          expirationDate: DateTime.parse(goods['expirationDate'] as String),
          atStore: goods['atStore'] == 1,
        );
      }).toList();
      _goodsStreamController.add(goods);
    } else {
      _goodsStreamController.add(const []);
    }
  }

  @override
  Future<int> atStoreAll({required bool atStore}) async {
    final db = await SqliteGoodsApi.db();
    final goodsList = [..._goodsStreamController.value];
    final changedGoodsAmount =
        goodsList.where((t) => t.atStore != atStore).length;
    final newGoods = [
      for (final goods in goodsList) goods.copyWith(atStore: atStore)
    ];
    _goodsStreamController.add(newGoods);
    await db.update('goods', {
      'atStore': atStore ? 1 : 0,
    });
    return changedGoodsAmount;
  }

  @override
  Future<void> deleteGoods(String id) async {
    final db = await SqliteGoodsApi.db();
    final goods = [..._goodsStreamController.value];
    final goodsIndex = goods.indexWhere((t) => t.id == id);
    if (goodsIndex == -1) {
      throw GoodsNotFoundException();
    } else {
      goods.removeAt(goodsIndex);
      _goodsStreamController.add(goods);
      await db.delete('goods', where: 'id = ?', whereArgs: [id]);
    }
  }

  @override
  Stream<List<Goods>> getGoods() => _goodsStreamController.asBroadcastStream();

  @override
  Future<void> saveGoods(Goods goods) async {
    final goodss = [..._goodsStreamController.value];
    final todoIndex = goodss.indexWhere((t) => t.id == goods.id);
    if (todoIndex >= 0) {
      goodss[todoIndex] = goods;
    } else {
      goodss.add(goods);
    }
    _goodsStreamController.add(goodss);

    final db = await SqliteGoodsApi.db();
    final data = {
      'id': goods.id,
      'name': goods.name,
      'capacity': goods.capacity,
      'quantity': goods.quantity,
      'soldQuantity': goods.soldQuantity,
      'purchaseDate': goods.purchaseDate.toIso8601String(),
      'expirationDate': goods.expirationDate.toIso8601String(),
      'atStore': goods.atStore ? 1 : 0,
    };
    await db.insert(
      'goods',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }
}
