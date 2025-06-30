import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'menuitems_model.g.dart';

@JsonSerializable()
class MenuItems {
  final String title;
  final String imgDir;
  final int price;
  final String? id;
  final String? description;
  final List<String> categories;
  int count;
  MenuItems(
      {int? count,
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
    String? id,
    int? price,
    List<String>? categories,
    int? count,
  }) =>
      MenuItems(
        title: title ?? this.title,
        imgDir: imgDir ?? this.imgDir,
        description: description ?? this.description,
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

  // @override
  // String toString() {
  //   return title;
  // }

  Map<String, dynamic> toFirestore() => _$MenuItemsToFirestore(this);
}

MenuItems _$MenuItemsFromFirestore(DocumentSnapshot<Map> data) {
  var menudata = data.data();
  return MenuItems(
    id: data.id,
    description: menudata?['description'],
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
      'description': instance.description,
      'imgDir': instance.imgDir,
      'price': instance.price,
      'categories': instance.categories,
    };
