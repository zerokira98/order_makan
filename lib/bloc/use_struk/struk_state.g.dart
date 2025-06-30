// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'struk_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UseStrukState _$StrukStateFromJson(Map<String, dynamic> json) => UseStrukState(
      nomorMeja: (json['nomorMeja'] as num?)?.toInt() ?? 0,
      tipePembayaran: $enumDecodeNullable(
              _$TipePembayaranEnumMap, json['tipePembayaran']) ??
          TipePembayaran.tunai,
      karyawanId: json['karyawanId'] as String,
      strukId: json['strukId'] as String?,
      ordertime: DateTime.parse(json['ordertime'] as String),
      orderItems: (json['orderItems'] as List<dynamic>)
          .map((e) => StrukItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] == null
          ? null
          : StrukError.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StrukStateToJson(UseStrukState instance) =>
    <String, dynamic>{
      'karyawanId': instance.karyawanId,
      'nomorMeja': instance.nomorMeja,
      'tipePembayaran': _$TipePembayaranEnumMap[instance.tipePembayaran]!,
      'strukId': instance.strukId,
      'ordertime': instance.ordertime.toIso8601String(),
      'orderItems': instance.orderItems,
      'error': instance.error,
    };

const _$TipePembayaranEnumMap = {
  TipePembayaran.tunai: 'tunai',
  TipePembayaran.qris: 'qris',
};

StrukError _$StrukErrorFromJson(Map<String, dynamic> json) => StrukError(
      (json['code'] as num).toInt(),
      json['msg'] as String,
    );

Map<String, dynamic> _$StrukErrorToJson(StrukError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
    };
