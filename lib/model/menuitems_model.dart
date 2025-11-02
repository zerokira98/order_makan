// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:order_makan/model/ingredient_model.dart';
import 'package:order_makan/model/submenuitem_model.dart';

@JsonSerializable(explicitToJson: true)
class MenuItems {
  final String title;
  final String imgDir;
  final int price;
  final List<IngredientItem> ingredientItems;
  final List<SubMenuItem> submenues;
  final String? id;
  final bool? customOrder;
  final String? description;
  final List<String> categories;
  int count;
  MenuItems(
      {int? count,
      this.ingredientItems = const [],
      this.submenues = const [],
      this.customOrder,
      this.id,
      this.description = '',
      int? price,
      required this.title,
      required this.imgDir,
      List<String>? categories})
      : count = count ?? 1,
        categories = categories ?? [],
        price = price ?? 0;
  MenuItems countchange(int newcount) => MenuItems(
      customOrder: customOrder,
      ingredientItems: ingredientItems,
      submenues: submenues,
      title: title,
      imgDir: imgDir,
      description: description,
      count: newcount,
      price: price,
      categories: categories,
      id: id);

  MenuItems copywith({
    String? title,
    String? imgDir,
    String? description,
    List<IngredientItem>? ingredientItems,
    List<SubMenuItem>? submenues,
    bool? customOrder,
    String? id,
    int? price,
    List<String>? categories,
    int? count,
  }) =>
      MenuItems(
        submenues: submenues ?? this.submenues,
        ingredientItems: ingredientItems ?? this.ingredientItems,
        customOrder: customOrder ?? this.customOrder,
        title: title ?? this.title,
        imgDir: imgDir ?? this.imgDir,
        description: description ?? this.description,
        id: id ?? this.id,
        price: price ?? this.price,
        categories: categories ?? this.categories,
        count: count ?? this.count,
      );

  factory MenuItems.fromFirestore(DocumentSnapshot<Map> data) =>
      _$MenuItemsFromFirestore(data);

  Map<String, dynamic> toFirestore() => _$MenuItemsToFirestore(this);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'imgDir': imgDir,
      'price': price,
      'ingredientItems': ingredientItems.map((x) => x.toMap()).toList(),
      'submenues': submenues.map((x) => x.toMap()).toList(),
      'id': id,
      'customOrder': customOrder,
      'description': description,
      'categories': categories,
      'count': count,
    };
  }

  factory MenuItems.fromMap(Map<String, dynamic> map) {
    return MenuItems(
      title: map['title'] as String,
      imgDir: map['imgDir'] as String,
      price: map['price'] as int,
      ingredientItems: List<IngredientItem>.from(
        (map['ingredientItems'] as List).map<IngredientItem>(
          (x) => IngredientItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      submenues: List<SubMenuItem>.from(
        (map['submenues'] as List).map<SubMenuItem>(
          (x) => SubMenuItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      id: map['id'] != null ? map['id'] as String : null,
      customOrder:
          map['customOrder'] != null ? map['customOrder'] as bool : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      categories: List<String>.from((map['categories'] as List<String>)),
      count: map['count'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuItems.fromJson(String source) =>
      MenuItems.fromMap(json.decode(source) as Map<String, dynamic>);
}

MenuItems _$MenuItemsFromFirestore(DocumentSnapshot<Map> data) {
  var menudata = data.data();
  return MenuItems(
    id: data.id,
    description: menudata?['description'],
    customOrder: menudata?['custom_order'],
    ingredientItems: (menudata?['ingredientItems'] as List<dynamic>?)
            ?.map((e) => IngredientItem.fromMap(e))
            .toList() ??
        const [],
    submenues: (menudata?['submenues'] as List<dynamic>?)
            ?.map((e) => SubMenuItem.fromMap(e))
            .toList() ??
        const [],
    price: menudata?['price'],
    title: menudata?['title'],
    imgDir: menudata?['imgDir'],
    categories: (menudata?['categories'] as List<dynamic>)
        .map<String>(
          (e) => e.toString(),
        )
        .toList(),
  );
}

Map<String, dynamic> _$MenuItemsToFirestore(MenuItems instance) =>
    <String, dynamic>{
      'title': instance.title,
      'submenues': instance.submenues
          .map(
            (e) => e.toMap(),
          )
          .toList(),
      'ingredientItems': instance.ingredientItems
          .map(
            (e) => e.toMap(),
          )
          .toList(),
      'custom_order': instance.customOrder,
      'description': instance.description,
      'imgDir': instance.imgDir,
      'price': instance.price,
      'categories': instance.categories,
    };
