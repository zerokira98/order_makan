// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'struk_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StrukState _$StrukStateFromJson(Map<String, dynamic> json) => StrukState(
      karyawanId: json['karyawanId'] as String,
      strukId: json['strukId'] as int,
      ordertime: DateTime.parse(json['ordertime'] as String),
      orderItems: (json['orderItems'] as List<dynamic>)
          .map((e) => StrukItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] == null
          ? null
          : StrukError.fromJson(json['error'] as Map<String, dynamic>),
      isFinished: json['isFinished'] as bool?,
    );

Map<String, dynamic> _$StrukStateToJson(StrukState instance) =>
    <String, dynamic>{
      'karyawanId': instance.karyawanId,
      'strukId': instance.strukId,
      'ordertime': instance.ordertime.toIso8601String(),
      'orderItems': instance.orderItems,
      'error': instance.error,
      'isFinished': instance.isFinished,
    };

StrukError _$StrukErrorFromJson(Map<String, dynamic> json) => StrukError(
      json['code'] as int,
      json['msg'] as String,
    );

Map<String, dynamic> _$StrukErrorToJson(StrukError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
    };
