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
import 'package:inha_notice/features/notice/domain/entities/home_tab_entity.dart';
import 'package:inha_notice/features/notice/domain/failures/home_failure.dart';
import 'package:inha_notice/features/notice/domain/repositories/home_repository.dart';
import 'package:inha_notice/features/notice/domain/usecases/get_home_tabs_use case.dart';
import 'package:inha_notice/features/notice/presentation/bloc/home_bloc.dart';
import 'package:inha_notice/features/notice/presentation/bloc/home_event.dart';
import 'package:inha_notice/features/notice/presentation/bloc/home_state.dart';

class _FakeHomeRepository implements HomeRepository {
  Either<HomeFailure, List<HomeTabEntity>> result = const Right([]);

  @override
  Future<Either<HomeFailure, List<HomeTabEntity>>> getHomeTabs() async {
    return result;
  }
}

Future<void> _flushEvents([int times = 20]) async {
  for (var i = 0; i < times; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('HomeBloc 유닛 테스트', () {
    late _FakeHomeRepository repository;
    late HomeBloc bloc;

    setUp(() {
      repository = _FakeHomeRepository();
      bloc = HomeBloc(getHomeTabsUsecase: GetHomeTabsUseCase(repository));
    });

    tearDown(() async {
      await bloc.close();
    });

    test('LoadHomeTabsEvent 성공 시 HomeLoaded 상태가 된다', () async {
      repository.result = const Right([
        HomeTabEntity(noticeType: 'WHOLE', label: '학사'),
      ]);

      bloc.add(LoadHomeTabsEvent());
      await _flushEvents();

      expect(bloc.state, isA<HomeLoaded>());
      final loaded = bloc.state as HomeLoaded;
      expect(loaded.tabs.first.label, '학사');
    });

    test('LoadHomeTabsEvent 실패 시 HomeError 상태가 된다', () async {
      repository.result = const Left(HomeFailure.tabs('탭 로딩 실패'));

      bloc.add(LoadHomeTabsEvent());
      await _flushEvents();

      expect(bloc.state, isA<HomeError>());
      final error = bloc.state as HomeError;
      expect(error.message, '탭 로딩 실패');
    });
  });
}
