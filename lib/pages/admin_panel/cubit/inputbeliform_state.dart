// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'inputbeliform_cubit.dart';

class InputbeliformState extends Equatable {
  final IngredientItem ingredientItem;
  final String nama;
  final String tempatbeli;
  final int count;
  final int harga;
  const InputbeliformState({
    required this.ingredientItem,
    required this.nama,
    required this.tempatbeli,
    required this.count,
    required this.harga,
  });
  static InputbeliformState initial() => InputbeliformState(
      ingredientItem: IngredientItem(title: '', count: 0),
      nama: '',
      tempatbeli: '',
      count: 0,
      harga: 0);
  @override
  List<Object> get props {
    return [
      ingredientItem,
      nama,
      tempatbeli,
      count,
      harga,
    ];
  }

  InputbeliformState copyWith({
    IngredientItem? ingredientItem,
    String? nama,
    String? tempatbeli,
    int? count,
    int? harga,
  }) {
    return InputbeliformState(
      ingredientItem: ingredientItem ?? this.ingredientItem,
      nama: nama ?? this.nama,
      tempatbeli: tempatbeli ?? this.tempatbeli,
      count: count ?? this.count,
      harga: harga ?? this.harga,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ingredientItem': ingredientItem.toMap(),
      'nama': nama,
      'tempatbeli': tempatbeli,
      'count': count,
      'harga': harga,
    };
  }

  factory InputbeliformState.fromMap(Map<String, dynamic> map) {
    return InputbeliformState(
      ingredientItem:
          IngredientItem.fromMap(map['ingredientItem'] as Map<String, dynamic>),
      nama: map['nama'] as String,
      tempatbeli: map['tempatbeli'] as String,
      count: map['count'] as int,
      harga: map['harga'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory InputbeliformState.fromJson(String source) =>
      InputbeliformState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
