/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/features/notice/presentation/bloc/notice_board_bloc.dart';
import 'package:inha_notice/features/notice/presentation/bloc/notice_board_event.dart';
import 'package:inha_notice/features/notice/presentation/pages/notice_board_page.dart';
import 'package:inha_notice/injection_container.dart';

class NoticeBoardTabWidget extends StatelessWidget {
  final String noticeType;

  const NoticeBoardTabWidget({
    super.key,
    required this.noticeType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<NoticeBoardBloc>()..add(LoadNoticeBoardEvent(noticeType: noticeType)),
      child: NoticeBoardPage(noticeType: noticeType),
    );
  }
}
