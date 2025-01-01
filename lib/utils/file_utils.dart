import 'dart:convert';
import 'dart:io';

/// 파일 저장 경로를 가져오는 함수
Future<String> getFilePath(String fileName) async {
  final directory = "/Users/jun/Desktop/practice_crawling/lib/storage";
  return '${directory}/$fileName';
}

/// JSON 데이터를 파일에 저장하는 함수 (Pretty Print)
Future<void> saveJsonToFile(String fileName, String jsonOutput) async {
  try {
    final filePath = await getFilePath(fileName); // 파일 경로 가져오기
    final file = File(filePath);

    // JSON을 보기 좋게 포맷팅
    final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonDecode(jsonOutput));

    await file.writeAsString(prettyJson); // 보기 좋게 포맷팅된 JSON 저장
    print('JSON saved to $filePath');
  } catch (e) {
    print('Error saving file: $e');
  }
}