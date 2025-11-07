// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'bahanbaku_cubit.dart';

class BahanbakuState extends Equatable {
  final List<QueryDocumentSnapshot<InputstockModel>> pembelian;
  final List<QueryDocumentSnapshot<IngredientItem>> stockBarang;
  final bool isLoading;
  final StrukFilter filter;
  const BahanbakuState(this.pembelian, this.stockBarang, this.filter,
      {this.isLoading = false});
  static BahanbakuState get initial => BahanbakuState([], [], StrukFilter());

  @override
  List<Object> get props => [pembelian, stockBarang, isLoading, filter];

  BahanbakuState copyWith({
    List<QueryDocumentSnapshot<InputstockModel>>? pembelian,
    List<QueryDocumentSnapshot<IngredientItem>>? stockBarang,
    bool? isLoading,
    StrukFilter? filter,
  }) {
    return BahanbakuState(
      pembelian ?? this.pembelian,
      stockBarang ?? this.stockBarang,
      filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
