/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-18
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/config/app_bloc_observer.dart';
import 'package:logger/logger.dart';

sealed class _TestEvent {
  const _TestEvent();
}

class _IncrementEvent extends _TestEvent {
  const _IncrementEvent();

  @override
  String toString() => 'IncrementEvent';
}

class _TestCounterBloc extends Bloc<_TestEvent, int> {
  _TestCounterBloc() : super(0) {
    on<_IncrementEvent>((event, emit) => emit(state + 1));
  }
}

class _MemoryOutput extends LogOutput {
  final List<String> lines = [];

  @override
  void output(OutputEvent event) {
    lines.addAll(event.lines);
  }
}

void main() {
  group('AppBlocObserver 유닛 테스트', () {
    late _MemoryOutput output;
    late AppBlocObserver observer;
    late _TestCounterBloc bloc;

    setUp(() {
      output = _MemoryOutput();
      final logger = Logger(
        printer:
            PrettyPrinter(methodCount: 0, colors: false, printEmojis: false),
        output: output,
      );
      observer = AppBlocObserver(logger: logger);
      bloc = _TestCounterBloc();
    });

    tearDown(() async {
      await bloc.close();
    });

    test('onCreate는 Bloc 생성 로그를 남긴다', () {
      observer.onCreate(bloc);

      expect(
          output.lines
              .any((line) => line.contains('[Bloc Created] _TestCounterBloc')),
          isTrue);
    });

    test('onEvent는 이벤트 로그를 남긴다', () {
      observer.onEvent(bloc, const _IncrementEvent());

      expect(
          output.lines.any((line) => line
              .contains('[Event Added] _TestCounterBloc -> IncrementEvent')),
          isTrue);
    });

    test('onTransition은 상태 전이 로그를 남긴다', () {
      observer.onTransition(
        bloc,
        const Transition<_TestEvent, int>(
          currentState: 0,
          event: _IncrementEvent(),
          nextState: 1,
        ),
      );

      expect(output.lines.any((line) => line.contains('_TestCounterBloc')),
          isTrue);
      expect(output.lines.any((line) => line.contains('Current: 0')), isTrue);
      expect(
          output.lines.any((line) => line.contains('Event:   IncrementEvent')),
          isTrue);
      expect(output.lines.any((line) => line.contains('Next:    1')), isTrue);
    });

    test('onError는 에러 로그를 남긴다', () {
      observer.onError(bloc, 'boom', StackTrace.empty);

      expect(
          output.lines
              .any((line) => line.contains('[Error] _TestCounterBloc -> boom')),
          isTrue);
    });
  });
}
