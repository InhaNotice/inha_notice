/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/features/more/domain/failures/cache_failure.dart';
import 'package:inha_notice/features/more/domain/usecases/get_cache_size_use_case.dart';
import 'package:inha_notice/features/more/presentation/bloc/cache_event.dart';
import 'package:inha_notice/features/more/presentation/bloc/cache_state.dart';

class CacheBloc extends Bloc<CacheEvent, CacheState> {
  final GetCacheSizeUseCase getCacheSizeUseCase;

  CacheBloc({required this.getCacheSizeUseCase}) : super(CacheInitial()) {
    on<LoadCacheSizeEvent>(_onLoadCacheSize);
  }

  Future<void> _onLoadCacheSize(
    LoadCacheSizeEvent event,
    Emitter<CacheState> emit,
  ) async {
    emit(CacheLoading());

    final Either<CacheFailure, String> result = await getCacheSizeUseCase();

    result.fold(
      (failure) => emit(CacheError(message: '캐시 로드 실패')),
      (size) => emit(CacheLoaded(cacheSize: size)),
    );
  }
}
