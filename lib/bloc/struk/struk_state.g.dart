// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'struk_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StrukState _$StrukStateFromJson(Map<String, dynamic> json) => StrukState(
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

Map<String, dynamic> _$StrukStateToJson(StrukState instance) =>
    <String, dynamic>{
      'karyawanId': instance.karyawanId,
      'strukId': instance.strukId,
      'ordertime': instance.ordertime.toIso8601String(),
      'orderItems': instance.orderItems
          .map(
            (e) => e.toJson(),
          )
          .toList(),
      'error': instance.error,
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
