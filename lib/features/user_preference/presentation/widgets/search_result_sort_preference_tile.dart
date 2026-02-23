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
import 'package:inha_notice/core/presentation/widgets/platform_selection_dialog.dart';
import 'package:inha_notice/features/user_preference/domain/entities/search_result_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/presentation/bloc/user_preference_bloc.dart';
import 'package:inha_notice/features/user_preference/presentation/bloc/user_preference_event.dart';

class SearchResultSortPreferenceTile extends StatelessWidget {
  final SearchResultDefaultSortType currentType;

  const SearchResultSortPreferenceTile({
    super.key,
    required this.currentType,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSelectionDialog(context),
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
                Icon(Icons.search_outlined,
                    size: 20, color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 8),
                Text(
                  '검색 결과',
                  style: TextStyle(
                    fontFamily: AppFont.pretendard.family,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).defaultThemedTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Text(
              currentType.displayName,
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 14,
                color: Theme.of(context).fixedGreyText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSelectionDialog(BuildContext context) {
    showPlatformSelectionDialog<SearchResultDefaultSortType>(
      context: context,
      options: SearchResultDefaultSortType.values,
      currentValue: currentType,
      getDisplayName: (type) => type.displayName,
      onSelected: (type) {
        context.read<UserPreferenceBloc>().add(
              UpdateSearchResultDefaultSortEvent(type: type),
            );
      },
    );
  }
}
