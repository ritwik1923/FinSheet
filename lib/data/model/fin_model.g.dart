// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FinModel _$$_FinModelFromJson(Map<String, dynamic> json) => _$_FinModel(
      id: json['id'] as int,
      tag: json['tag'] as String,
      price: (json['price'] as num).toDouble(),
      comments: json['comments'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$_FinModelToJson(_$_FinModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
      'price': instance.price,
      'comments': instance.comments,
      'date': instance.date.toIso8601String(),
    };
