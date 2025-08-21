// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart' show JsonSerializable;

@JsonSerializable()
class IngredientItem extends Equatable {
  final String title;
  final String satuan;
  final String? id;
  final int? incrementindex;
  final int? alert;
  final int count;
  const IngredientItem({
    this.alert,
    required this.title,
    this.incrementindex,
    required this.satuan,
    this.id,
    required this.count,
  });

  @override
  List<Object?> get props => [title, satuan, id, count, incrementindex, alert];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'satuan': satuan,
      'id': id,
      'count': count,
      'alert': alert,
    };
  }

  factory IngredientItem.fromMap(Map<String, dynamic> map) {
    return IngredientItem(
      title: map['title'] as String,
      satuan: map['satuan'] as String? ?? 'mg',
      id: map['id'] != null ? map['id'] as String : null,
      count: map['count'] as int,
      alert: map['count'] as int?,
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
        satuan: data['satuan'] ?? 'mg',
        title: data['title'],
        count: data['count'],
        alert: data['alert'],
        id: snapshot.id);
  }

  IngredientItem copyWith({
    String? title,
    String? satuan,
    Function()? id,
    Function()? alert,
    int? incrementindex,
    int? count,
  }) {
    return IngredientItem(
      alert: alert != null ? alert() : this.alert,
      incrementindex: incrementindex ?? this.incrementindex,
      title: title ?? this.title,
      satuan: satuan ?? this.satuan,
      id: id != null ? id() : this.id,
      count: count ?? this.count,
    );
  }

  @override
  bool get stringify => true;
}
