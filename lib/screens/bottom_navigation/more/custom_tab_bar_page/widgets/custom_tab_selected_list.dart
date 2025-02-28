/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-28
 */
import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/screens/bottom_navigation/more/custom_tab_bar_page/widgets/base_custom_tab_list.dart';
import 'package:inha_notice/themes/theme.dart';

/// **CustomTabSelectedList**
/// 현재 선택된 탭 리스트를 출력합니다.
/// ReorderableListView를 사용하여 순서를 변경할 수 있음.
class CustomTabSelectedList extends BaseCustomTabList {
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(int index) onRemove;

  const CustomTabSelectedList({
    super.key,
    required List<String> selectedTabs,
    required this.onReorder,
    required this.onRemove,
    required super.scrollController,
  }) : super(tabs: selectedTabs);

  @override
  BaseCustomTabListState createState() => _CustomTabSelectedListState();
}

class _CustomTabSelectedListState
    extends BaseCustomTabListState<CustomTabSelectedList> {
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
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () => widget.onRemove(index),
        ),
      ],
    );
  }

  @override
  Widget buildListWidget(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: widget.tabs.length,
      onReorder: widget.onReorder,
      proxyDecorator: (child, index, animation) {
        return Material(
          elevation: 2.0,
          color: Theme.of(context).dragFeedbackBackground,
          child: child,
        );
      },
      itemBuilder: (context, index) {
        final tab = widget.tabs[index];
        return ListTile(
          key: ValueKey(tab),
          leading: ReorderableDragStartListener(
            index: index,
            child: const Icon(Icons.drag_handle),
          ),
          title: Text(
            tab,
            style: TextStyle(
              fontFamily: Font.kDefaultFont,
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
