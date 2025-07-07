import 'package:json_annotation/json_annotation.dart';
import 'package:order_makan/model/menuitems_model.dart';

part 'strukitem_model.g.dart';

@JsonSerializable()
class StrukItem {
  final String title;
  final String? catatan;
  final int price;
  final String? id;
  int count;
  StrukItem({
    int? count,
    this.id,
    this.catatan,
    int? price,
    required this.title,
  })  : count = count ?? 1,
        price = price ?? 0;
  StrukItem copywith(
          {String? title,
          int? price,
          String? id,
          int? count,
          Function? catatan}) =>
      StrukItem(
          catatan: catatan != null ? catatan() : this.catatan,
          title: title ?? this.title,
          count: count ?? this.count,
          price: price ?? this.price,
          id: id ?? this.id);
  factory StrukItem.fromMenuItems(MenuItems menu) => StrukItem(
      title: menu.title, count: menu.count, id: menu.id, price: menu.price);
  factory StrukItem.fromJson(Map<String, dynamic> json) =>
      _$StrukItemFromJson(json);

  Map<String, dynamic> toJson() => _$StrukItemToJson(this);
}
