/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:equatable/equatable.dart';

class MainNavigationState extends Equatable {
  final int tabIndex;
  final String targetUrl;

  const MainNavigationState({this.tabIndex = 0, this.targetUrl = ''});

  MainNavigationState copyWith({
    int? tabIndex,
    String? initialUrl,
  }) {
    return MainNavigationState(
        tabIndex: tabIndex ?? this.tabIndex,
        targetUrl: initialUrl ?? this.targetUrl);
  }

  @override
  List<Object?> get props => [tabIndex, targetUrl];
}
