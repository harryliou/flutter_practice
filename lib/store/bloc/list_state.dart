part of 'list_bloc.dart';

enum ListStatus { initial, loading, success, failure }

class ListState extends Equatable {
  const ListState({
    this.status = ListStatus.initial,
    this.goods = const [],
  });

  final ListStatus status;
  final List<Goods> goods;

  List<Goods> get atStoreGoods =>
      goods.where((goods) => goods.atStore).toList();

  int get atStoreGoodsTotalPrice => atStoreGoods.fold(
        0,
        (previousValue, goods) =>
            previousValue + (goods.unitPrice * goods.atStoreQuantity),
      );

  ListState copyWith({
    ListStatus Function()? status,
    List<Goods> Function()? goods,
    Goods? Function()? lastModifyGoods,
  }) {
    return ListState(
      status: status != null ? status() : this.status,
      goods: goods != null ? goods() : this.goods,
    );
  }

  @override
  List<Object?> get props => [
        status,
        goods,
      ];
}
