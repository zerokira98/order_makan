// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:order_makan/model/ingredient_model.dart';

class InputstockModel extends Equatable {
  final String title;
  final int stocks;
  final String units;
  final IngredientItem asIngredient;
  const InputstockModel({
    required this.title,
    required this.stocks,
    required this.units,
    required this.asIngredient,
  });

  InputstockModel copyWith({
    String? title,
    int? stocks,
    String? units,
    IngredientItem? asIngredient,
  }) {
    return InputstockModel(
      title: title ?? this.title,
      stocks: stocks ?? this.stocks,
      units: units ?? this.units,
      asIngredient: asIngredient ?? this.asIngredient,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'stocks': stocks,
      'units': units,
      'asIngredient': asIngredient.toMap(),
    };
  }

  factory InputstockModel.fromMap(Map<String, dynamic> map) {
    return InputstockModel(
      title: map['title'] as String,
      stocks: map['stocks'] as int,
      units: map['units'] as String,
      asIngredient:
          IngredientItem.fromMap(map['asIngredient'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory InputstockModel.fromJson(String source) =>
      InputstockModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props => [title, stocks, units, asIngredient];

  @override
  bool get stringify => true;
}
