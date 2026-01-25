/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-25
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/features/more/presentation/bloc/cache_bloc.dart';
import 'package:inha_notice/features/more/presentation/bloc/cache_event.dart';
import 'package:inha_notice/features/more/presentation/bloc/cache_state.dart';
import 'package:inha_notice/injection_container.dart' as di;
import 'package:inha_notice/widgets/dialogs/cache_deletion_dialog.dart';

class CacheDeletionWidget extends StatelessWidget {
  final String title;
  final IconData icon;

  const CacheDeletionWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<CacheBloc>()..add(LoadCacheSizeEvent()),
      child: _CacheDeletionWidgetBody(title: title, icon: icon),
    );
  }
}

class _CacheDeletionWidgetBody extends StatefulWidget {
  final String title;
  final IconData icon;

  const _CacheDeletionWidgetBody({
    required this.title,
    required this.icon,
  });

  @override
  State<_CacheDeletionWidgetBody> createState() =>
      _CacheDeletionWidgetBodyState();
}

class _CacheDeletionWidgetBodyState extends State<_CacheDeletionWidgetBody> {
  /// **다이얼로그 push -> pop 후, 변경사항 반영**
  Future<void> handleCacheDeletionTap(BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) => const CacheDeletionDialog(),
    );

    // 다이얼로그가 닫히면(캐시 삭제 후) 다시 로드 이벤트 발생
    if (context.mounted) {
      context.read<CacheBloc>().add(LoadCacheSizeEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleCacheDeletionTap(context),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(widget.icon,
                    size: 20, color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: AppFont.pretendard.family,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).textTheme.bodyMedium?.color ??
                        Theme.of(context).defaultThemedTextColor,
                  ),
                ),
              ],
            ),
            // BlocBuilder로 상태 구독
            BlocBuilder<CacheBloc, CacheState>(
              builder: (context, state) {
                String cacheSize = '0.00 MB';

                if (state is CacheError) {
                  cacheSize = state.message;
                }

                if (state is CacheLoaded) {
                  cacheSize = state.cacheSize;
                }

                return Text(
                  cacheSize,
                  style: TextStyle(
                    fontFamily: AppFont.pretendard.family,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).dialogGreyTextColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
