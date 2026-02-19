import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/features/custom_tab/domain/failures/custom_tab_failure.dart';
import 'package:inha_notice/features/custom_tab/domain/repositories/custom_tab_repository.dart';
import 'package:inha_notice/features/custom_tab/domain/usecases/save_tabs_use_case.dart';

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

void main() {
  group('SaveTabsUseCase 유닛 테스트', () {
    test('탭 목록을 저장소에 전달하고 성공 결과를 반환한다', () async {
      final repository = _FakeCustomTabRepository();
      final useCase = SaveTabsUseCase(repository: repository);

      final result = await useCase(['학사', '장학']);

      expect(repository.lastSavedTabs, ['학사', '장학']);
      expect(result, const Right(unit));
    });

    test('저장소 실패 결과를 그대로 반환한다', () async {
      final repository = _FakeCustomTabRepository()
        ..saveTabsResult = const Left(CustomTabFailure.saveTabs('저장 실패'));
      final useCase = SaveTabsUseCase(repository: repository);

      final result = await useCase(['학사']);

      expect(result, const Left(CustomTabFailure.saveTabs('저장 실패')));
    });
  });
}
