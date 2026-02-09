/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-09
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/features/more/domain/entities/more_configuration_entity.dart';
import 'package:inha_notice/features/more/domain/failures/more_failure.dart';
import 'package:inha_notice/features/more/domain/usecases/get_web_urls_use_case.dart';
import 'package:inha_notice/features/more/presentation/bloc/more_event.dart';
import 'package:inha_notice/features/more/presentation/bloc/more_state.dart';

class MoreBloc extends Bloc<MoreEvent, MoreState> {
  final GetWebUrlsUseCase getWebUrlsUseCase;

  MoreBloc({required this.getWebUrlsUseCase}) : super(MoreInitial()) {
    on<LoadWebUrlsEvent>(_onLoadWebPageUrls);
  }

  Future<void> _onLoadWebPageUrls(
      LoadWebUrlsEvent event, Emitter<MoreState> emit) async {
    emit(MoreLoading());

    final Either<MoreFailure, MoreConfigurationEntity> result =
        await getWebUrlsUseCase();

    result.fold(
      (failure) => emit(MoreError(message: '설정 정보를 불러오는데 실패했습니다.')),
      (webUrls) => emit(MoreLoaded(webUrls: webUrls)),
    );
  }
}
