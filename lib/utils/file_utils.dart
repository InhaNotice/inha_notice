import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// 파일 저장 경로를 가져오는 함수
Future<String> getFilePath(String fileName) async {
  final directory = await getApplicationDocumentsDirectory(); // 앱에서 접근 가능한 기본 디렉토리 가져오기
  final storagePath = '${directory.path}/storage'; // 앱 전용 디렉토리에 "storage" 경로 추가

  // 디렉토리가 없으면 생성
  final storageDirectory = Directory(storagePath);
  if (!await storageDirectory.exists()) {
    await storageDirectory.create(recursive: true);
  }

  return '$storagePath/$fileName';
}

/// JSON 데이터를 파일에 저장하는 함수 (Pretty Print)
Future<void> saveJsonToFile(String fileName, String jsonOutput) async {
  try {
    final filePath = await getFilePath(fileName); // 파일 경로 가져오기
    final file = File(filePath);

    // JSON 데이터를 보기 좋게 포맷팅
    final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonDecode(jsonOutput));

    await file.writeAsString(prettyJson); // JSON 파일 저장
    print('JSON saved to $filePath');
  } catch (e) {
    print('Error saving file: $e');
  }
}