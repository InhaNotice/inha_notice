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
import 'package:inha_notice/l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookmarkRefreshHeaderWidget extends StatelessWidget {
  const BookmarkRefreshHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ClassicHeader(
      idleText: l10n.bookmarkRefreshIdle,
      releaseText: l10n.bookmarkRefreshRelease,
      refreshingText: l10n.bookmarkRefreshRefreshing,
      completeText: l10n.bookmarkRefreshComplete,
    );
  }
}
