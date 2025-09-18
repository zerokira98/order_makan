// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'inputbeliform_cubit.dart';

class InputbeliformState extends Equatable {
  final IngredientItem ingredientItem;
  final DateTime tanggalbeli;
  final String nama;
  final String tempatbeli;
  final int count;
  final int harga;
  const InputbeliformState({
    required this.ingredientItem,
    required this.tanggalbeli,
    required this.nama,
    required this.tempatbeli,
    required this.count,
    required this.harga,
  });
  static InputbeliformState initial() => InputbeliformState(
      tanggalbeli: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ingredientItem: IngredientItem(title: '', count: 0, satuan: ''),
      nama: '',
      tempatbeli: '',
      count: 0,
      harga: 0);
  @override
  List<Object> get props {
    return [
      ingredientItem,
      tanggalbeli,
      nama,
      tempatbeli,
      count,
      harga,
    ];
  }

  InputbeliformState copyWith({
    IngredientItem? ingredientItem,
    DateTime? tanggalbeli,
    String? nama,
    String? tempatbeli,
    int? count,
    int? harga,
  }) {
    return InputbeliformState(
      ingredientItem: ingredientItem ?? this.ingredientItem,
      tanggalbeli: tanggalbeli ?? this.tanggalbeli,
      nama: nama ?? this.nama,
      tempatbeli: tempatbeli ?? this.tempatbeli,
      count: count ?? this.count,
      harga: harga ?? this.harga,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ingredientItem': ingredientItem.toMap(),
      'tanggalbeli': tanggalbeli.millisecondsSinceEpoch,
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
      tanggalbeli:
          DateTime.fromMillisecondsSinceEpoch(map['tanggalbeli'] as int),
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
