part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object> get props => [];
}

class ListSubscriptionRequested extends ListEvent {
  const ListSubscriptionRequested();
}

class ListGoodsReomveFromStore extends ListEvent {
  const ListGoodsReomveFromStore({
    required this.goods,
  });

  final Goods goods;

  @override
  List<Object> get props => [
        goods,
      ];
}

class ListAtStoreQuantityChanged extends ListEvent {
  const ListAtStoreQuantityChanged({
    required this.goods,
    required this.atStoreQuantity,
  });

  final Goods goods;
  final int atStoreQuantity;

  @override
  List<Object> get props => [goods, atStoreQuantity];
}

class ListAtStoreSell extends ListEvent {
  const ListAtStoreSell();

  @override
  List<Object> get props => [];
}
