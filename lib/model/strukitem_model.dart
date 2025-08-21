// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:order_makan/model/ingredient_model.dart';
import 'package:order_makan/model/menuitems_model.dart';
import 'package:order_makan/model/submenuitem_model.dart';

// part 'strukitem_model.g.dart';

@JsonSerializable()
class StrukItem extends Equatable {
  final String title;
  final String? catatan;
  final int price;
  final int cardId;
  final String? id;
  final List<IngredientItem> ingredientItems;
  final List<SubMenuItem> submenues;
  final int count;
  const StrukItem({
    this.ingredientItems = const [],
    this.submenues = const [],
    this.cardId = 0,
    int? count,
    this.id,
    this.catatan,
    int? price,
    required this.title,
  })  : count = count ?? 1,
        price = price ?? 0;
  StrukItem copywith(
          {String? title,
          List<IngredientItem>? ingredientItems,
          List<SubMenuItem>? submenues,
          int? cardId,
          int? price,
          String? id,
          int? count,
          Function? catatan}) =>
      StrukItem(
          catatan: catatan != null ? catatan() : this.catatan,
          ingredientItems: ingredientItems ?? this.ingredientItems,
          title: title ?? this.title,
          submenues: submenues ?? this.submenues,
          count: count ?? this.count,
          price: price ?? this.price,
          cardId: cardId ?? this.cardId,
          id: id ?? this.id);
  factory StrukItem.fromMenuItems(MenuItems menu) => StrukItem(
      title: menu.title,
      count: menu.count,
      submenues: [],
      id: menu.id,
      price: menu.price,
      ingredientItems: menu.ingredientItems);
  // factory StrukItem.fromJson(Map<String, dynamic> json) =>
  //     _$StrukItemFromJson(json);

  // Map<String, dynamic> toJson() => _$StrukItemToJson(this);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'catatan': catatan,
      'price': price,
      'id': id,
      'ingredientItems': ingredientItems.map((x) => x.toMap()).toList(),
      'submenues': submenues.map((x) => x.toMap()).toList(),
      'count': count,
    };
  }

  factory StrukItem.fromMap(Map<String, dynamic> map) {
    return StrukItem(
      title: map['title'] as String,
      catatan: map['catatan'] != null ? map['catatan'] as String : null,
      price: map['price'] as int,
      id: map['id'] != null ? map['id'] as String : null,
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
      count: map['count'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory StrukItem.fromJson(String source) =>
      StrukItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props {
    return [
      title,
      catatan,
      price,
      id,
      ingredientItems,
      submenues,
      count,
    ];
  }
}
