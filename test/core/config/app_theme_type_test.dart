import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/config/app_theme_type.dart';

void main() {
  group('AppThemeType 유닛 테스트', () {
    test('각 테마 enum이 기대한 한글 텍스트를 가진다', () {
      expect(AppThemeType.system.text, '시스템 설정');
      expect(AppThemeType.light.text, '화이트');
      expect(AppThemeType.dark.text, '다크');
    });

    test('테마 enum 순서가 system-light-dark로 유지된다', () {
      expect(AppThemeType.values, [
        AppThemeType.system,
        AppThemeType.light,
        AppThemeType.dark,
      ]);
    });
  });
}
