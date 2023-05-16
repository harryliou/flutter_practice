// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Goods _$GoodsFromJson(Map<String, dynamic> json) => Goods(
      id: json['id'] as String?,
      name: json['name'] as String,
      capacity: json['capacity'] as int,
      quantity: json['quantity'] as int,
      soldQuantity: json['soldQuantity'] as int,
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      expirationDate: DateTime.parse(json['expirationDate'] as String),
      atStore: json['atStore'] as bool,
    );

Map<String, dynamic> _$GoodsToJson(Goods instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'capacity': instance.capacity,
      'quantity': instance.quantity,
      'soldQuantity': instance.soldQuantity,
      'purchaseDate': instance.purchaseDate.toIso8601String(),
      'expirationDate': instance.expirationDate.toIso8601String(),
      'atStore': instance.atStore,
    };
