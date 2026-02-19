/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/features/custom_tab/domain/failures/custom_tab_failure.dart';
import 'package:inha_notice/features/custom_tab/domain/repositories/custom_tab_repository.dart';
import 'package:inha_notice/features/custom_tab/domain/usecases/get_selected_tabs_use_case.dart';
import 'package:inha_notice/features/custom_tab/domain/usecases/save_tabs_use_case.dart';
import 'package:inha_notice/features/custom_tab/presentation/bloc/custom_tab_bloc.dart';
import 'package:inha_notice/features/custom_tab/presentation/bloc/custom_tab_event.dart';
import 'package:inha_notice/features/custom_tab/presentation/pages/custom_tab_page.dart';
import 'package:inha_notice/injection_container.dart' as di;

import '../../../support/widget_test_pump_app.dart';

class _FakeCustomTabRepository implements CustomTabRepository {
  Either<CustomTabFailure, List<String>> loadResult = const Right(['학사', '학과']);
  Either<CustomTabFailure, Unit> saveResult = const Right(unit);
  List<String> savedTabs = const [];

  @override
  Future<Either<CustomTabFailure, List<String>>> getSelectedTabs() async {
    return loadResult;
  }

  @override
  Future<Either<CustomTabFailure, Unit>> saveTabs(List<String> tabs) async {
    savedTabs = List<String>.from(tabs);
    return saveResult;
  }
}

void main() {
  group('CustomTabPage 위젯 테스트', () {
    late _FakeCustomTabRepository repository;
    late CustomTabBloc createdBloc;

    setUp(() async {
      await di.sl.reset();
      repository = _FakeCustomTabRepository();

      di.sl.registerFactory<CustomTabBloc>(() {
        createdBloc = CustomTabBloc(
          getSelectedTabsUseCase:
              GetSelectedTabsUseCase(repository: repository),
          saveTabsUseCase: SaveTabsUseCase(repository: repository),
        );
        return createdBloc;
      });
    });

    tearDown(() async {
      await di.sl.reset();
    });

    testWidgets('초기 로딩 후 선택 탭 정보를 렌더링한다', (tester) async {
      await pumpInhaApp(
        tester,
        child: const CustomTabPage(),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();

      expect(find.text('나만의 탭 설정'), findsOneWidget);
      expect(find.text('선택된 탭: 2개'), findsOneWidget);
      expect(find.text('추가 가능한 탭: 10개'), findsOneWidget);
      expect(find.text('학사'), findsWidgets);
      expect(find.text('학과'), findsWidgets);
    });

    testWidgets('변경사항 없이 저장 버튼 탭 시 경고 스낵바를 노출한다', (tester) async {
      await pumpInhaApp(
        tester,
        child: const CustomTabPage(),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('☑️'));
      await tester.pump();

      expect(find.text('변경사항이 없어요.'), findsOneWidget);
    });

    testWidgets('탭 변경 후 저장하면 성공 스낵바를 노출한다', (tester) async {
      await pumpInhaApp(
        tester,
        child: const CustomTabPage(),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();

      createdBloc.add(const AddTabEvent(tab: '장학'));
      await tester.pumpAndSettle();

      expect(find.text('선택된 탭: 3개'), findsOneWidget);
      expect(find.text('✅'), findsOneWidget);

      await tester.tap(find.text('✅'));
      await tester.pumpAndSettle();

      expect(repository.savedTabs, contains('장학'));
      expect(find.text('저장되었어요.'), findsOneWidget);
    });
  });
}
