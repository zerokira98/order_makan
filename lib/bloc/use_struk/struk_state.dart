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
  final int nomorAntrian;
  final TipePembayaran tipePembayaran;
  final int? dibayar;

  final String? strukId;
  final DateTime ordertime;
  final List<StrukItem> orderItems;
  final int? total;
  final int? waktuTunggu;
  final StrukError error;
  final String? deleteReason;

  UseStrukState({
    this.dibayar,
    this.nomorAntrian = 0,
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
          int? dibayar,
          bool? isFinished,
          String? karyawanId,
          String? deleteReason,
          int? total,
          int? waktuTunggu,
          int? nomorAntrian,
          TipePembayaran? tipePembayaran,
          String? strukId,
          StrukError? error,
          DateTime? ordertime}) =>
      UseStrukState(
        total: total ?? this.total,
        dibayar: dibayar ?? this.dibayar,
        waktuTunggu: waktuTunggu ?? this.waktuTunggu,
        deleteReason: deleteReason ?? this.deleteReason,
        tipePembayaran: tipePembayaran ?? this.tipePembayaran,
        nomorAntrian: nomorAntrian ?? this.nomorAntrian,
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
        nomorAntrian,
        tipePembayaran,
        strukId,
        dibayar,
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
class StrukError extends Equatable {
  final int code;
  final String msg;
  const StrukError(this.code, this.msg);
  static StrukError empty() => StrukError(0, '');
  static StrukError success() => StrukError(100, 'send to db success');

  static StrukError existed(StrukItem items) => StrukError(1, items.title);
  factory StrukError.fromJson(Map<String, dynamic> json) =>
      _$StrukErrorFromJson(json);

  Map<String, dynamic> toJson() => _$StrukErrorToJson(this);

  @override
  List<Object?> get props => [code, msg];
}

UseStrukState _$StrukStateFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc) {
  Map<String, dynamic>? data = doc.data();
  if (data == null) throw Exception();
  return UseStrukState(
    deleteReason: data['reason'],
    dibayar: data['dibayar'],
    waktuTunggu: data['waktu_tunggu'],
    total: data['total_harga'],
    karyawanId: data['karyawanId'] as String,
    strukId: doc.id,
    nomorAntrian: (data['nomorAntrian'] as num?)?.toInt() ?? 0,
    tipePembayaran:
        $enumDecodeNullable(_$TipePembayaranEnumMap, data['tipePembayaran']) ??
            TipePembayaran.tunai,
    ordertime: (data['ordertime'] as Timestamp).toDate(),
    orderItems: (data['orderItems'] as List<dynamic>)
        .map((e) => StrukItem.fromMap(e as Map<String, dynamic>))
        .toList(),
    error: data['error'] == null
        ? null
        : StrukError.fromJson(data['error'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StrukStateToFirestore(UseStrukState instance) =>
    <String, dynamic>{
      'dibayar': instance.dibayar,
      'custom_order': null,
      'karyawanId': instance.karyawanId,
      'nomorAntrian': instance.nomorAntrian,
      'tipePembayaran': instance.tipePembayaran.name,
      // 'strukId': instance.strukId,
      'ordertime': Timestamp.fromDate(instance.ordertime),
      'orderItems': instance.orderItems
          .map(
            (e) => e.toMap(),
          )
          .toList(),
      // 'error': instance.error,
    };
