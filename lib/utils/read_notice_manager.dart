import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ReadNoticeManager {
  static const String fileName = 'read_notices.json';

  static Set<String> _cachedReadIds = {};

  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/storage/$fileName');
  }

  static Future<Set<String>> loadReadNotices() async {
    if (_cachedReadIds.isNotEmpty) {
      return _cachedReadIds;
    }

    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final ids = jsonDecode(content) as List<dynamic>;
        _cachedReadIds = ids.map((e) => e.toString()).toSet();
      }
    } catch (e) {
      print('Error loading read notices: $e');
    }
    return _cachedReadIds;
  }

  static Future<void> saveReadNotices(Set<String> readIds) async {
    try {
      _cachedReadIds = readIds;
      final file = await _getFile();
      final content = jsonEncode(readIds.toList());
      await file.writeAsString(content);
    } catch (e) {
      print('Error saving read notices: $e');
    }
  }
}