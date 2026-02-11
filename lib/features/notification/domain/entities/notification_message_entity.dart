/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-11
 */

import 'package:equatable/equatable.dart';

class NotificationMessageEntity extends Equatable {
  final String? id;
  final String? link;

  const NotificationMessageEntity({required this.id, required this.link});

  @override
  List<Object?> get props => [id, link];
}
