// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'products_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductsModel _$ProductsModelFromJson(Map<String, dynamic> json) {
  return _ProductsModel.fromJson(json);
}

/// @nodoc
mixin _$ProductsModel {
  String get productName => throw _privateConstructorUsedError;
  List<RecipeModel> get recipe => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductsModelCopyWith<ProductsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductsModelCopyWith<$Res> {
  factory $ProductsModelCopyWith(
          ProductsModel value, $Res Function(ProductsModel) then) =
      _$ProductsModelCopyWithImpl<$Res, ProductsModel>;
  @useResult
  $Res call({String productName, List<RecipeModel> recipe});
}

/// @nodoc
class _$ProductsModelCopyWithImpl<$Res, $Val extends ProductsModel>
    implements $ProductsModelCopyWith<$Res> {
  _$ProductsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = null,
    Object? recipe = null,
  }) {
    return _then(_value.copyWith(
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      recipe: null == recipe
          ? _value.recipe
          : recipe // ignore: cast_nullable_to_non_nullable
              as List<RecipeModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductsModelImplCopyWith<$Res>
    implements $ProductsModelCopyWith<$Res> {
  factory _$$ProductsModelImplCopyWith(
          _$ProductsModelImpl value, $Res Function(_$ProductsModelImpl) then) =
      __$$ProductsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String productName, List<RecipeModel> recipe});
}

/// @nodoc
class __$$ProductsModelImplCopyWithImpl<$Res>
    extends _$ProductsModelCopyWithImpl<$Res, _$ProductsModelImpl>
    implements _$$ProductsModelImplCopyWith<$Res> {
  __$$ProductsModelImplCopyWithImpl(
      _$ProductsModelImpl _value, $Res Function(_$ProductsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = null,
    Object? recipe = null,
  }) {
    return _then(_$ProductsModelImpl(
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      recipe: null == recipe
          ? _value._recipe
          : recipe // ignore: cast_nullable_to_non_nullable
              as List<RecipeModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductsModelImpl extends _ProductsModel {
  const _$ProductsModelImpl(
      {required this.productName, required final List<RecipeModel> recipe})
      : _recipe = recipe,
        super._();

  factory _$ProductsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductsModelImplFromJson(json);

  @override
  final String productName;
  final List<RecipeModel> _recipe;
  @override
  List<RecipeModel> get recipe {
    if (_recipe is EqualUnmodifiableListView) return _recipe;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recipe);
  }

  @override
  String toString() {
    return 'ProductsModel(productName: $productName, recipe: $recipe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductsModelImpl &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            const DeepCollectionEquality().equals(other._recipe, _recipe));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, productName, const DeepCollectionEquality().hash(_recipe));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductsModelImplCopyWith<_$ProductsModelImpl> get copyWith =>
      __$$ProductsModelImplCopyWithImpl<_$ProductsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductsModelImplToJson(
      this,
    );
  }
}

abstract class _ProductsModel extends ProductsModel {
  const factory _ProductsModel(
      {required final String productName,
      required final List<RecipeModel> recipe}) = _$ProductsModelImpl;
  const _ProductsModel._() : super._();

  factory _ProductsModel.fromJson(Map<String, dynamic> json) =
      _$ProductsModelImpl.fromJson;

  @override
  String get productName;
  @override
  List<RecipeModel> get recipe;
  @override
  @JsonKey(ignore: true)
  _$$ProductsModelImplCopyWith<_$ProductsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
