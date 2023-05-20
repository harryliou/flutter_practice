import 'package:equatable/equatable.dart';
import 'package:goods_api/goods_api.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'goods.g.dart';

/// {@template goods_item}
/// A single `goods` item.
///
/// Contains a [name], [capacity], [quantity], [soldQuantity], [purchaseDate],
/// [unitPrice], [expirationDate], [atStoreQuantity] and [id], in addition to a [atStore]
/// flag.
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [Goods]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@immutable
@JsonSerializable()
class Goods extends Equatable {
  /// {@macro todo_item}
  Goods({
    String? id,
    required this.name,
    this.capacity = 0,
    this.quantity = 0,
    this.soldQuantity = 0,
    this.unitPrice = 0,
    DateTime? purchaseDate,
    DateTime? expirationDate,
    this.atStore = false,
    this.atStoreQuantity = 0,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4(),
        purchaseDate = purchaseDate ?? DateTime.now(),
        expirationDate = expirationDate ?? DateTime.now();

  /// The unique identifier of the `goods`.
  ///
  /// Cannot be empty.
  final String id;

  /// The name of the `goods`.
  ///
  /// Note that the name may be empty.
  final String name;

  /// The capacity of the `goods`.
  ///
  /// Note that the capacity may be empty.
  final int capacity;

  /// The quantity of the `goods`.
  ///
  /// Note that the quantity may be empty.
  final int quantity;

  /// The sold quantity of the `goods`.
  ///
  /// Note that the sold quantity may be empty.
  final int soldQuantity;

  /// The unit price of the `goods`.
  ///
  /// Note that the unit pric may be empty.
  final int unitPrice;

  /// The purchase date of the `goods`.
  ///
  /// Note that the purchase date may be empty.
  final DateTime purchaseDate;

  /// The expiration date of the `goods`.
  ///
  /// Note that the expiration date may be empty.
  final DateTime expirationDate;

  /// Whether the `goods` is at store.
  ///
  /// Defaults to `false`.
  final bool atStore;

  /// The quantity of the `goods` at store.
  ///
  /// Note that the quantity may be empty.
  final int atStoreQuantity;

  /// Returns a copy of this `todo` with the given values updated.
  ///
  /// {@macro goods_item}
  Goods copyWith({
    String? id,
    String? name,
    int? capacity,
    int? quantity,
    int? soldQuantity,
    int? unitPrice,
    DateTime? purchaseDate,
    DateTime? expirationDate,
    bool? atStore,
    int? atStoreQuantity,
  }) {
    return Goods(
      id: id ?? this.id,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      quantity: quantity ?? this.quantity,
      soldQuantity: soldQuantity ?? this.soldQuantity,
      unitPrice: unitPrice ?? this.unitPrice,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expirationDate: expirationDate ?? this.expirationDate,
      atStore: atStore ?? this.atStore,
      atStoreQuantity: atStoreQuantity ?? this.atStoreQuantity,
    );
  }

  /// Deserializes the given [JsonMap] into a [Goods].
  static Goods fromJson(JsonMap json) => _$GoodsFromJson(json);

  /// Converts this [Goods] into a [JsonMap].
  JsonMap toJson() => _$GoodsToJson(this);

  @override
  List<Object> get props => [
        id,
        name,
        capacity,
        quantity,
        soldQuantity,
        unitPrice,
        purchaseDate,
        expirationDate,
        atStore,
        atStoreQuantity
      ];
}
