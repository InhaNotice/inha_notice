/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-17
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class AppBlocObserver extends BlocObserver {
  final Logger logger;

  AppBlocObserver({Logger? logger})
      : logger = logger ??
            Logger(
              printer: PrettyPrinter(
                methodCount: 0,
                errorMethodCount: 5,
                lineLength: 80,
                colors: true,
                dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
              ),
              filter: ProductionFilter(),
            );

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    logger.d('[Bloc Created] ${bloc.runtimeType}');
  }

  /// 2. onEvent
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.d('[Event Added] ${bloc.runtimeType} -> $event');
  }

  /// 3. onTransition
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger
        .d('twisted_rightwards_arrows [State Transition] ${bloc.runtimeType}\n'
            '   Current: ${transition.currentState}\n'
            '   Event:   ${transition.event}\n'
            '   Next:    ${transition.nextState}');
  }

  /// 4. onError
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.e('[Error] ${bloc.runtimeType} -> $error');
    super.onError(bloc, error, stackTrace);
  }
}
