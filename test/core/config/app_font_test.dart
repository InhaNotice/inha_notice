import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/config/app_font.dart';

void main() {
  group('AppFont 유닛 테스트', () {
    test('각 폰트 enum이 기대한 family 값을 가진다', () {
      expect(AppFont.pretendard.family, 'Pretendard');
      expect(AppFont.tossFaceFontMac.family, 'TossFaceFontMac');
      expect(AppFont.nanumGothic.family, 'NanumGothic');
    });

    test('폰트 family 값은 중복되지 않는다', () {
      final families = AppFont.values.map((font) => font.family).toList();
      expect(families.toSet().length, families.length);
    });
  });
}
