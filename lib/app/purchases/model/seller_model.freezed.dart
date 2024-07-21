// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seller_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SellerModel _$SellerModelFromJson(Map<String, dynamic> json) {
  return _SellerModel.fromJson(json);
}

/// @nodoc
mixin _$SellerModel {
  String get id => throw _privateConstructorUsedError;
  String get sellerName => throw _privateConstructorUsedError;
  String get vatNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SellerModelCopyWith<SellerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SellerModelCopyWith<$Res> {
  factory $SellerModelCopyWith(
          SellerModel value, $Res Function(SellerModel) then) =
      _$SellerModelCopyWithImpl<$Res, SellerModel>;
  @useResult
  $Res call({String id, String sellerName, String vatNumber});
}

/// @nodoc
class _$SellerModelCopyWithImpl<$Res, $Val extends SellerModel>
    implements $SellerModelCopyWith<$Res> {
  _$SellerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellerName = null,
    Object? vatNumber = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sellerName: null == sellerName
          ? _value.sellerName
          : sellerName // ignore: cast_nullable_to_non_nullable
              as String,
      vatNumber: null == vatNumber
          ? _value.vatNumber
          : vatNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SellerModelImplCopyWith<$Res>
    implements $SellerModelCopyWith<$Res> {
  factory _$$SellerModelImplCopyWith(
          _$SellerModelImpl value, $Res Function(_$SellerModelImpl) then) =
      __$$SellerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String sellerName, String vatNumber});
}

/// @nodoc
class __$$SellerModelImplCopyWithImpl<$Res>
    extends _$SellerModelCopyWithImpl<$Res, _$SellerModelImpl>
    implements _$$SellerModelImplCopyWith<$Res> {
  __$$SellerModelImplCopyWithImpl(
      _$SellerModelImpl _value, $Res Function(_$SellerModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellerName = null,
    Object? vatNumber = null,
  }) {
    return _then(_$SellerModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sellerName: null == sellerName
          ? _value.sellerName
          : sellerName // ignore: cast_nullable_to_non_nullable
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
class _$SellerModelImpl extends _SellerModel {
  const _$SellerModelImpl(
      {required this.id, required this.sellerName, required this.vatNumber})
      : super._();

  factory _$SellerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SellerModelImplFromJson(json);

  @override
  final String id;
  @override
  final String sellerName;
  @override
  final String vatNumber;

  @override
  String toString() {
    return 'SellerModel(id: $id, sellerName: $sellerName, vatNumber: $vatNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SellerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sellerName, sellerName) ||
                other.sellerName == sellerName) &&
            (identical(other.vatNumber, vatNumber) ||
                other.vatNumber == vatNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, sellerName, vatNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SellerModelImplCopyWith<_$SellerModelImpl> get copyWith =>
      __$$SellerModelImplCopyWithImpl<_$SellerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SellerModelImplToJson(
      this,
    );
  }
}

abstract class _SellerModel extends SellerModel {
  const factory _SellerModel(
      {required final String id,
      required final String sellerName,
      required final String vatNumber}) = _$SellerModelImpl;
  const _SellerModel._() : super._();

  factory _SellerModel.fromJson(Map<String, dynamic> json) =
      _$SellerModelImpl.fromJson;

  @override
  String get id;
  @override
  String get sellerName;
  @override
  String get vatNumber;
  @override
  @JsonKey(ignore: true)
  _$$SellerModelImplCopyWith<_$SellerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
