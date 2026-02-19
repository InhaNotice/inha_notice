/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/features/more/presentation/widgets/more_title_tile.dart';

import '../../../support/widget_test_pump_app.dart';

void main() {
  group('MoreTitleTile 위젯 테스트', () {
    testWidgets('전달된 텍스트와 폰트 크기를 화면에 렌더링한다', (tester) async {
      const titleText = '설정';
      const fontSize = 20.0;

      await pumpInhaApp(
        tester,
        child: const MoreTitleTile(
          text: titleText,
          fontSize: fontSize,
        ),
      );

      expect(find.text(titleText), findsOneWidget);

      final textWidget = tester.widget<Text>(find.text(titleText));
      expect(textWidget.style?.fontSize, fontSize);
    });
  });
}
