/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_tab_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomTabFailure {
  String get message;

  /// Create a copy of CustomTabFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CustomTabFailureCopyWith<CustomTabFailure> get copyWith =>
      _$CustomTabFailureCopyWithImpl<CustomTabFailure>(
          this as CustomTabFailure, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CustomTabFailure &&
            super == other &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode, message);
}

/// @nodoc
abstract mixin class $CustomTabFailureCopyWith<$Res> {
  factory $CustomTabFailureCopyWith(
          CustomTabFailure value, $Res Function(CustomTabFailure) _then) =
      _$CustomTabFailureCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$CustomTabFailureCopyWithImpl<$Res>
    implements $CustomTabFailureCopyWith<$Res> {
  _$CustomTabFailureCopyWithImpl(this._self, this._then);

  final CustomTabFailure _self;
  final $Res Function(CustomTabFailure) _then;

  /// Create a copy of CustomTabFailure
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

/// Adds pattern-matching-related methods to [CustomTabFailure].
extension CustomTabFailurePatterns on CustomTabFailure {
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
    TResult Function(_LoadTabs value)? loadTabs,
    TResult Function(_SaveTabs value)? saveTabs,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LoadTabs() when loadTabs != null:
        return loadTabs(_that);
      case _SaveTabs() when saveTabs != null:
        return saveTabs(_that);
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
    required TResult Function(_LoadTabs value) loadTabs,
    required TResult Function(_SaveTabs value) saveTabs,
  }) {
    final _that = this;
    switch (_that) {
      case _LoadTabs():
        return loadTabs(_that);
      case _SaveTabs():
        return saveTabs(_that);
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
    TResult? Function(_LoadTabs value)? loadTabs,
    TResult? Function(_SaveTabs value)? saveTabs,
  }) {
    final _that = this;
    switch (_that) {
      case _LoadTabs() when loadTabs != null:
        return loadTabs(_that);
      case _SaveTabs() when saveTabs != null:
        return saveTabs(_that);
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
    TResult Function(String message)? loadTabs,
    TResult Function(String message)? saveTabs,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LoadTabs() when loadTabs != null:
        return loadTabs(_that.message);
      case _SaveTabs() when saveTabs != null:
        return saveTabs(_that.message);
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
    required TResult Function(String message) loadTabs,
    required TResult Function(String message) saveTabs,
  }) {
    final _that = this;
    switch (_that) {
      case _LoadTabs():
        return loadTabs(_that.message);
      case _SaveTabs():
        return saveTabs(_that.message);
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
    TResult? Function(String message)? loadTabs,
    TResult? Function(String message)? saveTabs,
  }) {
    final _that = this;
    switch (_that) {
      case _LoadTabs() when loadTabs != null:
        return loadTabs(_that.message);
      case _SaveTabs() when saveTabs != null:
        return saveTabs(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _LoadTabs extends CustomTabFailure {
  const _LoadTabs(this.message) : super._();

  @override
  final String message;

  /// Create a copy of CustomTabFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoadTabsCopyWith<_LoadTabs> get copyWith =>
      __$LoadTabsCopyWithImpl<_LoadTabs>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LoadTabs &&
            super == other &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode, message);
}

/// @nodoc
abstract mixin class _$LoadTabsCopyWith<$Res>
    implements $CustomTabFailureCopyWith<$Res> {
  factory _$LoadTabsCopyWith(_LoadTabs value, $Res Function(_LoadTabs) _then) =
      __$LoadTabsCopyWithImpl;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$LoadTabsCopyWithImpl<$Res> implements _$LoadTabsCopyWith<$Res> {
  __$LoadTabsCopyWithImpl(this._self, this._then);

  final _LoadTabs _self;
  final $Res Function(_LoadTabs) _then;

  /// Create a copy of CustomTabFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(_LoadTabs(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _SaveTabs extends CustomTabFailure {
  const _SaveTabs(this.message) : super._();

  @override
  final String message;

  /// Create a copy of CustomTabFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SaveTabsCopyWith<_SaveTabs> get copyWith =>
      __$SaveTabsCopyWithImpl<_SaveTabs>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SaveTabs &&
            super == other &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode, message);
}

/// @nodoc
abstract mixin class _$SaveTabsCopyWith<$Res>
    implements $CustomTabFailureCopyWith<$Res> {
  factory _$SaveTabsCopyWith(_SaveTabs value, $Res Function(_SaveTabs) _then) =
      __$SaveTabsCopyWithImpl;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$SaveTabsCopyWithImpl<$Res> implements _$SaveTabsCopyWith<$Res> {
  __$SaveTabsCopyWithImpl(this._self, this._then);

  final _SaveTabs _self;
  final $Res Function(_SaveTabs) _then;

  /// Create a copy of CustomTabFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(_SaveTabs(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
