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
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/presentation/utils/app_snack_bar.dart';
import 'package:inha_notice/core/presentation/utils/blocking_dialog.dart';
import 'package:inha_notice/core/presentation/widgets/blue_loading_indicator_widget.dart';
import 'package:inha_notice/core/presentation/widgets/common_app_bar_widget.dart';
import 'package:inha_notice/features/university_setting/domain/entities/university_setting_type.dart';
import 'package:inha_notice/features/university_setting/presentation/bloc/university_setting_bloc.dart';
import 'package:inha_notice/features/university_setting/presentation/bloc/university_setting_event.dart';
import 'package:inha_notice/features/university_setting/presentation/bloc/university_setting_state.dart';
import 'package:inha_notice/features/university_setting/presentation/widgets/setting_header.dart';
import 'package:inha_notice/features/university_setting/presentation/widgets/setting_list_tile.dart';
import 'package:inha_notice/features/university_setting/presentation/widgets/setting_search_field.dart';
import 'package:inha_notice/injection_container.dart' as di;

class MajorSettingPage extends StatelessWidget {
  final String majorKeyType;

  const MajorSettingPage({super.key, required this.majorKeyType});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<UniversitySettingBloc>()
        ..add(LoadSettingEvent(
          prefKey: majorKeyType,
          settingType: UniversitySettingType.major,
          majorKeyType: majorKeyType,
        )),
      child: const _MajorSettingView(),
    );
  }
}

class _MajorSettingView extends StatelessWidget {
  const _MajorSettingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBarWidget(
          title: '학과 설정', titleSize: 20, isCenter: true),
      body: BlocConsumer<UniversitySettingBloc, UniversitySettingState>(
        listener: _listener,
        builder: (context, state) {
          if (state is UniversitySettingLoaded) {
            return _buildBody(context, state);
          }
          return const Center(child: BlueLoadingIndicatorWidget());
        },
      ),
    );
  }

  void _listener(BuildContext context, UniversitySettingState state) {
    if (state is UniversitySettingSaved) {
      AppSnackBar.success(context, '${state.message}로 설정되었습니다!');
      BlockingDialog.dismiss(context);
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } else if (state is UniversitySettingError) {
      if (state.message == 'already_set') {
        AppSnackBar.warn(context, '이미 설정되어있습니다.');
      } else if (state.message == 'save_error') {
        AppSnackBar.error(context, '저장 중 오류가 발생했습니다. 다시 시도해주세요!');
      }
    } else if (state is UniversitySettingLoaded && state.isProcessing) {
      BlockingDialog.show(context);
    }
  }

  Widget _buildBody(BuildContext context, UniversitySettingLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SettingHeader(
            settingTypeName: '학과',
            currentSettingName: state.currentSettingName,
          ),
          SettingSearchField(
            searchLabel: '학과 검색',
            onChanged: (query) => context
                .read<UniversitySettingBloc>()
                .add(FilterItemsEvent(query: query)),
          ),
          const SizedBox(height: 16),
          Expanded(child: _buildListView(context, state)),
        ],
      ),
    );
  }

  Widget _buildListView(BuildContext context, UniversitySettingLoaded state) {
    if (state.filteredMajors.isNotEmpty) {
      return ListView.builder(
        itemCount: state.filteredMajors.length,
        itemBuilder: (context, index) {
          final major = state.filteredMajors[index];
          return SettingListTile(
            title: major,
            onTap: () => context
                .read<UniversitySettingBloc>()
                .add(SelectItemEvent(itemName: major)),
          );
        },
      );
    }

    return ListView(
      children: state.filteredGroups.entries.map((entry) {
        return Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ExpansionTile(
            title: Text(
              entry.key,
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 19,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
            children: entry.value.keys.map((major) {
              return SettingListTile(
                title: major,
                onTap: () => context
                    .read<UniversitySettingBloc>()
                    .add(SelectItemEvent(itemName: major)),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
