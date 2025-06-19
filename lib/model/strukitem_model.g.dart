// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strukitem_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StrukItem _$StrukItemFromJson(Map<String, dynamic> json) => StrukItem(
      count: (json['count'] as num?)?.toInt(),
      id: json['id'] as String?,
      price: (json['price'] as num?)?.toInt(),
      title: json['title'] as String,
    );

Map<String, dynamic> _$StrukItemToJson(StrukItem instance) => <String, dynamic>{
      'title': instance.title,
      'price': instance.price,
      'id': instance.id,
      'count': instance.count,
    };
