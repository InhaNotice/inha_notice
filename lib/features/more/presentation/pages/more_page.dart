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
import 'package:inha_notice/core/presentation/widgets/blue_loading_indicator_widget.dart'; // 로딩 위젯 가정
import 'package:inha_notice/core/presentation/widgets/common_app_bar_widget.dart';
import 'package:inha_notice/features/more/domain/entities/more_configuration_entity.dart';
import 'package:inha_notice/features/more/presentation/bloc/more_bloc.dart';
import 'package:inha_notice/features/more/presentation/bloc/more_event.dart';
import 'package:inha_notice/features/more/presentation/bloc/more_state.dart';
import 'package:inha_notice/features/more/presentation/pages/oss_license_page.dart';
import 'package:inha_notice/features/more/presentation/widgets/cache_deletion_widget.dart';
import 'package:inha_notice/features/more/presentation/widgets/more_navigation_tile.dart';
import 'package:inha_notice/features/more/presentation/widgets/more_non_navigation_tile.dart';
import 'package:inha_notice/features/more/presentation/widgets/more_title_tile.dart';
import 'package:inha_notice/features/more/presentation/widgets/more_web_navigation_tile.dart';
import 'package:inha_notice/features/more/presentation/widgets/theme_preference_tile.dart';
import 'package:inha_notice/features/notification_setting/presentation/pages/notification_setting_page.dart';
import 'package:inha_notice/features/user_preference/presentation/pages/user_preference_page.dart';
import 'package:inha_notice/injection_container.dart' as di;

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<MoreBloc>()..add(LoadWebUrlsEvent()),
      child: const _MorePageView(),
    );
  }
}

class _MorePageView extends StatelessWidget {
  const _MorePageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBarWidget(
          title: '더보기', titleSize: 20, isCenter: false),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<MoreBloc, MoreState>(
        builder: (context, state) {
          if (state is MoreLoading || state is MoreInitial) {
            return const Center(child: BlueLoadingIndicatorWidget());
          }

          if (state is MoreError) {
            return Center(child: Text(state.message));
          }

          if (state is MoreLoaded) {
            return _buildBody(context, state.webUrls);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, MoreConfigurationEntity entity) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MoreTitleTile(text: '공지사항', fontSize: 16),
            MoreNavigationTile(
                title: '알림 설정',
                icon: Icons.notifications_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationSettingPage(),
                    ),
                  );
                }),
            // 구분선
            SizedBox(
                width: double.infinity,
                child: Divider(
                    color: Theme.of(context).dividerColor, thickness: 2.0)),
            const MoreTitleTile(text: '이용 안내', fontSize: 16),
            MoreWebNavigationTile(
                title: '새로운 내용',
                url: entity.featuresUrl,
                icon: Icons.star_outline_outlined),
            MoreWebNavigationTile(
                title: '개인정보 처리방침',
                url: entity.personalInformationUrl,
                icon: Icons.privacy_tip_outlined),
            MoreWebNavigationTile(
                title: '서비스 이용약관',
                url: entity.termsAndConditionsOfServiceUrl,
                icon: Icons.checklist_rtl_outlined),
            MoreWebNavigationTile(
                title: '앱 소개',
                url: entity.introduceAppUrl,
                icon: Icons.info_outline),
            MoreWebNavigationTile(
                title: 'FAQ',
                url: entity.questionsAndAnswersUrl,
                icon: Icons.question_answer_outlined),
            // 구분선
            SizedBox(
                width: double.infinity,
                child: Divider(
                    color: Theme.of(context).dividerColor, thickness: 2.0)),
            const MoreTitleTile(text: '앱 설정', fontSize: 16),
            MoreNonNavigationTile(
                title: '버전',
                description: entity.appVersion,
                icon: Icons.rocket_launch_outlined),
            MoreNavigationTile(
              title: '개인화 설정',
              icon: Icons.tune_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserPreferencePage(),
                  ),
                );
              },
            ),
            const ThemePreferenceTile(
              title: '테마',
              icon: Icons.palette_outlined,
            ),
            const CacheDeletionWidget(
              title: '캐시 삭제',
              icon: Icons.cleaning_services_outlined,
            ),
            // 구분선
            SizedBox(
                width: double.infinity,
                child: Divider(
                    color: Theme.of(context).dividerColor, thickness: 2.0)),
            const MoreTitleTile(text: '기타', fontSize: 16),
            MoreNavigationTile(
              title: '사용된 오픈소스',
              icon: Icons.source_outlined,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const OssLicensePage()),
                );
              },
            ),
            SizedBox(
                width: double.infinity,
                child: Divider(
                    color: Theme.of(context).dividerColor, thickness: 2.0)),
            const MoreTitleTile(
                text: 'Copyright (c) 2025-2026 INGONG', fontSize: 12),
          ],
        ),
      ),
    );
  }
}
