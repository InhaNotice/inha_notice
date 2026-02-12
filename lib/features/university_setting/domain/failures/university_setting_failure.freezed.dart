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

part of 'university_setting_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UniversitySettingFailure {
  String get message;

  /// Create a copy of UniversitySettingFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UniversitySettingFailureCopyWith<UniversitySettingFailure> get copyWith =>
      _$UniversitySettingFailureCopyWithImpl<UniversitySettingFailure>(
          this as UniversitySettingFailure, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UniversitySettingFailure &&
            super == other &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode, message);
}

/// @nodoc
abstract mixin class $UniversitySettingFailureCopyWith<$Res> {
  factory $UniversitySettingFailureCopyWith(UniversitySettingFailure value,
          $Res Function(UniversitySettingFailure) _then) =
      _$UniversitySettingFailureCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$UniversitySettingFailureCopyWithImpl<$Res>
    implements $UniversitySettingFailureCopyWith<$Res> {
  _$UniversitySettingFailureCopyWithImpl(this._self, this._then);

  final UniversitySettingFailure _self;
  final $Res Function(UniversitySettingFailure) _then;

  /// Create a copy of UniversitySettingFailure
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

/// Adds pattern-matching-related methods to [UniversitySettingFailure].
extension UniversitySettingFailurePatterns on UniversitySettingFailure {
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
    TResult Function(_LoadSetting value)? loadSetting,
    TResult Function(_SaveSetting value)? saveSetting,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LoadSetting() when loadSetting != null:
        return loadSetting(_that);
      case _SaveSetting() when saveSetting != null:
        return saveSetting(_that);
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
    required TResult Function(_LoadSetting value) loadSetting,
    required TResult Function(_SaveSetting value) saveSetting,
  }) {
    final _that = this;
    switch (_that) {
      case _LoadSetting():
        return loadSetting(_that);
      case _SaveSetting():
        return saveSetting(_that);
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
    TResult? Function(_LoadSetting value)? loadSetting,
    TResult? Function(_SaveSetting value)? saveSetting,
  }) {
    final _that = this;
    switch (_that) {
      case _LoadSetting() when loadSetting != null:
        return loadSetting(_that);
      case _SaveSetting() when saveSetting != null:
        return saveSetting(_that);
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
    TResult Function(String message)? loadSetting,
    TResult Function(String message)? saveSetting,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LoadSetting() when loadSetting != null:
        return loadSetting(_that.message);
      case _SaveSetting() when saveSetting != null:
        return saveSetting(_that.message);
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
    required TResult Function(String message) loadSetting,
    required TResult Function(String message) saveSetting,
  }) {
    final _that = this;
    switch (_that) {
      case _LoadSetting():
        return loadSetting(_that.message);
      case _SaveSetting():
        return saveSetting(_that.message);
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
    TResult? Function(String message)? loadSetting,
    TResult? Function(String message)? saveSetting,
  }) {
    final _that = this;
    switch (_that) {
      case _LoadSetting() when loadSetting != null:
        return loadSetting(_that.message);
      case _SaveSetting() when saveSetting != null:
        return saveSetting(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _LoadSetting extends UniversitySettingFailure {
  const _LoadSetting(this.message) : super._();

  @override
  final String message;

  /// Create a copy of UniversitySettingFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoadSettingCopyWith<_LoadSetting> get copyWith =>
      __$LoadSettingCopyWithImpl<_LoadSetting>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LoadSetting &&
            super == other &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode, message);
}

/// @nodoc
abstract mixin class _$LoadSettingCopyWith<$Res>
    implements $UniversitySettingFailureCopyWith<$Res> {
  factory _$LoadSettingCopyWith(
          _LoadSetting value, $Res Function(_LoadSetting) _then) =
      __$LoadSettingCopyWithImpl;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$LoadSettingCopyWithImpl<$Res> implements _$LoadSettingCopyWith<$Res> {
  __$LoadSettingCopyWithImpl(this._self, this._then);

  final _LoadSetting _self;
  final $Res Function(_LoadSetting) _then;

  /// Create a copy of UniversitySettingFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(_LoadSetting(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _SaveSetting extends UniversitySettingFailure {
  const _SaveSetting(this.message) : super._();

  @override
  final String message;

  /// Create a copy of UniversitySettingFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SaveSettingCopyWith<_SaveSetting> get copyWith =>
      __$SaveSettingCopyWithImpl<_SaveSetting>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SaveSetting &&
            super == other &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode, message);
}

/// @nodoc
abstract mixin class _$SaveSettingCopyWith<$Res>
    implements $UniversitySettingFailureCopyWith<$Res> {
  factory _$SaveSettingCopyWith(
          _SaveSetting value, $Res Function(_SaveSetting) _then) =
      __$SaveSettingCopyWithImpl;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$SaveSettingCopyWithImpl<$Res> implements _$SaveSettingCopyWith<$Res> {
  __$SaveSettingCopyWithImpl(this._self, this._then);

  final _SaveSetting _self;
  final $Res Function(_SaveSetting) _then;

  /// Create a copy of UniversitySettingFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(_SaveSetting(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
