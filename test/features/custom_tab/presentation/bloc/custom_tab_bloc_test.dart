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
import 'package:inha_notice/features/custom_tab/presentation/bloc/custom_tab_state.dart';

class _FakeCustomTabRepository implements CustomTabRepository {
  Either<CustomTabFailure, List<String>> getSelectedTabsResult =
      const Right(['학사', '학과']);
  Either<CustomTabFailure, Unit> saveTabsResult = const Right(unit);
  List<String>? lastSavedTabs;

  @override
  Future<Either<CustomTabFailure, List<String>>> getSelectedTabs() async {
    return getSelectedTabsResult;
  }

  @override
  Future<Either<CustomTabFailure, Unit>> saveTabs(List<String> tabs) async {
    lastSavedTabs = List.from(tabs);
    return saveTabsResult;
  }
}

Future<void> _flushEvents([int times = 20]) async {
  for (var i = 0; i < times; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('CustomTabBloc 유닛 테스트', () {
    late _FakeCustomTabRepository repository;
    late CustomTabBloc bloc;

    setUp(() {
      repository = _FakeCustomTabRepository();
      bloc = CustomTabBloc(
        getSelectedTabsUseCase: GetSelectedTabsUseCase(repository: repository),
        saveTabsUseCase: SaveTabsUseCase(repository: repository),
      );
    });

    tearDown(() async {
      await bloc.close();
    });

    test('LoadCustomTabEvent 성공 시 Loading 후 Loaded 상태가 된다', () async {
      final emitted = <CustomTabState>[];
      final sub = bloc.stream.listen(emitted.add);

      bloc.add(const LoadCustomTabEvent());
      await _flushEvents();

      await sub.cancel();

      expect(emitted[0], isA<CustomTabLoading>());
      final loaded = emitted[1] as CustomTabLoaded;
      expect(loaded.selectedTabs, ['학사', '학과']);
      expect(loaded.hasChanges, isFalse);
    });

    test('AddTabEvent는 탭을 추가하고 hasChanges를 true로 만든다', () async {
      bloc.add(const LoadCustomTabEvent());
      await _flushEvents();

      bloc.add(const AddTabEvent(tab: '장학'));
      await _flushEvents();

      final state = bloc.state as CustomTabLoaded;
      expect(state.selectedTabs, ['학사', '학과', '장학']);
      expect(state.availableTabs.contains('장학'), isFalse);
      expect(state.hasChanges, isTrue);
    });

    test('선택 탭이 7개면 AddTabEvent를 무시한다', () async {
      repository.getSelectedTabsResult =
          const Right(['학사', '학과', '장학', '모집/채용', '정석', '국제처', 'SW중심대학사업단']);
      bloc.add(const LoadCustomTabEvent());
      await _flushEvents();

      final before = (bloc.state as CustomTabLoaded).selectedTabs;
      bloc.add(const AddTabEvent(tab: '단과대'));
      await _flushEvents();

      final after = (bloc.state as CustomTabLoaded).selectedTabs;
      expect(after, before);
    });

    test('선택 탭이 1개면 RemoveTabEvent를 무시한다', () async {
      repository.getSelectedTabsResult = const Right(['학사']);
      bloc.add(const LoadCustomTabEvent());
      await _flushEvents();

      bloc.add(const RemoveTabEvent(index: 0));
      await _flushEvents();

      final state = bloc.state as CustomTabLoaded;
      expect(state.selectedTabs, ['학사']);
      expect(state.hasChanges, isFalse);
    });

    test('ReorderTabsEvent는 인덱스 규칙에 맞게 순서를 변경한다', () async {
      repository.getSelectedTabsResult = const Right(['학사', '학과', '장학']);
      bloc.add(const LoadCustomTabEvent());
      await _flushEvents();

      bloc.add(const ReorderTabsEvent(oldIndex: 0, newIndex: 3));
      await _flushEvents();

      final state = bloc.state as CustomTabLoaded;
      expect(state.selectedTabs, ['학과', '장학', '학사']);
      expect(state.hasChanges, isTrue);
    });

    test('SaveTabsEvent 성공 시 Saved 후 Loaded 상태로 복귀한다', () async {
      final emitted = <CustomTabState>[];
      final sub = bloc.stream.listen(emitted.add);

      bloc.add(const LoadCustomTabEvent());
      await _flushEvents();
      bloc.add(const AddTabEvent(tab: '장학'));
      await _flushEvents();
      bloc.add(const SaveTabsEvent());
      await _flushEvents();

      await sub.cancel();

      expect(repository.lastSavedTabs, ['학사', '학과', '장학']);
      expect(emitted.whereType<CustomTabSaved>().length, 1);
      expect(bloc.state, isA<CustomTabLoaded>());
      expect((bloc.state as CustomTabLoaded).hasChanges, isFalse);
    });

    test('LoadCustomTabEvent 실패 시 Error 상태가 된다', () async {
      repository.getSelectedTabsResult =
          const Left(CustomTabFailure.loadTabs('불러오기 실패'));

      bloc.add(const LoadCustomTabEvent());
      await _flushEvents();

      expect(bloc.state, const CustomTabError(message: '불러오기 실패'));
    });

    test('SaveTabsEvent 실패 시 Error 상태가 된다', () async {
      repository.saveTabsResult =
          const Left(CustomTabFailure.saveTabs('저장 실패'));

      bloc.add(const LoadCustomTabEvent());
      await _flushEvents();
      bloc.add(const SaveTabsEvent());
      await _flushEvents();

      expect(bloc.state, const CustomTabError(message: '저장 실패'));
    });
  });
}
