/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-22
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/presentation/utils/app_snack_bar.dart';
import 'package:inha_notice/core/presentation/widgets/platform_confirmation_dialog.dart';
import 'package:inha_notice/features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'package:inha_notice/features/more/presentation/bloc/cache_bloc.dart';
import 'package:inha_notice/features/more/presentation/bloc/cache_event.dart';
import 'package:inha_notice/features/more/presentation/bloc/cache_state.dart';
import 'package:inha_notice/features/notice/data/datasources/read_notice_local_data_source.dart';
import 'package:inha_notice/features/search/data/datasources/search_local_data_source.dart';
import 'package:inha_notice/injection_container.dart' as di;

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
  /// **모든 캐시를 삭제**
  Future<void> _deleteAllCaches(BuildContext context) async {
    try {
      await Future.wait([
        di.sl<BookmarkLocalDataSource>().clearBookmarks(),
        ReadNoticeLocalDataSource.clearAllReadNotices(),
        di.sl<SearchLocalDataSource>().clearRecentSearchWords(),
      ]);

      if (context.mounted) {
        AppSnackBar.success(context, '모두 삭제되었어요!');
        // 캐시 삭제 후 다시 로드
        context.read<CacheBloc>().add(LoadCacheSizeEvent());
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.error(context, '실패하였어요. 다시 시도해보세요.');
      }
    }
  }

  /// **다이얼로그 표시**
  void handleCacheDeletionTap(BuildContext context) {
    showPlatformConfirmationDialog(
      context: context,
      title: '캐시 삭제',
      content: '읽은 공지, 북마크, 검색 기록이\n모두 깔끔하게 정리돼요!',
      confirmText: '삭제',
      cancelText: '취소',
      isDestructive: true,
      onConfirm: () => _deleteAllCaches(context),
    );
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
