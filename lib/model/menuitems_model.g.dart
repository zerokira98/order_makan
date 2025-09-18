// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menuitems_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItems _$MenuItemsFromJson(Map<String, dynamic> json) => MenuItems(
      count: (json['count'] as num?)?.toInt(),
      ingredientItems: (json['ingredientItems'] as List<dynamic>?)
              ?.map((e) => IngredientItem.fromJson(e as String))
              .toList() ??
          const [],
      customOrder: json['customOrder'] as bool?,
      id: json['id'] as String?,
      description: json['description'] as String? ?? '',
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
      'ingredientItems':
          instance.ingredientItems.map((e) => e.toJson()).toList(),
      'id': instance.id,
      'customOrder': instance.customOrder,
      'description': instance.description,
      'categories': instance.categories,
      'count': instance.count,
    };
