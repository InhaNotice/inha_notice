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
import 'package:inha_notice/features/custom_tab/domain/usecases/get_major_display_name_use_case.dart';
import 'package:inha_notice/features/university_setting/domain/entities/university_setting_type.dart';
import 'package:inha_notice/features/university_setting/domain/failures/university_setting_failure.dart';
import 'package:inha_notice/features/university_setting/domain/repositories/university_setting_repository.dart';
import 'package:inha_notice/features/university_setting/domain/usecases/get_current_setting_use_case.dart';
import 'package:inha_notice/features/university_setting/domain/usecases/save_major_setting_use_case.dart';
import 'package:inha_notice/features/university_setting/domain/usecases/save_setting_use_case.dart';
import 'package:inha_notice/features/university_setting/presentation/bloc/university_setting_bloc.dart';
import 'package:inha_notice/features/university_setting/presentation/bloc/university_setting_event.dart';
import 'package:inha_notice/features/university_setting/presentation/bloc/university_setting_state.dart';

class _FakeUniversitySettingRepository implements UniversitySettingRepository {
  Either<UniversitySettingFailure, String?> getResult = const Right(null);
  Either<UniversitySettingFailure, Unit> saveResult = const Right(unit);
  Either<UniversitySettingFailure, Unit> saveMajorResult = const Right(unit);

  String? lastSavePrefKey;
  String? lastSaveValue;
  String? lastOldKey;
  String? lastNewKey;
  String? lastMajorKeyType;

  @override
  Future<Either<UniversitySettingFailure, String?>> getCurrentSetting(
      String prefKey) async {
    return getResult;
  }

  @override
  Future<Either<UniversitySettingFailure, Unit>> saveMajorSetting(
      String? oldKey, String newKey, String majorKeyType) async {
    lastOldKey = oldKey;
    lastNewKey = newKey;
    lastMajorKeyType = majorKeyType;
    return saveMajorResult;
  }

  @override
  Future<Either<UniversitySettingFailure, Unit>> saveSetting(
      String prefKey, String value) async {
    lastSavePrefKey = prefKey;
    lastSaveValue = value;
    return saveResult;
  }
}

Future<void> _flushEvents([int times = 40]) async {
  for (var i = 0; i < times; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('UniversitySettingBloc 유닛 테스트', () {
    late _FakeUniversitySettingRepository repository;
    late UniversitySettingBloc bloc;

    setUp(() {
      repository = _FakeUniversitySettingRepository();
      bloc = UniversitySettingBloc(
        getCurrentSettingUseCase:
            GetCurrentSettingUseCase(repository: repository),
        saveSettingUseCase: SaveSettingUseCase(repository: repository),
        saveMajorSettingUseCase:
            SaveMajorSettingUseCase(repository: repository),
        getMajorDisplayNameUseCase: GetMajorDisplayNameUseCase(),
      );
    });

    tearDown(() async {
      await bloc.close();
    });

    test('LoadSettingEvent(major) 성공 시 학과 loaded 상태가 된다', () async {
      repository.getResult = const Right('CSE');

      bloc.add(const LoadSettingEvent(
        prefKey: 'major-key',
        settingType: UniversitySettingType.major,
        majorKeyType: 'major-key',
      ));
      await _flushEvents();

      expect(bloc.state, isA<UniversitySettingLoaded>());
      final loaded = bloc.state as UniversitySettingLoaded;
      expect(loaded.settingType, UniversitySettingType.major);
      expect(loaded.currentSettingKey, 'CSE');
      expect(loaded.currentSettingName, '컴퓨터공학과');
      expect(loaded.groups, isNotEmpty);
    });

    test('FilterItemsEvent(major) 검색 시 filteredMajors가 갱신된다', () async {
      repository.getResult = const Right('CSE');
      bloc.add(const LoadSettingEvent(
        prefKey: 'major-key',
        settingType: UniversitySettingType.major,
        majorKeyType: 'major-key',
      ));
      await _flushEvents();

      bloc.add(const FilterItemsEvent(query: '컴퓨터'));
      await _flushEvents();

      final loaded = bloc.state as UniversitySettingLoaded;
      expect(loaded.filteredMajors, contains('컴퓨터공학과'));
      expect(loaded.filteredGroups, isEmpty);
    });

    test('FilterItemsEvent(college) 검색 시 filteredItems가 갱신된다', () async {
      repository.getResult = const Right('SWCC');
      bloc.add(const LoadSettingEvent(
        prefKey: 'college-key',
        settingType: UniversitySettingType.college,
      ));
      await _flushEvents();

      bloc.add(const FilterItemsEvent(query: '소프트웨어'));
      await _flushEvents();

      final loaded = bloc.state as UniversitySettingLoaded;
      expect(loaded.filteredItems, contains('소프트웨어융합대학'));
    });

    test('이미 선택된 단과대를 다시 선택하면 already_set 에러를 거친다', () async {
      repository.getResult = const Right('SWCC');
      final states = <UniversitySettingState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const LoadSettingEvent(
        prefKey: 'college-key',
        settingType: UniversitySettingType.college,
      ));
      await _flushEvents();
      bloc.add(const SelectItemEvent(itemName: '소프트웨어융합대학'));
      await _flushEvents();

      expect(
        states.whereType<UniversitySettingError>().any(
              (e) => e.message == 'already_set',
            ),
        isTrue,
      );
      expect(bloc.state, isA<UniversitySettingLoaded>());

      await sub.cancel();
    });

    test('SelectItemEvent(major) 저장 성공 시 saved 상태가 된다', () async {
      repository.getResult = const Right('MECH');
      bloc.add(const LoadSettingEvent(
        prefKey: 'major-key',
        settingType: UniversitySettingType.major,
        majorKeyType: 'major-key',
      ));
      await _flushEvents();

      bloc.add(const SelectItemEvent(itemName: '컴퓨터공학과'));
      await _flushEvents();

      expect(repository.lastOldKey, 'MECH');
      expect(repository.lastNewKey, 'CSE');
      expect(repository.lastMajorKeyType, 'major-key');
      expect(bloc.state, const UniversitySettingSaved(message: '컴퓨터공학과'));
    });
  });
}
