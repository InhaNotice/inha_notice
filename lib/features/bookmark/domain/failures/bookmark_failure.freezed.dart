// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookmark_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookmarkFailure {
  String get message;

  /// Create a copy of BookmarkFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookmarkFailureCopyWith<BookmarkFailure> get copyWith =>
      _$BookmarkFailureCopyWithImpl<BookmarkFailure>(
          this as BookmarkFailure, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BookmarkFailure &&
            super == other &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode, message);
}

/// @nodoc
abstract mixin class $BookmarkFailureCopyWith<$Res> {
  factory $BookmarkFailureCopyWith(
          BookmarkFailure value, $Res Function(BookmarkFailure) _then) =
      _$BookmarkFailureCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$BookmarkFailureCopyWithImpl<$Res>
    implements $BookmarkFailureCopyWith<$Res> {
  _$BookmarkFailureCopyWithImpl(this._self, this._then);

  final BookmarkFailure _self;
  final $Res Function(BookmarkFailure) _then;

  /// Create a copy of BookmarkFailure
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

/// Adds pattern-matching-related methods to [BookmarkFailure].
extension BookmarkFailurePatterns on BookmarkFailure {
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
    TResult Function(_Bookmarks value)? bookmarks,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Bookmarks() when bookmarks != null:
        return bookmarks(_that);
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
    required TResult Function(_Bookmarks value) bookmarks,
  }) {
    final _that = this;
    switch (_that) {
      case _Bookmarks():
        return bookmarks(_that);
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
    TResult? Function(_Bookmarks value)? bookmarks,
  }) {
    final _that = this;
    switch (_that) {
      case _Bookmarks() when bookmarks != null:
        return bookmarks(_that);
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
    TResult Function(String message)? bookmarks,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Bookmarks() when bookmarks != null:
        return bookmarks(_that.message);
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
    required TResult Function(String message) bookmarks,
  }) {
    final _that = this;
    switch (_that) {
      case _Bookmarks():
        return bookmarks(_that.message);
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
    TResult? Function(String message)? bookmarks,
  }) {
    final _that = this;
    switch (_that) {
      case _Bookmarks() when bookmarks != null:
        return bookmarks(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Bookmarks extends BookmarkFailure {
  const _Bookmarks(this.message) : super._();

  @override
  final String message;

  /// Create a copy of BookmarkFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BookmarksCopyWith<_Bookmarks> get copyWith =>
      __$BookmarksCopyWithImpl<_Bookmarks>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Bookmarks &&
            super == other &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode, message);
}

/// @nodoc
abstract mixin class _$BookmarksCopyWith<$Res>
    implements $BookmarkFailureCopyWith<$Res> {
  factory _$BookmarksCopyWith(
          _Bookmarks value, $Res Function(_Bookmarks) _then) =
      __$BookmarksCopyWithImpl;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$BookmarksCopyWithImpl<$Res> implements _$BookmarksCopyWith<$Res> {
  __$BookmarksCopyWithImpl(this._self, this._then);

  final _Bookmarks _self;
  final $Res Function(_Bookmarks) _then;

  /// Create a copy of BookmarkFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(_Bookmarks(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
