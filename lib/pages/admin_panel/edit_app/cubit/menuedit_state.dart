// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'menuedit_cubit.dart';

class MenueditState extends Equatable {
  final String nama;
  final int harga;
  final List<String> category;
  final String deskripsi;
  final String imgdir;
  final List<IngredientItem> ingredients;
  final List<SubMenuItem> submenu;
  const MenueditState({
    required this.nama,
    required this.harga,
    required this.category,
    required this.deskripsi,
    required this.imgdir,
    required this.ingredients,
    required this.submenu,
  });
  static MenueditState initial() => MenueditState(
      ingredients: [],
      nama: '',
      harga: 0,
      deskripsi: '',
      submenu: [],
      imgdir: '',
      category: []);

  MenueditState copyWith({
    String? nama,
    int? harga,
    List<String>? category,
    String? deskripsi,
    String? imgdir,
    List<IngredientItem>? ingredients,
    List<SubMenuItem>? submenu,
  }) {
    return MenueditState(
      nama: nama ?? this.nama,
      harga: harga ?? this.harga,
      category: category ?? this.category,
      deskripsi: deskripsi ?? this.deskripsi,
      imgdir: imgdir ?? this.imgdir,
      ingredients: ingredients ?? this.ingredients,
      submenu: submenu ?? this.submenu,
    );
  }

  @override
  List<Object> get props {
    return [
      nama,
      harga,
      category,
      deskripsi,
      submenu,
      imgdir,
      ingredients,
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nama': nama,
      'harga': harga,
      'category': category,
      'deskripsi': deskripsi,
      'imgdir': imgdir,
      'ingredients': ingredients.map((x) => x.toMap()).toList(),
      'submenu': submenu.map((x) => x.toMap()).toList(),
    };
  }

  @override
  bool get stringify => true;

  factory MenueditState.fromMap(Map<String, dynamic> map) {
    return MenueditState(
      nama: map['nama'] as String,
      harga: map['harga'] as int,
      category: List<String>.from((map['category'] as List<String>)),
      deskripsi: map['deskripsi'] as String,
      imgdir: map['imgdir'] as String,
      ingredients: List<IngredientItem>.from(
        (map['ingredients'] as List<int>).map<IngredientItem>(
          (x) => IngredientItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      submenu: List<SubMenuItem>.from(
        (map['submenu'] as List<int>).map<SubMenuItem>(
          (x) => SubMenuItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MenueditState.fromJson(String source) =>
      MenueditState.fromMap(json.decode(source) as Map<String, dynamic>);
}
