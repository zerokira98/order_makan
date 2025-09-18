// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:order_makan/model/ingredient_model.dart';

class InputstockModel extends Equatable {
  final String title;
  final String tempatbeli;
  final Timestamp tanggalbeli;

  ///Count as in gram/litre
  final int count;
  final int price;
  final String units;
  final IngredientItem asIngredient;
  const InputstockModel({
    required this.title,
    required this.tempatbeli,
    required this.tanggalbeli,
    required this.count,
    required this.price,
    required this.units,
    required this.asIngredient,
  });

  InputstockModel copyWith({
    String? title,
    String? tempatbeli,
    Timestamp? tanggalbeli,
    int? count,
    int? price,
    String? units,
    IngredientItem? asIngredient,
  }) {
    return InputstockModel(
      title: title ?? this.title,
      tempatbeli: tempatbeli ?? this.tempatbeli,
      tanggalbeli: tanggalbeli ?? this.tanggalbeli,
      count: count ?? this.count,
      price: price ?? this.price,
      units: units ?? this.units,
      asIngredient: asIngredient ?? this.asIngredient,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'tempatbeli': tempatbeli,
      'tanggalbeli': tanggalbeli,
      'count': count,
      'price': price,
      'units': units,
      'asIngredient': asIngredient.toMap(),
    };
  }

  factory InputstockModel.fromMap(Map<String, dynamic> map) {
    return InputstockModel(
      title: map['title'] as String,
      tempatbeli: map['tempatbeli'] as String,
      tanggalbeli: map['tanggalbeli'] as Timestamp,
      count: map['count'] as int,
      price: map['price'] as int,
      units: map['units'] as String,
      asIngredient:
          IngredientItem.fromMap(map['asIngredient'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory InputstockModel.fromJson(String source) =>
      InputstockModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props {
    return [
      title,
      tempatbeli,
      tanggalbeli,
      count,
      price,
      units,
      asIngredient,
    ];
  }

  @override
  bool get stringify => true;
}
