/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-03-03
 */

import 'dart:math';

import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/more/data/models/today_fortune_model.dart';

abstract class TodayFortuneLocalDataSource {
  Future<int> incrementVersionTapCount();

  Future<void> resetVersionTapCount();

  TodayFortuneModel getRandomFortune();
}

class TodayFortuneLocalDataSourceImpl implements TodayFortuneLocalDataSource {
  final SharedPrefsManager sharedPrefsManager;
  final Random random;

  TodayFortuneLocalDataSourceImpl({
    required this.sharedPrefsManager,
    Random? random,
  }) : random = random ?? Random();

  static const List<TodayFortuneModel> _fortunePool = <TodayFortuneModel>[
    TodayFortuneModel(
      emotionMessage: '지금의 불안은 뒤처짐이 아니라, 진지함의 증거예요.',
      actionMessage: '3분만 타이머 켜고 자기소개 첫 문장 다듬기',
    ),
    TodayFortuneModel(
      emotionMessage: '오늘 집중이 흐려도 괜찮아요. 다시 시작하면 됩니다.',
      actionMessage: '지원 공고 1개만 저장하고 요구역량 3개 표시하기',
    ),
    TodayFortuneModel(
      emotionMessage: '결과가 늦는 건 당신이 느려서가 아니라 과정이 길어서예요.',
      actionMessage: '포트폴리오 문장 1개를 더 짧고 명확하게 바꾸기',
    ),
    TodayFortuneModel(
      emotionMessage: '불안한 날에도 당신은 이미 충분히 애쓰고 있어요.',
      actionMessage: '3분 동안 최근 지원 공고의 핵심 키워드 3개 적기',
    ),
    TodayFortuneModel(
      emotionMessage: '오늘 흔들려도, 방향을 잃은 건 아니에요.',
      actionMessage: '면접 예상 질문 1개에 대한 답변 첫 문장만 써보기',
    ),
  ];

  @override
  Future<int> incrementVersionTapCount() async {
    final int currentTapCount = sharedPrefsManager
            .getValue<int>(SharedPrefKeys.kTodayFortuneVersionTapCount) ??
        0;
    final int nextTapCount = currentTapCount + 1;

    await sharedPrefsManager.setValue<int>(
      SharedPrefKeys.kTodayFortuneVersionTapCount,
      nextTapCount,
    );

    return nextTapCount;
  }

  @override
  Future<void> resetVersionTapCount() async {
    await sharedPrefsManager.setValue<int>(
      SharedPrefKeys.kTodayFortuneVersionTapCount,
      0,
    );
  }

  @override
  TodayFortuneModel getRandomFortune() {
    if (_fortunePool.isEmpty) {
      throw StateError('TodayFortune message pool is empty.');
    }

    final int selectedIndex = random.nextInt(_fortunePool.length);
    return _fortunePool[selectedIndex];
  }
}
