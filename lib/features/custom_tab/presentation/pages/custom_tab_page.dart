/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-11
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/presentation/utils/app_snack_bar.dart';
import 'package:inha_notice/core/presentation/widgets/common_app_bar_widget.dart';
import 'package:inha_notice/features/custom_tab/presentation/bloc/custom_tab_bloc.dart';
import 'package:inha_notice/features/custom_tab/presentation/bloc/custom_tab_event.dart';
import 'package:inha_notice/features/custom_tab/presentation/bloc/custom_tab_state.dart';
import 'package:inha_notice/features/custom_tab/presentation/widgets/custom_tab_available_list.dart';
import 'package:inha_notice/features/custom_tab/presentation/widgets/custom_tab_preview.dart';
import 'package:inha_notice/features/custom_tab/presentation/widgets/custom_tab_save_button.dart';
import 'package:inha_notice/features/custom_tab/presentation/widgets/custom_tab_selected_list.dart';
import 'package:inha_notice/injection_container.dart' as di;

/// **CustomTabPage**
/// 사용자는 나만의 탭 구성으로 원하는 공지사항을 볼 수 있습니다.
///
/// ### 주요 기능:
/// - 최소 1개부터 최대 7개까지의 탭 구성 가능
class CustomTabPage extends StatelessWidget {
  const CustomTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<CustomTabBloc>()..add(const LoadCustomTabEvent()),
      child: const _CustomTabPageBody(),
    );
  }
}

class _CustomTabPageBody extends StatefulWidget {
  const _CustomTabPageBody();

  @override
  State<_CustomTabPageBody> createState() => _CustomTabPageBodyState();
}

class _CustomTabPageBodyState extends State<_CustomTabPageBody> {
  final ScrollController _selectedTabsScrollController = ScrollController();

  @override
  void dispose() {
    _selectedTabsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomTabBloc, CustomTabState>(
      listener: (context, state) {
        if (state is CustomTabSaved) {
          AppSnackBar.success(context, '저장되었어요.');
        } else if (state is CustomTabError) {
          AppSnackBar.error(context, '문제가 발생하였어요.');
        }
      },
      buildWhen: (previous, current) => current is! CustomTabSaved,
      builder: (context, state) {
        final bool hasChanges =
            state is CustomTabLoaded ? state.hasChanges : false;

        return Scaffold(
          appBar: CommonAppBarWidget(
            title: '나만의 탭 설정',
            titleSize: 20,
            isCenter: true,
            actions: [
              CustomTabSaveButton(
                hasChanges: hasChanges,
                onSave: () async {
                  context.read<CustomTabBloc>().add(const SaveTabsEvent());
                },
              )
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CustomTabState state) {
    if (state is CustomTabLoading || state is CustomTabInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is! CustomTabLoaded) {
      return const SizedBox.shrink();
    }

    final selectedTabs = state.selectedTabs;
    final availableTabs = state.availableTabs;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CustomTabPreview(selectedTabs: selectedTabs),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '나만의 탭 설정으로 ',
                  style: TextStyle(
                      fontFamily: AppFont.pretendard.family,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).defaultThemedTextColor),
                ),
                TextSpan(
                  text: '원하는 공지사항만',
                  style: TextStyle(
                      fontFamily: AppFont.pretendard.family,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).defaultThemedTextColor),
                ),
                TextSpan(
                  text: ' 골라보세요!',
                  style: TextStyle(
                      fontFamily: AppFont.pretendard.family,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).defaultThemedTextColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '최소 1개부터 최대 7개까지 설정할 수 있어요!',
            style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).defaultThemedTextColor),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '설정 후, ',
                  style: TextStyle(
                      fontFamily: AppFont.pretendard.family,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).defaultThemedTextColor),
                ),
                TextSpan(
                  text: '저장버튼',
                  style: TextStyle(
                      fontFamily: AppFont.pretendard.family,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).defaultThemedTextColor),
                ),
                TextSpan(
                  text: '을 꼭 누르세요!',
                  style: TextStyle(
                      fontFamily: AppFont.pretendard.family,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).defaultThemedTextColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '선택된 탭: ${selectedTabs.length}개',
            style: TextStyle(
              fontFamily: AppFont.pretendard.family,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium?.color ??
                  Theme.of(context).defaultThemedTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomTabSelectedList(
                selectedTabs: selectedTabs,
                onReorder: (oldIndex, newIndex) {
                  context.read<CustomTabBloc>().add(
                        ReorderTabsEvent(
                            oldIndex: oldIndex, newIndex: newIndex),
                      );
                },
                onRemove: (index) {
                  if (selectedTabs.length > 1) {
                    context
                        .read<CustomTabBloc>()
                        .add(RemoveTabEvent(index: index));
                  } else {
                    AppSnackBar.warn(context, '최소 하나는 선택해야 해요.');
                  }
                },
                scrollController: _selectedTabsScrollController,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '추가 가능한 탭: ${availableTabs.length}개',
            style: TextStyle(
              fontFamily: AppFont.pretendard.family,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium?.color ??
                  Theme.of(context).defaultThemedTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomTabAvailableList(
                availableTabs: availableTabs,
                onAdd: (tab) {
                  if (selectedTabs.length < 7) {
                    context.read<CustomTabBloc>().add(AddTabEvent(tab: tab));
                  } else {
                    AppSnackBar.warn(context, '최대 개수를 넘어갈 수 없어요.');
                  }
                },
                scrollController: _selectedTabsScrollController,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
