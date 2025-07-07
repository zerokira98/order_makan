// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart' show JsonSerializable;

part 'ingredient_model.g.dart';

@JsonSerializable()
class IngredientItem extends Equatable {
  final String title;
  final String? id;
  final int count;
  const IngredientItem({
    this.id,
    required this.title,
    required this.count,
  });

  @override
  List<Object> get props => [title, id ?? '', count];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'id': id,
      'count': count,
    };
  }

  factory IngredientItem.fromMap(Map<String, dynamic> map) {
    return IngredientItem(
      title: map['title'] as String,
      id: map['id'] != null ? map['id'] as String : null,
      count: map['count'] as int,
    );
  }
  // factory IngredientItem.fromFirestore(DocumentSnapshot<Map> data) {
  //   var thedata = data.data();
  //   return IngredientItem(
  //     title: thedata?['title'] as String,
  //     id: thedata['id'] != null ? thedata['id'] as String : null,
  //     count: thedata?['count'] as int,
  //   );
  // }

  String toJson() => json.encode(toMap());

  factory IngredientItem.fromJson(String source) =>
      IngredientItem.fromMap(json.decode(source) as Map<String, dynamic>);

  static IngredientItem fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception();
    return IngredientItem(
        title: data['title'], count: data['count'], id: snapshot.id);
  }

  IngredientItem copyWith({
    String? title,
    String? Function()? id,
    int? count,
  }) {
    return IngredientItem(
      title: title ?? this.title,
      id: id != null ? id() : this.id,
      count: count ?? this.count,
    );
  }
}
