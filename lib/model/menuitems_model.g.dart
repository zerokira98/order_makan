// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menuitems_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItems _$MenuItemsFromJson(Map<String, dynamic> json) => MenuItems(
      count: (json['count'] as num?)?.toInt(),
      id: json['id'] as String?,
      price: (json['price'] as num?)?.toInt(),
      title: json['title'] as String,
      imgDir: json['imgDir'] as String,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MenuItemsToJson(MenuItems instance) => <String, dynamic>{
      'title': instance.title,
      'imgDir': instance.imgDir,
      'price': instance.price,
      'id': instance.id,
      'categories': instance.categories,
      'count': instance.count,
    };
