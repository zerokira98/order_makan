// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:order_makan/repo/menuitemsrepo.dart';

part 'notif_state.dart';

class NotifCubit extends Cubit<NotifState> {
  MenuItemRepository menurepo;

  late final StreamSubscription ingsubscription;
  NotifCubit(this.menurepo) : super(NotifState.initial) {
    ingsubscription = menurepo.ingredientRef.snapshots().listen(
      (event) {
        initiate();
      },
    );
  }
  @override
  Future<void> close() {
    ingsubscription.cancel();
    return super.close();
  }

  Future<void> initiate() async {
    List<NotifModel> notif = [];

    var ingredients = await menurepo.getIngredients();
    for (var e in ingredients) {
      if ((e.alert ?? 0) > e.count) {
        notif.add(NotifModel(
            title: e.title,
            tag: 'ingredient_limit',
            content: e.count.toString() + e.satuan));
      }
    }
    emit(NotifState(
      notif: notif,
    ));
  }
}

class NotifModel {
  String title;
  String tag;
  String content;
  NotifModel({
    required this.title,
    required this.tag,
    required this.content,
  });

  NotifModel copyWith({
    String? title,
    String? tag,
    String? content,
  }) {
    return NotifModel(
      title: title ?? this.title,
      tag: tag ?? this.tag,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'tag': tag,
      'content': content,
    };
  }

  factory NotifModel.fromMap(Map<String, dynamic> map) {
    return NotifModel(
      title: map['title'] as String,
      tag: map['tag'] as String,
      content: map['content'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotifModel.fromJson(String source) =>
      NotifModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'NotifModel(title: $title, tag: $tag, content: $content)';

  @override
  bool operator ==(covariant NotifModel other) {
    if (identical(this, other)) return true;

    return other.title == title && other.tag == tag && other.content == content;
  }

  @override
  int get hashCode => title.hashCode ^ tag.hashCode ^ content.hashCode;
}
