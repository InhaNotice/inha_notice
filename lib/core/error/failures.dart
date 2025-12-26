import 'package:equatable/equatable.dart';

export 'package:inha_notice/features/notice/domain/failures/home_failures.dart';

abstract class Failures extends Equatable {
  final String message;

  const Failures(this.message);

  @override
  List<Object> get props => [message];
}
