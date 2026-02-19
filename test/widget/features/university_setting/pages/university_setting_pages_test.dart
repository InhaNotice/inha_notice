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
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/features/custom_tab/domain/usecases/get_major_display_name_use_case.dart';
import 'package:inha_notice/features/university_setting/domain/failures/university_setting_failure.dart';
import 'package:inha_notice/features/university_setting/domain/repositories/university_setting_repository.dart';
import 'package:inha_notice/features/university_setting/domain/usecases/get_current_setting_use_case.dart';
import 'package:inha_notice/features/university_setting/domain/usecases/save_major_setting_use_case.dart';
import 'package:inha_notice/features/university_setting/domain/usecases/save_setting_use_case.dart';
import 'package:inha_notice/features/university_setting/presentation/bloc/university_setting_bloc.dart';
import 'package:inha_notice/features/university_setting/presentation/bloc/university_setting_event.dart';
import 'package:inha_notice/features/university_setting/presentation/pages/college_setting_page.dart';
import 'package:inha_notice/features/university_setting/presentation/pages/graduate_school_setting_page.dart';
import 'package:inha_notice/features/university_setting/presentation/pages/major_setting_page.dart';
import 'package:inha_notice/injection_container.dart' as di;

import '../../../support/widget_test_pump_app.dart';

class _FakeUniversitySettingRepository implements UniversitySettingRepository {
  final Map<String, String?> currentValues = {};
  Either<UniversitySettingFailure, Unit> saveResult = const Right(unit);
  Either<UniversitySettingFailure, Unit> saveMajorResult = const Right(unit);

  @override
  Future<Either<UniversitySettingFailure, String?>> getCurrentSetting(
      String prefKey) async {
    return Right(currentValues[prefKey]);
  }

  @override
  Future<Either<UniversitySettingFailure, Unit>> saveMajorSetting(
      String? oldKey, String newKey, String majorKeyType) async {
    currentValues[majorKeyType] = newKey;
    return saveMajorResult;
  }

  @override
  Future<Either<UniversitySettingFailure, Unit>> saveSetting(
      String prefKey, String value) async {
    currentValues[prefKey] = value;
    return saveResult;
  }
}

void main() {
  group('UniversitySetting 페이지 위젯 테스트', () {
    late _FakeUniversitySettingRepository repository;
    late UniversitySettingBloc createdBloc;

    setUp(() async {
      await di.sl.reset();
      repository = _FakeUniversitySettingRepository()
        ..currentValues[SharedPrefKeys.kGraduateSchoolKey] = 'GRAD';

      di.sl.registerFactory<UniversitySettingBloc>(() {
        createdBloc = UniversitySettingBloc(
          getCurrentSettingUseCase:
              GetCurrentSettingUseCase(repository: repository),
          saveSettingUseCase: SaveSettingUseCase(repository: repository),
          saveMajorSettingUseCase:
              SaveMajorSettingUseCase(repository: repository),
          getMajorDisplayNameUseCase: GetMajorDisplayNameUseCase(),
        );
        return createdBloc;
      });
    });

    tearDown(() async {
      await di.sl.reset();
    });

    testWidgets('CollegeSettingPage 검색 입력 시 목록이 필터링된다', (tester) async {
      await pumpInhaApp(
        tester,
        child: const CollegeSettingPage(),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '공과');
      await tester.pumpAndSettle();

      expect(find.text('단과대 검색'), findsOneWidget);
      expect(find.text('공과대학'), findsOneWidget);
      expect(find.text('자연과학대학'), findsNothing);
    });

    testWidgets('CollegeSettingPage 선택 저장 성공 시 스낵바를 노출한다', (tester) async {
      await pumpInhaApp(
        tester,
        child: const CollegeSettingPage(),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();

      createdBloc.add(const SelectItemEvent(itemName: '공과대학'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('공과대학로 설정되었습니다!'), findsOneWidget);
      expect(
          repository.currentValues[SharedPrefKeys.kCollegeKey], 'ENGCOLLEAGE');
    });

    testWidgets('GraduateSchoolSettingPage 기본 UI를 렌더링한다', (tester) async {
      await pumpInhaApp(
        tester,
        child: const GraduateSchoolSettingPage(),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();

      expect(find.text('대학원 설정'), findsOneWidget);
      expect(find.text('일반대학원'), findsWidgets);
      expect(find.text('대학원 검색'), findsOneWidget);
    });

    testWidgets('MajorSettingPage 검색 입력 시 학과 결과를 표시한다', (tester) async {
      await pumpInhaApp(
        tester,
        child: const MajorSettingPage(majorKeyType: SharedPrefKeys.kMajorKey),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '컴퓨터공학과');
      await tester.pumpAndSettle();

      final majorTileTextFinder = find.descendant(
        of: find.byType(ListTile),
        matching: find.text('컴퓨터공학과'),
      );

      expect(find.text('학과 검색'), findsOneWidget);
      expect(majorTileTextFinder, findsOneWidget);
      expect(find.text('전자공학과'), findsNothing);
    });
  });
}
