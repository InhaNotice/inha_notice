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
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/presentation/widgets/platform_confirmation_dialog.dart';

import '../../../support/widget_test_pump_app.dart';

void main() {
  group('showPlatformConfirmationDialog 테스트', () {
    testWidgets('제목과 내용이 표시된다', (tester) async {
      await pumpInhaApp(
        tester,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showPlatformConfirmationDialog(
                context: context,
                title: '테스트 제목',
                content: '테스트 내용입니다.',
              );
            },
            child: const Text('다이얼로그 열기'),
          ),
        ),
      );

      await tester.tap(find.text('다이얼로그 열기'));
      await tester.pumpAndSettle();

      // 제목과 내용이 표시되는지 확인
      expect(find.text('테스트 제목'), findsOneWidget);
      expect(find.text('테스트 내용입니다.'), findsOneWidget);
    });

    testWidgets('기본 버튼 텍스트가 표시된다', (tester) async {
      await pumpInhaApp(
        tester,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showPlatformConfirmationDialog(
                context: context,
                title: '테스트',
                content: '내용',
              );
            },
            child: const Text('다이얼로그 열기'),
          ),
        ),
      );

      await tester.tap(find.text('다이얼로그 열기'));
      await tester.pumpAndSettle();

      // 기본 버튼 텍스트 확인
      expect(find.text('확인'), findsOneWidget);
      expect(find.text('취소'), findsOneWidget);
    });

    testWidgets('커스텀 버튼 텍스트가 표시된다', (tester) async {
      await pumpInhaApp(
        tester,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showPlatformConfirmationDialog(
                context: context,
                title: '테스트',
                content: '내용',
                confirmText: '삭제',
                cancelText: '아니오',
              );
            },
            child: const Text('다이얼로그 열기'),
          ),
        ),
      );

      await tester.tap(find.text('다이얼로그 열기'));
      await tester.pumpAndSettle();

      // 커스텀 버튼 텍스트 확인
      expect(find.text('삭제'), findsOneWidget);
      expect(find.text('아니오'), findsOneWidget);
    });

    testWidgets('확인 버튼 클릭 시 onConfirm 콜백이 호출된다', (tester) async {
      bool confirmed = false;

      await pumpInhaApp(
        tester,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showPlatformConfirmationDialog(
                context: context,
                title: '테스트',
                content: '내용',
                onConfirm: () {
                  confirmed = true;
                },
              );
            },
            child: const Text('다이얼로그 열기'),
          ),
        ),
      );

      await tester.tap(find.text('다이얼로그 열기'));
      await tester.pumpAndSettle();

      // 확인 버튼 클릭
      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();

      // 콜백이 호출되었는지 확인
      expect(confirmed, true);
    });

    testWidgets('취소 버튼 클릭 시 onCancel 콜백이 호출된다', (tester) async {
      bool cancelled = false;

      await pumpInhaApp(
        tester,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showPlatformConfirmationDialog(
                context: context,
                title: '테스트',
                content: '내용',
                onCancel: () {
                  cancelled = true;
                },
              );
            },
            child: const Text('다이얼로그 열기'),
          ),
        ),
      );

      await tester.tap(find.text('다이얼로그 열기'));
      await tester.pumpAndSettle();

      // 취소 버튼 클릭
      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();

      // 콜백이 호출되었는지 확인
      expect(cancelled, true);
    });

    testWidgets('확인 버튼 클릭 후 다이얼로그가 닫힌다', (tester) async {
      await pumpInhaApp(
        tester,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showPlatformConfirmationDialog(
                context: context,
                title: '테스트',
                content: '내용',
              );
            },
            child: const Text('다이얼로그 열기'),
          ),
        ),
      );

      // 다이얼로그 열기
      await tester.tap(find.text('다이얼로그 열기'));
      await tester.pumpAndSettle();

      // 확인 버튼 클릭
      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();

      // 다이얼로그가 닫혔는지 확인
      expect(find.text('테스트'), findsNothing);
      expect(find.text('내용'), findsNothing);
    });

    testWidgets('취소 버튼 클릭 후 다이얼로그가 닫힌다', (tester) async {
      await pumpInhaApp(
        tester,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showPlatformConfirmationDialog(
                context: context,
                title: '테스트',
                content: '내용',
              );
            },
            child: const Text('다이얼로그 열기'),
          ),
        ),
      );

      // 다이얼로그 열기
      await tester.tap(find.text('다이얼로그 열기'));
      await tester.pumpAndSettle();

      // 취소 버튼 클릭
      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();

      // 다이얼로그가 닫혔는지 확인
      expect(find.text('테스트'), findsNothing);
      expect(find.text('내용'), findsNothing);
    });

    testWidgets('isDestructive 옵션이 적용된다', (tester) async {
      await pumpInhaApp(
        tester,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showPlatformConfirmationDialog(
                context: context,
                title: '삭제 확인',
                content: '정말 삭제하시겠습니까?',
                confirmText: '삭제',
                isDestructive: true,
              );
            },
            child: const Text('다이얼로그 열기'),
          ),
        ),
      );

      await tester.tap(find.text('다이얼로그 열기'));
      await tester.pumpAndSettle();

      // 제목과 버튼이 표시되는지 확인
      expect(find.text('삭제 확인'), findsOneWidget);
      expect(find.text('삭제'), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('콜백 없이도 정상 작동한다', (tester) async {
      await pumpInhaApp(
        tester,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showPlatformConfirmationDialog(
                context: context,
                title: '테스트',
                content: '내용',
                // onConfirm, onCancel 없음
              );
            },
            child: const Text('다이얼로그 열기'),
          ),
        ),
      );

      await tester.tap(find.text('다이얼로그 열기'));
      await tester.pumpAndSettle();

      // 확인 버튼 클릭 (에러 없이 작동해야 함)
      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();

      // 다이얼로그가 닫혔는지 확인
      expect(find.text('테스트'), findsNothing);
    });

    testWidgets('긴 내용도 올바르게 표시된다', (tester) async {
      final longContent = '이것은 매우 긴 내용입니다. ' * 10;

      await pumpInhaApp(
        tester,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showPlatformConfirmationDialog(
                context: context,
                title: '긴 내용 테스트',
                content: longContent,
              );
            },
            child: const Text('다이얼로그 열기'),
          ),
        ),
      );

      await tester.tap(find.text('다이얼로그 열기'));
      await tester.pumpAndSettle();

      // 긴 내용이 표시되는지 확인
      expect(find.text('긴 내용 테스트'), findsOneWidget);
      expect(find.textContaining('이것은 매우 긴 내용입니다.'), findsOneWidget);
    });
  });
}
