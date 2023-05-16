import 'package:goods_api/goods_api.dart';

/// {@template goods_repository}
/// A repository that handles `goods` related requests.
/// {@endtemplate}
class GoodsRepository {
  /// {@macro goods_repository}
  const GoodsRepository({
    required GoodsApi goodsApi,
  }) : _goodsApi = goodsApi;

  final GoodsApi _goodsApi;

  /// Provides a [Stream] of all goods.
  Stream<List<Goods>> getGoods() => _goodsApi.getGoods();

  /// Saves a [goods].
  ///
  /// If a [goods] with the same id already exists, it will be replaced.
  Future<void> saveGoods(Goods goods) => _goodsApi.saveGoods(goods);

  /// Deletes the `goods` with the given id.
  ///
  /// If no `goods` with the given id exists,
  /// a [GoodsNotFoundException] error is
  /// thrown.
  Future<void> deleteGoods(String id) => _goodsApi.deleteGoods(id);

  /// Sets the `atStore` state of all goods to the given value.
  ///
  /// Returns the number of updated todos.
  Future<int> atStoreAll({required bool atStore}) =>
      _goodsApi.atStoreAll(atStore: atStore);
}
