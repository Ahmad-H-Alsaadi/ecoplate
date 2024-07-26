// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_server_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FoodServerModel _$FoodServerModelFromJson(Map<String, dynamic> json) {
  return _FoodServerModel.fromJson(json);
}

/// @nodoc
mixin _$FoodServerModel {
  List<ProductsModel> get products => throw _privateConstructorUsedError;
  Map<String, int> get selections => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FoodServerModelCopyWith<FoodServerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodServerModelCopyWith<$Res> {
  factory $FoodServerModelCopyWith(
          FoodServerModel value, $Res Function(FoodServerModel) then) =
      _$FoodServerModelCopyWithImpl<$Res, FoodServerModel>;
  @useResult
  $Res call({List<ProductsModel> products, Map<String, int> selections});
}

/// @nodoc
class _$FoodServerModelCopyWithImpl<$Res, $Val extends FoodServerModel>
    implements $FoodServerModelCopyWith<$Res> {
  _$FoodServerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? selections = null,
  }) {
    return _then(_value.copyWith(
      products: null == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as List<ProductsModel>,
      selections: null == selections
          ? _value.selections
          : selections // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodServerModelImplCopyWith<$Res>
    implements $FoodServerModelCopyWith<$Res> {
  factory _$$FoodServerModelImplCopyWith(_$FoodServerModelImpl value,
          $Res Function(_$FoodServerModelImpl) then) =
      __$$FoodServerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ProductsModel> products, Map<String, int> selections});
}

/// @nodoc
class __$$FoodServerModelImplCopyWithImpl<$Res>
    extends _$FoodServerModelCopyWithImpl<$Res, _$FoodServerModelImpl>
    implements _$$FoodServerModelImplCopyWith<$Res> {
  __$$FoodServerModelImplCopyWithImpl(
      _$FoodServerModelImpl _value, $Res Function(_$FoodServerModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? selections = null,
  }) {
    return _then(_$FoodServerModelImpl(
      products: null == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<ProductsModel>,
      selections: null == selections
          ? _value._selections
          : selections // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodServerModelImpl implements _FoodServerModel {
  const _$FoodServerModelImpl(
      {required final List<ProductsModel> products,
      required final Map<String, int> selections})
      : _products = products,
        _selections = selections;

  factory _$FoodServerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodServerModelImplFromJson(json);

  final List<ProductsModel> _products;
  @override
  List<ProductsModel> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  final Map<String, int> _selections;
  @override
  Map<String, int> get selections {
    if (_selections is EqualUnmodifiableMapView) return _selections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_selections);
  }

  @override
  String toString() {
    return 'FoodServerModel(products: $products, selections: $selections)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodServerModelImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            const DeepCollectionEquality()
                .equals(other._selections, _selections));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_products),
      const DeepCollectionEquality().hash(_selections));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodServerModelImplCopyWith<_$FoodServerModelImpl> get copyWith =>
      __$$FoodServerModelImplCopyWithImpl<_$FoodServerModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodServerModelImplToJson(
      this,
    );
  }
}

abstract class _FoodServerModel implements FoodServerModel {
  const factory _FoodServerModel(
      {required final List<ProductsModel> products,
      required final Map<String, int> selections}) = _$FoodServerModelImpl;

  factory _FoodServerModel.fromJson(Map<String, dynamic> json) =
      _$FoodServerModelImpl.fromJson;

  @override
  List<ProductsModel> get products;
  @override
  Map<String, int> get selections;
  @override
  @JsonKey(ignore: true)
  _$$FoodServerModelImplCopyWith<_$FoodServerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FoodServerSelection _$FoodServerSelectionFromJson(Map<String, dynamic> json) {
  return _FoodServerSelection.fromJson(json);
}

/// @nodoc
mixin _$FoodServerSelection {
  String get productId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FoodServerSelectionCopyWith<FoodServerSelection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodServerSelectionCopyWith<$Res> {
  factory $FoodServerSelectionCopyWith(
          FoodServerSelection value, $Res Function(FoodServerSelection) then) =
      _$FoodServerSelectionCopyWithImpl<$Res, FoodServerSelection>;
  @useResult
  $Res call({String productId, int quantity});
}

/// @nodoc
class _$FoodServerSelectionCopyWithImpl<$Res, $Val extends FoodServerSelection>
    implements $FoodServerSelectionCopyWith<$Res> {
  _$FoodServerSelectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodServerSelectionImplCopyWith<$Res>
    implements $FoodServerSelectionCopyWith<$Res> {
  factory _$$FoodServerSelectionImplCopyWith(_$FoodServerSelectionImpl value,
          $Res Function(_$FoodServerSelectionImpl) then) =
      __$$FoodServerSelectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String productId, int quantity});
}

/// @nodoc
class __$$FoodServerSelectionImplCopyWithImpl<$Res>
    extends _$FoodServerSelectionCopyWithImpl<$Res, _$FoodServerSelectionImpl>
    implements _$$FoodServerSelectionImplCopyWith<$Res> {
  __$$FoodServerSelectionImplCopyWithImpl(_$FoodServerSelectionImpl _value,
      $Res Function(_$FoodServerSelectionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? quantity = null,
  }) {
    return _then(_$FoodServerSelectionImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodServerSelectionImpl implements _FoodServerSelection {
  const _$FoodServerSelectionImpl(
      {required this.productId, required this.quantity});

  factory _$FoodServerSelectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodServerSelectionImplFromJson(json);

  @override
  final String productId;
  @override
  final int quantity;

  @override
  String toString() {
    return 'FoodServerSelection(productId: $productId, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodServerSelectionImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, productId, quantity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodServerSelectionImplCopyWith<_$FoodServerSelectionImpl> get copyWith =>
      __$$FoodServerSelectionImplCopyWithImpl<_$FoodServerSelectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodServerSelectionImplToJson(
      this,
    );
  }
}

abstract class _FoodServerSelection implements FoodServerSelection {
  const factory _FoodServerSelection(
      {required final String productId,
      required final int quantity}) = _$FoodServerSelectionImpl;

  factory _FoodServerSelection.fromJson(Map<String, dynamic> json) =
      _$FoodServerSelectionImpl.fromJson;

  @override
  String get productId;
  @override
  int get quantity;
  @override
  @JsonKey(ignore: true)
  _$$FoodServerSelectionImplCopyWith<_$FoodServerSelectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
