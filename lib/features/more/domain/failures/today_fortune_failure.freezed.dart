// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_fortune_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodayFortuneFailure {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TodayFortuneFailure &&
            super == other);
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode);
}

/// @nodoc
class $TodayFortuneFailureCopyWith<$Res> {
  $TodayFortuneFailureCopyWith(
      TodayFortuneFailure _, $Res Function(TodayFortuneFailure) __);
}

/// Adds pattern-matching-related methods to [TodayFortuneFailure].
extension TodayFortuneFailurePatterns on TodayFortuneFailure {
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
    TResult Function(_Storage value)? storage,
    TResult Function(_MessagePool value)? messagePool,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Storage() when storage != null:
        return storage(_that);
      case _MessagePool() when messagePool != null:
        return messagePool(_that);
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
    required TResult Function(_Storage value) storage,
    required TResult Function(_MessagePool value) messagePool,
  }) {
    final _that = this;
    switch (_that) {
      case _Storage():
        return storage(_that);
      case _MessagePool():
        return messagePool(_that);
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
    TResult? Function(_Storage value)? storage,
    TResult? Function(_MessagePool value)? messagePool,
  }) {
    final _that = this;
    switch (_that) {
      case _Storage() when storage != null:
        return storage(_that);
      case _MessagePool() when messagePool != null:
        return messagePool(_that);
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
    TResult Function()? storage,
    TResult Function()? messagePool,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Storage() when storage != null:
        return storage();
      case _MessagePool() when messagePool != null:
        return messagePool();
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
    required TResult Function() storage,
    required TResult Function() messagePool,
  }) {
    final _that = this;
    switch (_that) {
      case _Storage():
        return storage();
      case _MessagePool():
        return messagePool();
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
    TResult? Function()? storage,
    TResult? Function()? messagePool,
  }) {
    final _that = this;
    switch (_that) {
      case _Storage() when storage != null:
        return storage();
      case _MessagePool() when messagePool != null:
        return messagePool();
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Storage extends TodayFortuneFailure {
  const _Storage() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Storage &&
            super == other);
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode);
}

/// @nodoc

class _MessagePool extends TodayFortuneFailure {
  const _MessagePool() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MessagePool &&
            super == other);
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode);
}

// dart format on
