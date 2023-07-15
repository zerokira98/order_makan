import 'package:json_annotation/json_annotation.dart';
import 'package:order_makan/model/strukitem_model.dart';

part 'struk_state.g.dart';

@JsonSerializable()
class StrukState {
  final String karyawanId;
  final int strukId;
  final DateTime ordertime;
  final List<StrukItem> orderItems;
  final StrukError error;
  final bool isFinished;

  StrukState({
    required this.karyawanId,
    required this.strukId,
    required this.ordertime,
    required this.orderItems,
    StrukError? error,
    bool? isFinished,
    // required this.karyawanId,
  })  : error = error ?? StrukError.empty(),
        // karyawanId = karyawanId ?? '',
        isFinished = isFinished ?? false;
  static StrukState initial({String? karyawanId}) => StrukState(
        karyawanId: karyawanId ?? '',
        ordertime: DateTime.now(),
        strukId: 0,
        orderItems: [],
        // karyawanId: karyawanId,
      );
  StrukState copywith(
          {List<StrukItem>? orderItems,
          bool? isFinished,
          String? karyawanId,
          int? strukId,
          StrukError? error,
          DateTime? ordertime}) =>
      StrukState(
        karyawanId: karyawanId ?? this.karyawanId,
        strukId: strukId ?? this.strukId,
        error: error ?? this.error,
        ordertime: ordertime ?? this.ordertime,
        orderItems: orderItems ?? this.orderItems,
        isFinished: isFinished ?? this.isFinished,
      );

  factory StrukState.fromJson(Map<String, dynamic> json) =>
      _$StrukStateFromJson(json);

  Map<String, dynamic> toJson() => _$StrukStateToJson(this);
}

class Diskon {
  String nama;
  String deskripsi;
  DateTime start;
  DateTime end;
  int potonganHarga;
  Diskon(this.nama, this.deskripsi, this.start, this.end, this.potonganHarga);
}

@JsonSerializable()
class StrukError {
  int code;
  String msg;
  StrukError(this.code, this.msg);
  static StrukError empty() => StrukError(0, '');
  static StrukError existed(StrukItem items) => StrukError(1, items.title);
  factory StrukError.fromJson(Map<String, dynamic> json) =>
      _$StrukErrorFromJson(json);

  Map<String, dynamic> toJson() => _$StrukErrorToJson(this);
}
