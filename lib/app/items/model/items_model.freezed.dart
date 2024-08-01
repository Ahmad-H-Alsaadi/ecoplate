// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'items_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ItemsModel _$ItemsModelFromJson(Map<String, dynamic> json) {
  return _ItemsModel.fromJson(json);
}

/// @nodoc
mixin _$ItemsModel {
  String? get id => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  String get measurement => throw _privateConstructorUsedError;
  String get vatNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ItemsModelCopyWith<ItemsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemsModelCopyWith<$Res> {
  factory $ItemsModelCopyWith(
          ItemsModel value, $Res Function(ItemsModel) then) =
      _$ItemsModelCopyWithImpl<$Res, ItemsModel>;
  @useResult
  $Res call(
      {String? id, String itemName, String measurement, String vatNumber});
}

/// @nodoc
class _$ItemsModelCopyWithImpl<$Res, $Val extends ItemsModel>
    implements $ItemsModelCopyWith<$Res> {
  _$ItemsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? itemName = null,
    Object? measurement = null,
    Object? vatNumber = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      measurement: null == measurement
          ? _value.measurement
          : measurement // ignore: cast_nullable_to_non_nullable
              as String,
      vatNumber: null == vatNumber
          ? _value.vatNumber
          : vatNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItemsModelImplCopyWith<$Res>
    implements $ItemsModelCopyWith<$Res> {
  factory _$$ItemsModelImplCopyWith(
          _$ItemsModelImpl value, $Res Function(_$ItemsModelImpl) then) =
      __$$ItemsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id, String itemName, String measurement, String vatNumber});
}

/// @nodoc
class __$$ItemsModelImplCopyWithImpl<$Res>
    extends _$ItemsModelCopyWithImpl<$Res, _$ItemsModelImpl>
    implements _$$ItemsModelImplCopyWith<$Res> {
  __$$ItemsModelImplCopyWithImpl(
      _$ItemsModelImpl _value, $Res Function(_$ItemsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? itemName = null,
    Object? measurement = null,
    Object? vatNumber = null,
  }) {
    return _then(_$ItemsModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      measurement: null == measurement
          ? _value.measurement
          : measurement // ignore: cast_nullable_to_non_nullable
              as String,
      vatNumber: null == vatNumber
          ? _value.vatNumber
          : vatNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ItemsModelImpl extends _ItemsModel {
  const _$ItemsModelImpl(
      {this.id,
      required this.itemName,
      required this.measurement,
      this.vatNumber = ''})
      : super._();

  factory _$ItemsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemsModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String itemName;
  @override
  final String measurement;
  @override
  @JsonKey()
  final String vatNumber;

  @override
  String toString() {
    return 'ItemsModel(id: $id, itemName: $itemName, measurement: $measurement, vatNumber: $vatNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemsModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.measurement, measurement) ||
                other.measurement == measurement) &&
            (identical(other.vatNumber, vatNumber) ||
                other.vatNumber == vatNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, itemName, measurement, vatNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemsModelImplCopyWith<_$ItemsModelImpl> get copyWith =>
      __$$ItemsModelImplCopyWithImpl<_$ItemsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemsModelImplToJson(
      this,
    );
  }
}

abstract class _ItemsModel extends ItemsModel {
  const factory _ItemsModel(
      {final String? id,
      required final String itemName,
      required final String measurement,
      final String vatNumber}) = _$ItemsModelImpl;
  const _ItemsModel._() : super._();

  factory _ItemsModel.fromJson(Map<String, dynamic> json) =
      _$ItemsModelImpl.fromJson;

  @override
  String? get id;
  @override
  String get itemName;
  @override
  String get measurement;
  @override
  String get vatNumber;
  @override
  @JsonKey(ignore: true)
  _$$ItemsModelImplCopyWith<_$ItemsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
