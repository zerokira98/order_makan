// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientItem _$IngredientItemFromJson(Map<String, dynamic> json) =>
    IngredientItem(
      id: json['id'] as String?,
      title: json['title'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$IngredientItemToJson(IngredientItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'id': instance.id,
      'count': instance.count,
    };
