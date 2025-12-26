import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inha_notice/core/error/failures.dart';

part 'home_failures.freezed.dart';

@freezed
class HomeFailure with _$HomeFailure implements Failures {
  const factory HomeFailure.tabs(String message) = _Tabs;

  @override
  // TODO: implement message
  String get message => throw UnimplementedError();

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}
