import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'menuitems_model.g.dart';

@JsonSerializable()
class MenuItems {
  final String title;
  final String imgDir;
  final int price;
  final String? id;
  final List<String> categories;
  int count;
  MenuItems(
      {int? count,
      this.id,
      int? price,
      required this.title,
      required this.imgDir,
      List<String>? categories})
      : count = count ?? 1,
        categories = categories ?? [],
        price = price ?? 0;
  MenuItems countchange(int newcount) => MenuItems(
      title: title,
      imgDir: imgDir,
      count: newcount,
      price: price,
      categories: categories,
      id: id);

  MenuItems copywith({
    String? title,
    String? imgDir,
    String? id,
    int? price,
    List<String>? categories,
    int? count,
  }) =>
      MenuItems(
        title: title ?? this.title,
        imgDir: imgDir ?? this.imgDir,
        id: id ?? this.id,
        price: price ?? this.price,
        categories: categories ?? this.categories,
        count: count ?? this.count,
      );
  factory MenuItems.fromJson(Map<String, dynamic> json) =>
      _$MenuItemsFromJson(json);
  factory MenuItems.fromFirestore(DocumentSnapshot<Map> data) =>
      _$MenuItemsFromFirestore(data);

  Map<String, dynamic> toJson() => _$MenuItemsToJson(this);

  @override
  String toString() {
    return title;
  }

  Map<String, dynamic> toFirestore() => _$MenuItemsToFirestore(this);
}

MenuItems _$MenuItemsFromFirestore(DocumentSnapshot<Map> data) {
  var menudata = data.data();
  return MenuItems(
    id: data.id,
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
      'imgDir': instance.imgDir,
      'price': instance.price,
      'categories': instance.categories,
    };
