import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:order_makan/model/strukitem_model.dart';

part 'struk_state.g.dart';

@JsonSerializable()
class StrukState {
  final String karyawanId;
  final String? strukId;
  final DateTime ordertime;
  final List<StrukItem> orderItems;
  final StrukError error;

  StrukState({
    required this.karyawanId,
    this.strukId,
    required this.ordertime,
    required this.orderItems,
    StrukError? error,
    // required this.karyawanId,
  }) : error = error ?? StrukError.empty();
  // karyawanId = karyawanId ?? '',

  static StrukState initial({String? karyawanId}) => StrukState(
        karyawanId: karyawanId ?? '',
        ordertime: DateTime.now(),

        orderItems: [],
        // karyawanId: karyawanId,
      );
  StrukState copywith(
          {List<StrukItem>? orderItems,
          bool? isFinished,
          String? karyawanId,
          String? strukId,
          StrukError? error,
          DateTime? ordertime}) =>
      StrukState(
        karyawanId: karyawanId ?? this.karyawanId,
        strukId: strukId ?? this.strukId,
        error: error ?? this.error,
        ordertime: ordertime ?? this.ordertime,
        orderItems: orderItems ?? this.orderItems,
      );

  factory StrukState.fromJson(Map<String, dynamic> json) =>
      _$StrukStateFromJson(json);

  Map<String, dynamic> toJson() => _$StrukStateToJson(this);

  factory StrukState.fromFirestore(
          DocumentSnapshot<Map<String, dynamic>> data) =>
      _$StrukStateFromFirestore(data);

  Map<String, dynamic> toFirestore() => _$StrukStateToFirestore(this);
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

StrukState _$StrukStateFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc) {
  Map<String, dynamic>? data = doc.data();
  if (data == null) throw Exception();
  return StrukState(
    karyawanId: data['karyawanId'] as String,
    strukId: doc.id,
    ordertime: (data['ordertime'] as Timestamp).toDate(),
    orderItems: (data['orderItems'] as List<dynamic>)
        .map((e) => StrukItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    error: data['error'] == null
        ? null
        : StrukError.fromJson(data['error'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StrukStateToFirestore(StrukState instance) =>
    <String, dynamic>{
      'karyawanId': instance.karyawanId,
      // 'strukId': instance.strukId,
      'ordertime': Timestamp.fromDate(instance.ordertime),
      'orderItems': instance.orderItems,
      'error': instance.error,
    };
