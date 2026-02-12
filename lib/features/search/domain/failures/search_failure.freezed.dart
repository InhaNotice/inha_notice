// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchFailure {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchFailure &&
            super == other);
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode);
}

/// @nodoc
class $SearchFailureCopyWith<$Res> {
  $SearchFailureCopyWith(SearchFailure _, $Res Function(SearchFailure) __);
}

/// Adds pattern-matching-related methods to [SearchFailure].
extension SearchFailurePatterns on SearchFailure {
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
    TResult Function(_LocalDatabase value)? localDatabase,
    TResult Function(_Server value)? server,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LocalDatabase() when localDatabase != null:
        return localDatabase(_that);
      case _Server() when server != null:
        return server(_that);
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
    required TResult Function(_LocalDatabase value) localDatabase,
    required TResult Function(_Server value) server,
  }) {
    final _that = this;
    switch (_that) {
      case _LocalDatabase():
        return localDatabase(_that);
      case _Server():
        return server(_that);
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
    TResult? Function(_LocalDatabase value)? localDatabase,
    TResult? Function(_Server value)? server,
  }) {
    final _that = this;
    switch (_that) {
      case _LocalDatabase() when localDatabase != null:
        return localDatabase(_that);
      case _Server() when server != null:
        return server(_that);
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
    TResult Function()? localDatabase,
    TResult Function()? server,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LocalDatabase() when localDatabase != null:
        return localDatabase();
      case _Server() when server != null:
        return server();
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
    required TResult Function() localDatabase,
    required TResult Function() server,
  }) {
    final _that = this;
    switch (_that) {
      case _LocalDatabase():
        return localDatabase();
      case _Server():
        return server();
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
    TResult? Function()? localDatabase,
    TResult? Function()? server,
  }) {
    final _that = this;
    switch (_that) {
      case _LocalDatabase() when localDatabase != null:
        return localDatabase();
      case _Server() when server != null:
        return server();
      case _:
        return null;
    }
  }
}

/// @nodoc

class _LocalDatabase extends SearchFailure {
  const _LocalDatabase() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocalDatabase &&
            super == other);
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode);
}

/// @nodoc

class _Server extends SearchFailure {
  const _Server() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Server &&
            super == other);
  }

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode);
}

// dart format on
