import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/config/app_theme_type.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';

import '../../support/unit_test_bootstrap.dart';

void main() {
  ensureTestBinding();

  group('SharedPrefsManager 유닛 테스트', () {
    setUp(() async {
      await resetMockPrefs();
    });

    test('loadPreferences가 SharedPreferences 값을 캐시에 로드한다', () async {
      final prefs = await seedMockPrefs({
        SharedPrefKeys.kUserThemeSetting: AppThemeType.dark.text,
        SharedPrefKeys.kAcademicNotification: true,
        SharedPrefKeys.kCustomTabList: ['home', 'bookmark'],
        SharedPrefKeys.kSubscribedTopics: ['SCHOLARSHIP', 'RECRUITMENT'],
        'CSE': true,
      });
      final manager = SharedPrefsManager(prefs);

      await manager.loadPreferences();

      expect(
        manager.getValue<String>(SharedPrefKeys.kUserThemeSetting),
        AppThemeType.dark.text,
      );
      expect(
        manager.getValue<bool>(SharedPrefKeys.kAcademicNotification),
        isTrue,
      );
      expect(manager.getValue<List<String>>(SharedPrefKeys.kCustomTabList), [
        'home',
        'bookmark',
      ]);
      expect(manager.getValue<Set<String>>(SharedPrefKeys.kSubscribedTopics), {
        'SCHOLARSHIP',
        'RECRUITMENT',
      });
      expect(manager.getValue<bool>('CSE'), isTrue);
    });

    test('setValue가 지원 타입을 저장하고 캐시를 갱신한다', () async {
      final prefs = await seedMockPrefs({
        SharedPrefKeys.kAcademicNotification: false,
        SharedPrefKeys.kUserThemeSetting: AppThemeType.system.text,
        SharedPrefKeys.kCustomTabList: <String>[],
        SharedPrefKeys.kSubscribedTopics: <String>[],
      });
      final manager = SharedPrefsManager(prefs);
      await manager.loadPreferences();

      await manager.setValue<bool>(SharedPrefKeys.kAcademicNotification, true);
      await manager.setValue<String>(
        SharedPrefKeys.kUserThemeSetting,
        AppThemeType.light.text,
      );
      await manager.setValue<List<String>>(SharedPrefKeys.kCustomTabList, [
        'news',
        'settings',
      ]);
      await manager.setValue<Set<String>>(SharedPrefKeys.kSubscribedTopics, {
        'A',
        'B',
      });

      expect(
        manager.getValue<bool>(SharedPrefKeys.kAcademicNotification),
        isTrue,
      );
      expect(
        manager.getValue<String>(SharedPrefKeys.kUserThemeSetting),
        AppThemeType.light.text,
      );
      expect(manager.getValue<List<String>>(SharedPrefKeys.kCustomTabList), [
        'news',
        'settings',
      ]);
      expect(manager.getValue<Set<String>>(SharedPrefKeys.kSubscribedTopics), {
        'A',
        'B',
      });

      expect(prefs.getBool(SharedPrefKeys.kAcademicNotification), isTrue);
      expect(
        prefs.getString(SharedPrefKeys.kUserThemeSetting),
        AppThemeType.light.text,
      );
      expect(prefs.getStringList(SharedPrefKeys.kCustomTabList), [
        'news',
        'settings',
      ]);
      expect(prefs.getStringList(SharedPrefKeys.kSubscribedTopics)?.toSet(), {
        'A',
        'B',
      });
    });

    test('setValue는 존재하지 않는 키를 저장하지 않는다', () async {
      final prefs = await seedMockPrefs({});
      final manager = SharedPrefsManager(prefs);

      await manager.setValue<bool>('unknown-key', true);

      expect(prefs.containsKey('unknown-key'), isFalse);
      expect(manager.getValue<bool>('unknown-key'), isNull);
    });

    test('getValue는 요청 타입이 다르면 null을 반환한다', () async {
      final prefs = await seedMockPrefs({
        SharedPrefKeys.kAcademicNotification: true,
      });
      final manager = SharedPrefsManager(prefs);
      await manager.loadPreferences();

      expect(
        manager.getValue<String>(SharedPrefKeys.kAcademicNotification),
        isNull,
      );
    });

    test('setMajorPreference가 선택한 학과 키 슬롯에 값을 저장한다', () async {
      final prefs = await seedMockPrefs({SharedPrefKeys.kMajorKey: 'MECH'});
      final manager = SharedPrefsManager(prefs);
      await manager.loadPreferences();

      await manager.setMajorPreference('MECH', 'CSE', SharedPrefKeys.kMajorKey);

      expect(manager.getValue<String>(SharedPrefKeys.kMajorKey), 'CSE');
      expect(prefs.getString(SharedPrefKeys.kMajorKey), 'CSE');
    });

    test('initialize는 prefs가 null이어도 초기화 후 값을 로드한다', () async {
      await seedMockPrefs({
        SharedPrefKeys.kUserThemeSetting: AppThemeType.light.text,
        SharedPrefKeys.kRecruitment: true,
      });

      final manager = SharedPrefsManager(null);

      await manager.initialize();

      expect(
        manager.getValue<String>(SharedPrefKeys.kUserThemeSetting),
        AppThemeType.light.text,
      );
      expect(manager.getValue<bool>(SharedPrefKeys.kRecruitment), isTrue);
    });
  });
}
