part of 'edit_goods_bloc.dart';

enum EditGoodsStatus { initial, loading, success, failure }

extension EditGoodsStatusX on EditGoodsStatus {
  bool get isLoadingOrSuccess => [
        EditGoodsStatus.loading,
        EditGoodsStatus.success,
      ].contains(this);
}

class EditGoodsState extends Equatable {
  EditGoodsState({
    this.status = EditGoodsStatus.initial,
    this.initialGoods,
    this.name = '',
    this.capacity = 0,
    this.quantity = 0,
    this.soldQuantity = 0,
    DateTime? purchaseDate,
    DateTime? expirationDate,
  })  : purchaseDate = purchaseDate ??
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
        expirationDate = expirationDate ??
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            );

  final EditGoodsStatus status;
  final Goods? initialGoods;
  final String name;
  final int capacity;
  final int quantity;
  final int soldQuantity;
  final DateTime purchaseDate;
  final DateTime expirationDate;

  bool get isNewGoods => initialGoods == null;

  EditGoodsState copyWith({
    EditGoodsStatus? status,
    Goods? initialGoods,
    String? name,
    int? capacity,
    int? quantity,
    int? soldQuantity,
    DateTime? purchaseDate,
    DateTime? expirationDate,
  }) {
    return EditGoodsState(
      status: status ?? this.status,
      initialGoods: initialGoods ?? this.initialGoods,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      quantity: quantity ?? this.quantity,
      soldQuantity: soldQuantity ?? this.soldQuantity,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }

  @override
  List<Object?> get props => [
        status,
        initialGoods,
        name,
        capacity,
        quantity,
        soldQuantity,
        purchaseDate,
        expirationDate,
      ];
}
