// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detect_food_waste_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DetectFoodWasteModel _$DetectFoodWasteModelFromJson(Map<String, dynamic> json) {
  return _DetectFoodWasteModel.fromJson(json);
}

/// @nodoc
mixin _$DetectFoodWasteModel {
  String get productName => throw _privateConstructorUsedError;
  double get wastePercentage => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DetectFoodWasteModelCopyWith<DetectFoodWasteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetectFoodWasteModelCopyWith<$Res> {
  factory $DetectFoodWasteModelCopyWith(DetectFoodWasteModel value,
          $Res Function(DetectFoodWasteModel) then) =
      _$DetectFoodWasteModelCopyWithImpl<$Res, DetectFoodWasteModel>;
  @useResult
  $Res call({String productName, double wastePercentage, DateTime timestamp});
}

/// @nodoc
class _$DetectFoodWasteModelCopyWithImpl<$Res,
        $Val extends DetectFoodWasteModel>
    implements $DetectFoodWasteModelCopyWith<$Res> {
  _$DetectFoodWasteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = null,
    Object? wastePercentage = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      wastePercentage: null == wastePercentage
          ? _value.wastePercentage
          : wastePercentage // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DetectFoodWasteModelImplCopyWith<$Res>
    implements $DetectFoodWasteModelCopyWith<$Res> {
  factory _$$DetectFoodWasteModelImplCopyWith(_$DetectFoodWasteModelImpl value,
          $Res Function(_$DetectFoodWasteModelImpl) then) =
      __$$DetectFoodWasteModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String productName, double wastePercentage, DateTime timestamp});
}

/// @nodoc
class __$$DetectFoodWasteModelImplCopyWithImpl<$Res>
    extends _$DetectFoodWasteModelCopyWithImpl<$Res, _$DetectFoodWasteModelImpl>
    implements _$$DetectFoodWasteModelImplCopyWith<$Res> {
  __$$DetectFoodWasteModelImplCopyWithImpl(_$DetectFoodWasteModelImpl _value,
      $Res Function(_$DetectFoodWasteModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = null,
    Object? wastePercentage = null,
    Object? timestamp = null,
  }) {
    return _then(_$DetectFoodWasteModelImpl(
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      wastePercentage: null == wastePercentage
          ? _value.wastePercentage
          : wastePercentage // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DetectFoodWasteModelImpl extends _DetectFoodWasteModel {
  const _$DetectFoodWasteModelImpl(
      {required this.productName,
      required this.wastePercentage,
      required this.timestamp})
      : super._();

  factory _$DetectFoodWasteModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DetectFoodWasteModelImplFromJson(json);

  @override
  final String productName;
  @override
  final double wastePercentage;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'DetectFoodWasteModel(productName: $productName, wastePercentage: $wastePercentage, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetectFoodWasteModelImpl &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.wastePercentage, wastePercentage) ||
                other.wastePercentage == wastePercentage) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, productName, wastePercentage, timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DetectFoodWasteModelImplCopyWith<_$DetectFoodWasteModelImpl>
      get copyWith =>
          __$$DetectFoodWasteModelImplCopyWithImpl<_$DetectFoodWasteModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DetectFoodWasteModelImplToJson(
      this,
    );
  }
}

abstract class _DetectFoodWasteModel extends DetectFoodWasteModel {
  const factory _DetectFoodWasteModel(
      {required final String productName,
      required final double wastePercentage,
      required final DateTime timestamp}) = _$DetectFoodWasteModelImpl;
  const _DetectFoodWasteModel._() : super._();

  factory _DetectFoodWasteModel.fromJson(Map<String, dynamic> json) =
      _$DetectFoodWasteModelImpl.fromJson;

  @override
  String get productName;
  @override
  double get wastePercentage;
  @override
  DateTime get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$DetectFoodWasteModelImplCopyWith<_$DetectFoodWasteModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
