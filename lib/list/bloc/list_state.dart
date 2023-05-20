part of 'list_bloc.dart';

enum ListStatus { initial, loading, success, failure }

class ListState extends Equatable {
  const ListState({
    this.status = ListStatus.initial,
    this.goods = const [],
    this.filter = GoodsViewFilter.all,
    this.lastDeletedGoods,
  });

  final ListStatus status;
  final List<Goods> goods;
  final GoodsViewFilter filter;
  final Goods? lastDeletedGoods;

  List<Goods> get filteredGoods => filter.applyAll(goods).toList();

  ListState copyWith({
    ListStatus Function()? status,
    List<Goods> Function()? goods,
    GoodsViewFilter Function()? filter,
    Goods? Function()? lastDeletedGoods,
  }) {
    return ListState(
      status: status != null ? status() : this.status,
      goods: goods != null ? goods() : this.goods,
      filter: filter != null ? filter() : this.filter,
      lastDeletedGoods:
          lastDeletedGoods != null ? lastDeletedGoods() : this.lastDeletedGoods,
    );
  }

  @override
  List<Object?> get props => [
        status,
        goods,
        filter,
        lastDeletedGoods,
      ];
}
