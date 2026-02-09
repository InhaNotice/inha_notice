// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notice_board_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoticeBoardFailure {
  String get message;

  /// Create a copy of NoticeBoardFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NoticeBoardFailureCopyWith<NoticeBoardFailure> get copyWith =>
      _$NoticeBoardFailureCopyWithImpl<NoticeBoardFailure>(
          this as NoticeBoardFailure, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NoticeBoardFailure &&
            super == other &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode, message);
}

/// @nodoc
abstract mixin class $NoticeBoardFailureCopyWith<$Res> {
  factory $NoticeBoardFailureCopyWith(
          NoticeBoardFailure value, $Res Function(NoticeBoardFailure) _then) =
      _$NoticeBoardFailureCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$NoticeBoardFailureCopyWithImpl<$Res>
    implements $NoticeBoardFailureCopyWith<$Res> {
  _$NoticeBoardFailureCopyWithImpl(this._self, this._then);

  final NoticeBoardFailure _self;
  final $Res Function(NoticeBoardFailure) _then;

  /// Create a copy of NoticeBoardFailure
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

/// Adds pattern-matching-related methods to [NoticeBoardFailure].
extension NoticeBoardFailurePatterns on NoticeBoardFailure {
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
    TResult Function(_FetchNotices value)? fetchNotices,
    TResult Function(_InitScraper value)? initScraper,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FetchNotices() when fetchNotices != null:
        return fetchNotices(_that);
      case _InitScraper() when initScraper != null:
        return initScraper(_that);
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
    required TResult Function(_FetchNotices value) fetchNotices,
    required TResult Function(_InitScraper value) initScraper,
  }) {
    final _that = this;
    switch (_that) {
      case _FetchNotices():
        return fetchNotices(_that);
      case _InitScraper():
        return initScraper(_that);
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
    TResult? Function(_FetchNotices value)? fetchNotices,
    TResult? Function(_InitScraper value)? initScraper,
  }) {
    final _that = this;
    switch (_that) {
      case _FetchNotices() when fetchNotices != null:
        return fetchNotices(_that);
      case _InitScraper() when initScraper != null:
        return initScraper(_that);
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
    TResult Function(String message)? fetchNotices,
    TResult Function(String message)? initScraper,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FetchNotices() when fetchNotices != null:
        return fetchNotices(_that.message);
      case _InitScraper() when initScraper != null:
        return initScraper(_that.message);
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
    required TResult Function(String message) fetchNotices,
    required TResult Function(String message) initScraper,
  }) {
    final _that = this;
    switch (_that) {
      case _FetchNotices():
        return fetchNotices(_that.message);
      case _InitScraper():
        return initScraper(_that.message);
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
    TResult? Function(String message)? fetchNotices,
    TResult? Function(String message)? initScraper,
  }) {
    final _that = this;
    switch (_that) {
      case _FetchNotices() when fetchNotices != null:
        return fetchNotices(_that.message);
      case _InitScraper() when initScraper != null:
        return initScraper(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FetchNotices extends NoticeBoardFailure {
  const _FetchNotices(this.message) : super._();

  @override
  final String message;

  /// Create a copy of NoticeBoardFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FetchNoticesCopyWith<_FetchNotices> get copyWith =>
      __$FetchNoticesCopyWithImpl<_FetchNotices>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FetchNotices &&
            super == other &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode, message);
}

/// @nodoc
abstract mixin class _$FetchNoticesCopyWith<$Res>
    implements $NoticeBoardFailureCopyWith<$Res> {
  factory _$FetchNoticesCopyWith(
          _FetchNotices value, $Res Function(_FetchNotices) _then) =
      __$FetchNoticesCopyWithImpl;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$FetchNoticesCopyWithImpl<$Res>
    implements _$FetchNoticesCopyWith<$Res> {
  __$FetchNoticesCopyWithImpl(this._self, this._then);

  final _FetchNotices _self;
  final $Res Function(_FetchNotices) _then;

  /// Create a copy of NoticeBoardFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(_FetchNotices(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _InitScraper extends NoticeBoardFailure {
  const _InitScraper(this.message) : super._();

  @override
  final String message;

  /// Create a copy of NoticeBoardFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InitScraperCopyWith<_InitScraper> get copyWith =>
      __$InitScraperCopyWithImpl<_InitScraper>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InitScraper &&
            super == other &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode, message);
}

/// @nodoc
abstract mixin class _$InitScraperCopyWith<$Res>
    implements $NoticeBoardFailureCopyWith<$Res> {
  factory _$InitScraperCopyWith(
          _InitScraper value, $Res Function(_InitScraper) _then) =
      __$InitScraperCopyWithImpl;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$InitScraperCopyWithImpl<$Res> implements _$InitScraperCopyWith<$Res> {
  __$InitScraperCopyWithImpl(this._self, this._then);

  final _InitScraper _self;
  final $Res Function(_InitScraper) _then;

  /// Create a copy of NoticeBoardFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(_InitScraper(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
