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
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/features/custom_tab/presentation/widgets/base_custom_tab_list.dart';

/// **CustomTabAvailableList**
/// 커스텀 된 추가 가능한 탭 리스트를 출력합니다.
/// 일반 ListView를 사용하며, 탭 추가 버튼을 포함.
class CustomTabAvailableList extends BaseCustomTabList {
  final void Function(String tab) onAdd;

  const CustomTabAvailableList({
    super.key,
    required List<String> availableTabs,
    required this.onAdd,
    required super.scrollController,
  }) : super(tabs: availableTabs);

  @override
  BaseCustomTabListState createState() => _CustomTabAvailableListState();
}

class _CustomTabAvailableListState
    extends BaseCustomTabListState<CustomTabAvailableList> {
  @override
  Widget buildTrailing(BuildContext context, String tab, int index) {
    final bool arrowVisible = showArrow(tab);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (arrowVisible)
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () => handleToNavigate(tab),
          ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => widget.onAdd(tab),
        ),
      ],
    );
  }

  @override
  Widget buildListWidget(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      primary: false,
      itemCount: widget.tabs.length,
      itemBuilder: (context, index) {
        final tab = widget.tabs[index];
        return ListTile(
          title: Text(
            tab,
            style: TextStyle(
              fontFamily: AppFont.pretendard.family,
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).textTheme.bodyMedium?.color ??
                  Theme.of(context).defaultThemedTextColor,
            ),
          ),
          trailing: buildTrailing(context, tab, index),
        );
      },
    );
  }
}
