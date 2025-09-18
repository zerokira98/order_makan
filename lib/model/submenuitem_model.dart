// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:order_makan/model/ingredient_model.dart';

class SubMenuItem extends Equatable {
  String title;
  int? cardId;
  List<IngredientItem> adjustIngredient;
  int adjustHarga;
  SubMenuItem({
    required this.title,
    required this.cardId,
    required this.adjustIngredient,
    required this.adjustHarga,
  });
  static SubMenuItem get empty =>
      SubMenuItem(title: '', cardId: 0, adjustIngredient: [], adjustHarga: 0);
  SubMenuItem copyWith({
    String? title,
    int? cardId,
    List<IngredientItem>? adjustIngredient,
    int? adjustHarga,
  }) {
    return SubMenuItem(
      title: title ?? this.title,
      cardId: cardId ?? this.cardId,
      adjustIngredient: adjustIngredient ?? this.adjustIngredient,
      adjustHarga: adjustHarga ?? this.adjustHarga,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'cardId': cardId,
      'adjustIngredient': adjustIngredient.map((x) => x.toMap()).toList(),
      'adjustHarga': adjustHarga,
    };
  }

  factory SubMenuItem.fromMap(Map<String, dynamic> map) {
    return SubMenuItem(
      title: map['title'] as String,
      cardId: map['cardId'] as int,
      adjustIngredient: List<IngredientItem>.from(
        (map['adjustIngredient'] as List<dynamic>).map<IngredientItem>(
          (x) => IngredientItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      adjustHarga: map['adjustHarga'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubMenuItem.fromJson(String source) =>
      SubMenuItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubMenuItem(title: $title, cardId: $cardId, adjustIngredient: $adjustIngredient, adjustHarga: $adjustHarga)';
  }

  @override
  List<Object?> get props => [title, cardId, adjustIngredient, adjustHarga];
}
