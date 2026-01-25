/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-25
 */

import 'package:equatable/equatable.dart';

class NoticeTileModel extends Equatable {
  final String id;
  final String title;
  final String link;
  final String date;

  final String? body;
  final String? access;

  const NoticeTileModel({
    required this.id,
    required this.title,
    required this.link,
    required this.date,
    this.body,
    this.access,
  });

  factory NoticeTileModel.fromMap(Map<String, dynamic> map) {
    String id = map['id'] ?? '';
    String title = map['title'] ?? '';
    String link = map['link'] ?? '';
    String date = map['date'] ?? '';
    String? body = map['body'];
    String? access = map['access'];

    return NoticeTileModel(
        id: id,
        title: title,
        link: link,
        date: date,
        body: body,
        access: access);
  }

  @override
  List<Object?> get props => [id, title, link, date, body, access];
}
