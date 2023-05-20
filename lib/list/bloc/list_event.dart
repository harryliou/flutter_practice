part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object> get props => [];
}

class ListSubscriptionRequested extends ListEvent {
  const ListSubscriptionRequested();
}

class ListGoodsAtStoreToggled extends ListEvent {
  const ListGoodsAtStoreToggled({
    required this.goods,
    required this.atStore,
  });

  final Goods goods;
  final bool atStore;

  @override
  List<Object> get props => [goods, atStore];
}

class ListGoodsDeleted extends ListEvent {
  const ListGoodsDeleted(this.goods);

  final Goods goods;

  @override
  List<Object> get props => [goods];
}

class ListUndoDeletionRequested extends ListEvent {
  const ListUndoDeletionRequested();
}

class ListFilterChanged extends ListEvent {
  const ListFilterChanged(this.filter);

  final GoodsViewFilter filter;

  @override
  List<Object> get props => [filter];
}

class ListToggleAllRequested extends ListEvent {
  const ListToggleAllRequested();
}
