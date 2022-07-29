// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'fin_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FinModel _$FinModelFromJson(Map<String, dynamic> json) {
  return _FinModel.fromJson(json);
}

/// @nodoc
class _$FinModelTearOff {
  const _$FinModelTearOff();

  _FinModel call(
      {required int id,
      required String tag,
      required double price,
      required String comments,
      required DateTime date}) {
    return _FinModel(
      id: id,
      tag: tag,
      price: price,
      comments: comments,
      date: date,
    );
  }

  FinModel fromJson(Map<String, Object?> json) {
    return FinModel.fromJson(json);
  }
}

/// @nodoc
const $FinModel = _$FinModelTearOff();

/// @nodoc
mixin _$FinModel {
  int get id => throw _privateConstructorUsedError;
  String get tag => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get comments => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FinModelCopyWith<FinModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinModelCopyWith<$Res> {
  factory $FinModelCopyWith(FinModel value, $Res Function(FinModel) then) =
      _$FinModelCopyWithImpl<$Res>;
  $Res call({int id, String tag, double price, String comments, DateTime date});
}

/// @nodoc
class _$FinModelCopyWithImpl<$Res> implements $FinModelCopyWith<$Res> {
  _$FinModelCopyWithImpl(this._value, this._then);

  final FinModel _value;
  // ignore: unused_field
  final $Res Function(FinModel) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? tag = freezed,
    Object? price = freezed,
    Object? comments = freezed,
    Object? date = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tag: tag == freezed
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      comments: comments == freezed
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as String,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
abstract class _$FinModelCopyWith<$Res> implements $FinModelCopyWith<$Res> {
  factory _$FinModelCopyWith(_FinModel value, $Res Function(_FinModel) then) =
      __$FinModelCopyWithImpl<$Res>;
  @override
  $Res call({int id, String tag, double price, String comments, DateTime date});
}

/// @nodoc
class __$FinModelCopyWithImpl<$Res> extends _$FinModelCopyWithImpl<$Res>
    implements _$FinModelCopyWith<$Res> {
  __$FinModelCopyWithImpl(_FinModel _value, $Res Function(_FinModel) _then)
      : super(_value, (v) => _then(v as _FinModel));

  @override
  _FinModel get _value => super._value as _FinModel;

  @override
  $Res call({
    Object? id = freezed,
    Object? tag = freezed,
    Object? price = freezed,
    Object? comments = freezed,
    Object? date = freezed,
  }) {
    return _then(_FinModel(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tag: tag == freezed
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      comments: comments == freezed
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as String,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FinModel implements _FinModel {
  _$_FinModel(
      {required this.id,
      required this.tag,
      required this.price,
      required this.comments,
      required this.date});

  factory _$_FinModel.fromJson(Map<String, dynamic> json) =>
      _$$_FinModelFromJson(json);

  @override
  final int id;
  @override
  final String tag;
  @override
  final double price;
  @override
  final String comments;
  @override
  final DateTime date;

  @override
  String toString() {
    return 'FinModel(id: $id, tag: $tag, price: $price, comments: $comments, date: $date)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FinModel &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.tag, tag) &&
            const DeepCollectionEquality().equals(other.price, price) &&
            const DeepCollectionEquality().equals(other.comments, comments) &&
            const DeepCollectionEquality().equals(other.date, date));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(tag),
      const DeepCollectionEquality().hash(price),
      const DeepCollectionEquality().hash(comments),
      const DeepCollectionEquality().hash(date));

  @JsonKey(ignore: true)
  @override
  _$FinModelCopyWith<_FinModel> get copyWith =>
      __$FinModelCopyWithImpl<_FinModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FinModelToJson(this);
  }
}

abstract class _FinModel implements FinModel {
  factory _FinModel(
      {required int id,
      required String tag,
      required double price,
      required String comments,
      required DateTime date}) = _$_FinModel;

  factory _FinModel.fromJson(Map<String, dynamic> json) = _$_FinModel.fromJson;

  @override
  int get id;
  @override
  String get tag;
  @override
  double get price;
  @override
  String get comments;
  @override
  DateTime get date;
  @override
  @JsonKey(ignore: true)
  _$FinModelCopyWith<_FinModel> get copyWith =>
      throw _privateConstructorUsedError;
}
