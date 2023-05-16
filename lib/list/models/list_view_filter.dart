import 'package:goods_repository/goods_repository.dart';

enum GoodsViewFilter { all, notAtStoreOnly, atStoreOnly }

extension TodosViewFilterX on GoodsViewFilter {
  bool apply(Goods goods) {
    switch (this) {
      case GoodsViewFilter.all:
        return true;
      case GoodsViewFilter.notAtStoreOnly:
        return !goods.atStore;
      case GoodsViewFilter.atStoreOnly:
        return goods.atStore;
    }
  }

  Iterable<Goods> applyAll(Iterable<Goods> goods) {
    return goods.where(apply);
  }
}
