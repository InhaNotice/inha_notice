/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-03-03
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/features/more/presentation/bloc/today_fortune_bloc.dart';
import 'package:inha_notice/features/more/presentation/bloc/today_fortune_event.dart';
import 'package:inha_notice/features/more/presentation/bloc/today_fortune_state.dart';

class TodayFortuneBottomSheet extends StatelessWidget {
  const TodayFortuneBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? const Color(0xFFF7F8FA)
              : const Color(0xFF2A2A2A),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: BlocBuilder<TodayFortuneBloc, TodayFortuneState>(
          builder: (BuildContext context, TodayFortuneState state) {
            if (state is! TodayFortuneReady) {
              return const SizedBox.shrink();
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '오늘의 운세',
                  style: TextStyle(
                    fontFamily: AppFont.pretendard.family,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '지금 필요한 한 문장과 한 행동',
                  style: TextStyle(
                    fontFamily: AppFont.pretendard.family,
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 16),
                _FortuneCard(
                  title: '감정 카드',
                  message: state.fortune.emotionMessage,
                  accentColor: const Color(0xFF2F80ED),
                ),
                const SizedBox(height: 12),
                _FortuneCard(
                  title: '액션 카드',
                  message: state.fortune.actionMessage,
                  accentColor: const Color(0xFF2DBE8D),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      context
                          .read<TodayFortuneBloc>()
                          .add(TodayFortuneRerolledEvent());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B64F2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: TextStyle(
                        fontFamily: AppFont.pretendard.family,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('다시 뽑기'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      context
                          .read<TodayFortuneBloc>()
                          .add(TodayFortuneSheetClosedEvent());
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: TextStyle(
                        fontFamily: AppFont.pretendard.family,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('닫기'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FortuneCard extends StatelessWidget {
  final String title;
  final String message;
  final Color accentColor;

  const _FortuneCard({
    required this.title,
    required this.message,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontFamily: AppFont.pretendard.family,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(
              fontFamily: AppFont.pretendard.family,
              fontSize: 14,
              height: 1.45,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
