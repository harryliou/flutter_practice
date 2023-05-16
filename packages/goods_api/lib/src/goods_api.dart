import 'package:goods_api/goods_api.dart';

/// {@template todos_api}
/// The interface for an API that provides access to a list of goods.
/// {@endtemplate}
abstract class GoodsApi {
  /// {@macro goods_api}
  const GoodsApi();

  /// Provides a [Stream] of all goods.
  Stream<List<Goods>> getGoods();

  /// Saves a [goods].
  ///
  /// If a [goods] with the same id already exists, it will be replaced.
  Future<void> saveGoods(Goods goods);

  /// Deletes the `goods` with the given id.
  ///
  /// If no `goods` with the given id exists,
  /// a [GoodsNotFoundException] error is
  /// thrown.
  Future<void> deleteGoods(String id);

  /// Sets the `atStore` state of all goods to the given value.
  ///
  /// Returns the number of updated goods.
  Future<int> atStoreAll({required bool atStore});
}

/// Error thrown when a [Goods] with a given id is not found.
class GoodsNotFoundException implements Exception {}
