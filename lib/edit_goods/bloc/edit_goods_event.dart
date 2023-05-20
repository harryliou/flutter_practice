part of 'edit_goods_bloc.dart';

abstract class EditGoodsEvent extends Equatable {
  const EditGoodsEvent();

  @override
  List<Object> get props => [];
}

class EditGoodsNameChanged extends EditGoodsEvent {
  const EditGoodsNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class EditGoodsCapacityChanged extends EditGoodsEvent {
  const EditGoodsCapacityChanged(this.capacity);

  final int capacity;

  @override
  List<Object> get props => [capacity];
}

class EditGoodsQuantityChanged extends EditGoodsEvent {
  const EditGoodsQuantityChanged(this.quantity);

  final int quantity;

  @override
  List<Object> get props => [quantity];
}

class EditGoodsSoldQuantityChanged extends EditGoodsEvent {
  const EditGoodsSoldQuantityChanged(this.soldQuantity);

  final int soldQuantity;

  @override
  List<Object> get props => [soldQuantity];
}

class EditGoodsPurchaseDateChanged extends EditGoodsEvent {
  const EditGoodsPurchaseDateChanged(this.purchaseDate);

  final DateTime purchaseDate;

  @override
  List<Object> get props => [purchaseDate];
}

class EditGoodsExpirationDateChanged extends EditGoodsEvent {
  const EditGoodsExpirationDateChanged(this.expirationDate);

  final DateTime expirationDate;

  @override
  List<Object> get props => [expirationDate];
}

class EditGoodsSubmitted extends EditGoodsEvent {
  const EditGoodsSubmitted();
}
