// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeFailure {
  String get message;

  /// Create a copy of HomeFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeFailureCopyWith<HomeFailure> get copyWith =>
      _$HomeFailureCopyWithImpl<HomeFailure>(this as HomeFailure, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeFailure &&
            super == other &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode, message);
}

/// @nodoc
abstract mixin class $HomeFailureCopyWith<$Res> {
  factory $HomeFailureCopyWith(
          HomeFailure value, $Res Function(HomeFailure) _then) =
      _$HomeFailureCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$HomeFailureCopyWithImpl<$Res> implements $HomeFailureCopyWith<$Res> {
  _$HomeFailureCopyWithImpl(this._self, this._then);

  final HomeFailure _self;
  final $Res Function(HomeFailure) _then;

  /// Create a copy of HomeFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_self.copyWith(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [HomeFailure].
extension HomeFailurePatterns on HomeFailure {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Tabs value)? tabs,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Tabs() when tabs != null:
        return tabs(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Tabs value) tabs,
  }) {
    final _that = this;
    switch (_that) {
      case _Tabs():
        return tabs(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Tabs value)? tabs,
  }) {
    final _that = this;
    switch (_that) {
      case _Tabs() when tabs != null:
        return tabs(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? tabs,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Tabs() when tabs != null:
        return tabs(_that.message);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) tabs,
  }) {
    final _that = this;
    switch (_that) {
      case _Tabs():
        return tabs(_that.message);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? tabs,
  }) {
    final _that = this;
    switch (_that) {
      case _Tabs() when tabs != null:
        return tabs(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Tabs extends HomeFailure {
  const _Tabs(this.message) : super._();

  @override
  final String message;

  /// Create a copy of HomeFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TabsCopyWith<_Tabs> get copyWith =>
      __$TabsCopyWithImpl<_Tabs>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Tabs &&
            super == other &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode, message);
}

/// @nodoc
abstract mixin class _$TabsCopyWith<$Res>
    implements $HomeFailureCopyWith<$Res> {
  factory _$TabsCopyWith(_Tabs value, $Res Function(_Tabs) _then) =
      __$TabsCopyWithImpl;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$TabsCopyWithImpl<$Res> implements _$TabsCopyWith<$Res> {
  __$TabsCopyWithImpl(this._self, this._then);

  final _Tabs _self;
  final $Res Function(_Tabs) _then;

  /// Create a copy of HomeFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(_Tabs(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
