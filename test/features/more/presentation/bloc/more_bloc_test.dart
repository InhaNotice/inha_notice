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
import 'package:inha_notice/features/more/domain/entities/more_configuration_entity.dart';
import 'package:inha_notice/features/more/domain/failures/more_failure.dart';
import 'package:inha_notice/features/more/domain/repositories/more_repository.dart';
import 'package:inha_notice/features/more/domain/usecases/get_web_urls_use_case.dart';
import 'package:inha_notice/features/more/presentation/bloc/more_bloc.dart';
import 'package:inha_notice/features/more/presentation/bloc/more_event.dart';
import 'package:inha_notice/features/more/presentation/bloc/more_state.dart';

class _FakeMoreRepository implements MoreRepository {
  Either<MoreFailure, MoreConfigurationEntity> result = const Left(
    MoreFailure.configuration(),
  );

  @override
  Future<Either<MoreFailure, MoreConfigurationEntity>> getWebUrls() async {
    return result;
  }
}

Future<void> _flushEvents([int times = 20]) async {
  for (var i = 0; i < times; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('MoreBloc 유닛 테스트', () {
    late _FakeMoreRepository repository;
    late MoreBloc bloc;

    setUp(() {
      repository = _FakeMoreRepository();
      bloc = MoreBloc(
          getWebUrlsUseCase: GetWebUrlsUseCase(repository: repository));
    });

    tearDown(() async {
      await bloc.close();
    });

    test('LoadWebUrlsEvent 성공 시 Loading 후 Loaded 상태가 된다', () async {
      repository.result = const Right(MoreConfigurationEntity(
        appVersion: '1.0.0',
        featuresUrl: 'https://a.com/features',
        personalInformationUrl: 'https://a.com/privacy',
        termsAndConditionsOfServiceUrl: 'https://a.com/terms',
        introduceAppUrl: 'https://a.com/intro',
        questionsAndAnswersUrl: 'https://a.com/qna',
      ));

      bloc.add(LoadWebUrlsEvent());
      await _flushEvents();

      expect(bloc.state, isA<MoreLoaded>());
      final loaded = bloc.state as MoreLoaded;
      expect(loaded.webUrls.appVersion, '1.0.0');
    });

    test('LoadWebUrlsEvent 실패 시 Loading 후 Error 상태가 된다', () async {
      repository.result = const Left(MoreFailure.configuration());

      bloc.add(LoadWebUrlsEvent());
      await _flushEvents();

      expect(bloc.state, const MoreError(message: '설정 정보를 불러오는데 실패했습니다.'));
    });
  });
}
