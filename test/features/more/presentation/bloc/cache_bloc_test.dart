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
import 'package:inha_notice/features/more/domain/failures/cache_failure.dart';
import 'package:inha_notice/features/more/domain/repositories/cache_repository.dart';
import 'package:inha_notice/features/more/domain/usecases/get_cache_size_use_case.dart';
import 'package:inha_notice/features/more/presentation/bloc/cache_bloc.dart';
import 'package:inha_notice/features/more/presentation/bloc/cache_event.dart';
import 'package:inha_notice/features/more/presentation/bloc/cache_state.dart';

class _FakeCacheRepository implements CacheRepository {
  Either<CacheFailure, String> result = const Right('0.00 MB');

  @override
  Future<Either<CacheFailure, String>> getCacheSize() async {
    return result;
  }
}

Future<void> _flushEvents([int times = 20]) async {
  for (var i = 0; i < times; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('CacheBloc 유닛 테스트', () {
    late _FakeCacheRepository repository;
    late CacheBloc bloc;

    setUp(() {
      repository = _FakeCacheRepository();
      bloc = CacheBloc(
          getCacheSizeUseCase: GetCacheSizeUseCase(repository: repository));
    });

    tearDown(() async {
      await bloc.close();
    });

    test('LoadCacheSizeEvent 성공 시 Loading 후 Loaded 상태가 된다', () async {
      repository.result = const Right('12.34 MB');

      bloc.add(LoadCacheSizeEvent());
      await _flushEvents();

      expect(bloc.state, const CacheLoaded(cacheSize: '12.34 MB'));
    });

    test('LoadCacheSizeEvent 실패 시 Loading 후 Error 상태가 된다', () async {
      repository.result = const Left(CacheFailure.fileSystem());

      bloc.add(LoadCacheSizeEvent());
      await _flushEvents();

      expect(bloc.state, const CacheError(message: '캐시 로드 실패'));
    });
  });
}
