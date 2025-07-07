import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:order_makan/model/strukitem_model.dart';
// import 'package:order_makan/repo/user_model.dart' show User;

part 'struk_state.g.dart';

enum TipePembayaran { tunai, qris }

@JsonSerializable(explicitToJson: true)
class UseStrukState extends Equatable {
  final String karyawanId;
  final int nomorMeja;
  final TipePembayaran tipePembayaran;
  final String? strukId;
  final DateTime ordertime;
  final List<StrukItem> orderItems;
  final int? total;
  final int? waktuTunggu;
  final StrukError error;
  final String? deleteReason;

  UseStrukState({
    this.nomorMeja = 0,
    this.tipePembayaran = TipePembayaran.tunai,
    required this.karyawanId,
    this.strukId,
    required this.ordertime,
    required this.orderItems,
    this.waktuTunggu,
    this.total,
    this.deleteReason,
    StrukError? error,
    // required this.karyawanId,
  }) : error = error ?? StrukError.empty();
  // karyawanId = karyawanId ?? '',

  static UseStrukState initial({required String karyawanId}) => UseStrukState(
        karyawanId: karyawanId,
        ordertime: DateTime.now(),
        orderItems: [],
        // karyawanId: karyawanId,
      );
  UseStrukState copywith(
          {List<StrukItem>? orderItems,
          bool? isFinished,
          String? karyawanId,
          String? deleteReason,
          int? total,
          int? waktuTunggu,
          int? nomorMeja,
          TipePembayaran? tipePembayaran,
          String? strukId,
          StrukError? error,
          DateTime? ordertime}) =>
      UseStrukState(
        total: total ?? this.total,
        waktuTunggu: waktuTunggu ?? this.waktuTunggu,
        deleteReason: deleteReason ?? this.deleteReason,
        tipePembayaran: tipePembayaran ?? this.tipePembayaran,
        nomorMeja: nomorMeja ?? this.nomorMeja,
        karyawanId: karyawanId ?? this.karyawanId,
        strukId: strukId ?? this.strukId,
        error: error ?? this.error,
        ordertime: ordertime ?? this.ordertime,
        orderItems: orderItems ?? this.orderItems,
      );

  factory UseStrukState.fromJson(Map<String, dynamic> json) =>
      _$UseStrukStateFromJson(json);

  Map<String, dynamic> toJson() => _$UseStrukStateToJson(this);

  factory UseStrukState.fromFirestore(
          DocumentSnapshot<Map<String, Object?>> data) =>
      _$StrukStateFromFirestore(data);

  Map<String, Object?> toFirestore() => _$StrukStateToFirestore(this);

  @override
  List<Object?> get props => [
        karyawanId,
        nomorMeja,
        tipePembayaran,
        strukId,
        ordertime,
        orderItems,
        error,
      ];
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

UseStrukState _$StrukStateFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc) {
  Map<String, dynamic>? data = doc.data();
  if (data == null) throw Exception();
  return UseStrukState(
    deleteReason: data['reason'],
    waktuTunggu: data['waktu_tunggu'],
    total: data['total_harga'],
    karyawanId: data['karyawanId'] as String,
    strukId: doc.id,
    nomorMeja: (data['nomorMeja'] as num?)?.toInt() ?? 0,
    tipePembayaran:
        $enumDecodeNullable(_$TipePembayaranEnumMap, data['tipePembayaran']) ??
            TipePembayaran.tunai,
    ordertime: (data['ordertime'] as Timestamp).toDate(),
    orderItems: (data['orderItems'] as List<dynamic>)
        .map((e) => StrukItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    error: data['error'] == null
        ? null
        : StrukError.fromJson(data['error'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StrukStateToFirestore(UseStrukState instance) =>
    <String, dynamic>{
      'custom_order': null,
      'karyawanId': instance.karyawanId,
      'nomorMeja': instance.nomorMeja,
      'tipePembayaran': instance.tipePembayaran.name,
      // 'strukId': instance.strukId,
      'ordertime': Timestamp.fromDate(instance.ordertime),
      'orderItems': instance.orderItems
          .map(
            (e) => e.toJson(),
          )
          .toList(),
      // 'error': instance.error,
    };
