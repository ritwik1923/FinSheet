// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:freezed_annotation/freezed_annotation.dart';
part 'fin_model.freezed.dart';
part 'fin_model.g.dart';

@freezed
class FinModel with _$FinModel {
  factory FinModel({
    required int id,
    required String tag,
    required double price,
    required String comments,
    required DateTime date,
  }) = _FinModel;
  factory FinModel.fromJson(Map<String, dynamic> json) =>
      _$FinModelFromJson(json);
  Map<String, dynamic> toJson() => {
        'id': id,
        'tag': tag,
        'price': price,
        'comments': comments,
        'date': date,
      };
}
