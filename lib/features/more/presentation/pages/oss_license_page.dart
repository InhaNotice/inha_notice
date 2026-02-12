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
import 'package:inha_notice/core/presentation/widgets/blue_loading_indicator_widget.dart';
import 'package:inha_notice/core/presentation/widgets/common_app_bar_widget.dart';
import 'package:inha_notice/features/more/domain/entities/oss_license_category_entity.dart';
import 'package:inha_notice/features/more/presentation/bloc/oss_license_bloc.dart';
import 'package:inha_notice/features/more/presentation/bloc/oss_license_event.dart';
import 'package:inha_notice/features/more/presentation/bloc/oss_license_state.dart';
import 'package:inha_notice/features/more/presentation/widgets/more_navigation_tile.dart';
import 'package:inha_notice/features/more/presentation/widgets/more_title_tile.dart';
import 'package:inha_notice/injection_container.dart' as di;

class OssLicensePage extends StatelessWidget {
  const OssLicensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<OssLicenseBloc>()..add(LoadOssLicensesEvent()),
      child: const _OssLicensePageView(),
    );
  }
}

class _OssLicensePageView extends StatelessWidget {
  const _OssLicensePageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBarWidget(
          title: '사용된 라이선스', titleSize: 20, isCenter: true),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<OssLicenseBloc, OssLicenseState>(
        builder: (context, state) {
          if (state is OssLicenseLoading) {
            return const Center(child: BlueLoadingIndicatorWidget());
          } else if (state is OssLicenseLoaded) {
            return _buildLicenseList(state.licenses);
          } else if (state is OssLicenseError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(
                    fontFamily: AppFont.pretendard.family,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLicenseList(List<OssLicenseCategoryEntity> categories) {
    if (categories.isEmpty) {
      return const Center(child: BlueLoadingIndicatorWidget());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MoreTitleTile(text: category.categoryName, fontSize: 20),
            ...category.items.map((item) {
              return MoreNavigationTile(
                title: item.packageName,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => _buildLicenseDetail(
                          context, item.packageName, item.licenseText),
                    ),
                  );
                },
              );
            }),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Widget _buildLicenseDetail(
      BuildContext context, String packageName, String licenseText) {
    return Scaffold(
      appBar:
          CommonAppBarWidget(title: packageName, titleSize: 20, isCenter: true),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  softWrap: true,
                  licenseText,
                  style: TextStyle(
                    fontFamily: AppFont.pretendard.family,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).textTheme.bodyMedium?.color ??
                        Theme.of(context).defaultThemedTextColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
