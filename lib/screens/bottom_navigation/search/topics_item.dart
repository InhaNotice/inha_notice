import 'package:flutter/material.dart';
import 'package:inha_notice/screens/bottom_navigation/search/search_result_page.dart';

class TopicsItem extends StatelessWidget {
  final int rank;
  final Map<String, dynamic> topic;
  final Animation<double> animation;

  const TopicsItem({
    super.key,
    required this.topic,
    required this.rank,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultPage(query: topic['text'] ?? ''),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            // 순위 출력
            Text(
              '$rank',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            // 검색어에만 회전 효과 적용
            Expanded(
              child: Text(
                topic['text'] ?? 'N/A',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
            // 상승/하락 아이콘 및 값 출력
            if (topic['updown'] == 'U')
              Row(
                children: [
                  const Icon(Icons.arrow_upward, color: Colors.red, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    topic['count'] ?? '0', // 상승 수치
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            if (topic['updown'] == 'D')
              Row(
                children: [
                  const Icon(Icons.arrow_downward,
                      color: Colors.blue, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    topic['count'] ?? '0', // 하락 수치
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
