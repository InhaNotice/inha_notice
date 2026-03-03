# 인하공지 영문 버전 지원 구현 진행 상황

**작성일**: 2026-03-03
**브랜치**: `feat/#86/english`
**세션**: 1/3 (예상)

---

## 📊 전체 진행률: 35% (Phase 0-5 완료)

### ✅ 완료된 작업

#### Phase 0: 다국어 인프라 구축 ✓

**파일 변경:**
- `pubspec.yaml`: `flutter_localizations` 의존성 추가, `generate: true` 설정
- `l10n.yaml`: 새로 생성 (ARB 파일 경로 및 설정)
- `lib/l10n/app_ko.arb`: 한글 번역 템플릿 생성 (초기 4개 키)
- `lib/l10n/app_en.arb`: 영문 번역 생성 (초기 4개 키)

**검증:**
```bash
flutter gen-l10n  # 성공
```

**초기 ARB 키:**
```json
{
  "appName": "인하공지" / "Inha Notice",
  "commonConfirm": "확인" / "Confirm",
  "commonCancel": "취소" / "Cancel"
}
```

---

#### Phase 1: Domain Layer 구현 ✓

**새로 생성된 파일:**
- `lib/core/config/app_language_type.dart`
  - `AppLanguageType` enum (korean, english)
  - `fromValue()` 정적 메서드
  - `toLocale()` 변환 메서드
  - 향후 일본어 등 확장 가능한 구조

**수정된 파일:**
- `lib/features/user_preference/domain/entities/user_preference_entity.dart`
  - `languagePreference` 필드 추가
  - `copyWith()` 메서드 추가
  - `props`에 languagePreference 포함

**주요 코드:**
```dart
enum AppLanguageType {
  korean('한국어', 'ko'),
  english('English', 'en');

  final String text;
  final String value;

  const AppLanguageType(this.text, this.value);

  static AppLanguageType fromValue(String value) { ... }
  Locale toLocale() => Locale(value);
}
```

---

#### Phase 2: Data Layer 구현 ✓

**수정된 파일:**
- `lib/core/keys/shared_pref_keys.dart`
  - `kLanguagePreference = 'language-preference'` 추가

- `lib/features/user_preference/data/datasources/user_preference_local_data_source.dart`
  - `import 'dart:ui'` 추가 (PlatformDispatcher)
  - `_getSystemLanguage()` 메서드 구현
  - `getUserPreferences()`에 언어 로드 로직 추가
  - `saveUserPreferences()`에 언어 저장 로직 추가

**주요 로직:**
```dart
String _getSystemLanguage() {
  final systemLocale = PlatformDispatcher.instance.locale;
  if (systemLocale.languageCode == 'en') {
    return AppLanguageType.english.value;
  }
  return AppLanguageType.korean.value; // 기본값
}

// getUserPreferences()에서
final String languagePref = sharedPrefsManager
    .getValue<String>(SharedPrefKeys.kLanguagePreference) ??
    _getSystemLanguage(); // 저장된 값이 없으면 시스템 언어
```

---

#### Phase 3: Presentation Layer 구현 ✓

**새로 생성된 파일:**

1. `lib/features/user_preference/presentation/widgets/language_selection_dialog.dart`
   - iOS: `CupertinoAlertDialog`
   - Android: `AlertDialog`
   - BLoC 이벤트 발생으로 언어 변경
   - 성공/실패 스낵바 표시

2. `lib/features/user_preference/presentation/widgets/language_preference_tile.dart`
   - `ThemePreferenceTile` 패턴 참고
   - BlocBuilder로 현재 언어 표시
   - 탭 시 다이얼로그 표시

**수정된 파일:**

1. `lib/features/user_preference/presentation/bloc/user_preference_event.dart`
   ```dart
   class ChangeLanguagePreferenceEvent extends UserPreferenceEvent {
     final AppLanguageType language;
     const ChangeLanguagePreferenceEvent({required this.language});
   }
   ```

2. `lib/features/user_preference/presentation/bloc/user_preference_bloc.dart`
   - `ValueNotifier<Locale>? localeNotifier` 필드 추가
   - `on<ChangeLanguagePreferenceEvent>(_onChangeLanguage)` 핸들러 추가
   - 기존 핸들러들을 `copyWith()` 사용하도록 리팩토링
   - 언어 변경 시 `localeNotifier.value` 업데이트로 전체 앱 리빌드

3. `lib/features/user_preference/presentation/pages/user_preference_page.dart`
   - "언어 설정" 섹션 추가 (녹색 아이콘)
   - `LanguagePreferenceTile` 위젯 배치
   - 기존 "화면 설정", "기본 정렬 설정" 섹션과 동일한 디자인

**UI 구조:**
```
UserPreferencePage
├─ 화면 설정 (파란색)
│  └─ 나만의 탭
├─ 언어 설정 (녹색) ← 새로 추가
│  └─ 언어 (LanguagePreferenceTile)
└─ 기본 정렬 설정 (파란색)
   ├─ 공지사항 게시판
   ├─ 북마크
   └─ 검색결과
```

---

#### Phase 4: 의존성 주입 ✓

**수정된 파일:**
- `lib/injection_container.dart`
  - `import 'package:inha_notice/main.dart' show localeNotifier` 추가
  - `UserPreferenceBloc` 생성 시 `localeNotifier: localeNotifier` 전달

**변경 전:**
```dart
sl.registerFactory(() => UserPreferenceBloc(
    getUserPreferencesUseCase: sl(),
    updateUserPreferencesUseCase: sl()));
```

**변경 후:**
```dart
sl.registerFactory(() => UserPreferenceBloc(
    getUserPreferencesUseCase: sl(),
    updateUserPreferencesUseCase: sl(),
    localeNotifier: localeNotifier)); // 글로벌 notifier 전달
```

---

#### Phase 5: Main.dart 통합 ✓

**수정된 파일:**
- `lib/main.dart`

**주요 변경사항:**

1. **Import 추가:**
   ```dart
   import 'dart:ui';
   import 'package:flutter_localizations/flutter_localizations.dart';
   import 'package:inha_notice/core/config/app_language_type.dart';
   import 'package:inha_notice/l10n/app_localizations.dart';
   ```

2. **전역 Notifier 생성:**
   ```dart
   final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('ko'));
   ```

3. **언어 설정 초기화 함수:**
   ```dart
   Future<void> _initializeLanguageSetting() async {
     try {
       final String? languagePref = di.sl<SharedPrefsManager>()
           .getValue<String>(SharedPrefKeys.kLanguagePreference);

       if (languagePref != null) {
         localeNotifier.value = AppLanguageType.fromValue(languagePref).toLocale();
       } else {
         localeNotifier.value = _getSystemLocale(); // 첫 실행 시 시스템 언어
       }
     } catch (e) {
       localeNotifier.value = _getSystemLocale();
     }
   }

   Locale _getSystemLocale() {
     final systemLocale = PlatformDispatcher.instance.locale;
     if (systemLocale.languageCode == 'en') {
       return const Locale('en');
     }
     return const Locale('ko');
   }
   ```

4. **MaterialApp 설정:**
   ```dart
   // main() 함수에서 호출
   await _initializeLanguageSetting();

   // Widget 트리
   ValueListenableBuilder<ThemeMode>(
     valueListenable: themeModeNotifier,
     builder: (context, themeMode, child) {
       return ValueListenableBuilder<Locale>(
         valueListenable: localeNotifier,
         builder: (context, locale, child) {
           return MaterialApp(
             locale: locale, // 동적 언어 변경
             localizationsDelegates: const [
               AppLocalizations.delegate,
               GlobalMaterialLocalizations.delegate,
               GlobalWidgetsLocalizations.delegate,
               GlobalCupertinoLocalizations.delegate,
             ],
             supportedLocales: const [
               Locale('ko'),
               Locale('en'),
             ],
             // ... 기존 설정
           );
         },
       );
     },
   );
   ```

---

#### 테스트 파일 수정 ✓

**수정된 파일 (총 16개):**
- Integration Tests: 2개
- Unit Tests: 14개

**변경 내용:**
- 모든 `UserPreferenceEntity` 생성자에 `languagePreference: AppLanguageType.korean` 추가
- 모든 파일에 `import 'package:inha_notice/core/config/app_language_type.dart'` 추가

**예시:**
```dart
// Before
UserPreferenceEntity(
  noticeBoardDefault: NoticeBoardDefaultType.general,
  bookmarkDefaultSort: BookmarkDefaultSortType.newest,
  searchResultDefaultSort: SearchResultDefaultSortType.rank,
)

// After
UserPreferenceEntity(
  noticeBoardDefault: NoticeBoardDefaultType.general,
  bookmarkDefaultSort: BookmarkDefaultSortType.newest,
  searchResultDefaultSort: SearchResultDefaultSortType.rank,
  languagePreference: AppLanguageType.korean, // 추가
)
```

**검증:**
```bash
flutter analyze --no-fatal-infos
# 결과: 18 issues (모두 info 레벨, 에러 0개)
```

---

## 🎯 현재 상태 검증

### ✅ 동작 확인 체크리스트

- [x] 코드 컴파일 성공 (`flutter analyze` 에러 0개)
- [x] ARB 파일 코드 생성 성공
- [x] 언어 설정 UI 추가 완료 (UserPreferencePage에 섹션 추가)
- [x] BLoC 이벤트/상태 처리 구현
- [x] SharedPreferences 저장/로드 로직
- [x] 시스템 언어 감지 로직
- [x] 전체 앱 재빌드 메커니즘 (localeNotifier)
- [x] Clean Architecture 준수

### 🧪 실제 테스트 필요 (다음 세션)

- [ ] 실제 디바이스/시뮬레이터에서 앱 실행
- [ ] "나만의 앱 설정" → "언어" 타일 표시 확인
- [ ] 언어 전환 다이얼로그 동작 확인
- [ ] 언어 변경 시 앱 재시작 없이 즉시 반영 확인
- [ ] 앱 종료 후 재시작 시 설정 유지 확인

---

## 📋 남은 작업 (Phase 6-9)

### Phase 6: 텍스트 마이그레이션 (예상 12-15시간)

**가장 큰 작업량**을 차지합니다. 전체 앱의 하드코딩된 한글 텍스트를 ARB 파일로 이동해야 합니다.

#### 작업 순서 (우선순위별)

**Priority 1: Core 공통 요소 (2시간)**
- [ ] `lib/core/presentation/utils/app_snack_bar.dart`
  - 모든 성공/경고/에러 메시지
- [ ] `lib/core/presentation/widgets/dialogs/`
  - 확인, 취소, 삭제 등 공통 버튼
  - 다이얼로그 제목/내용

**Priority 2: 주요 페이지 (5시간)**
- [ ] Home Page (`lib/features/home/`)
  - 앱바 제목, 탭 이름, 빈 상태 메시지
- [ ] Bookmark Page (`lib/features/bookmark/`)
  - 페이지 제목, 정렬 옵션, 빈 상태, 스낵바 메시지
- [ ] Search Page (`lib/features/search/`)
  - 검색 플레이스홀더, 최근 검색어, 인기 검색어, 빈 상태
- [ ] More Page (`lib/features/more/`)
  - 메뉴 항목, 섹션 제목
- [ ] User Preference Page (`lib/features/user_preference/`)
  - 섹션 제목, 설명, 타일 이름
- [ ] Notification Setting Page (`lib/features/notification_setting/`)
  - 알림 카테고리, 설명, 토글 레이블

**Priority 3: 세부 페이지 및 위젯 (3시간)**
- [ ] Notice Board Page
- [ ] Search Result Page
- [ ] Custom Tab Page
- [ ] University Setting Page
- [ ] 각종 타일 위젯들

**Priority 4: 기타 (2시간)**
- [ ] Onboarding Page
- [ ] FAQ, 서비스 이용약관 등

#### ARB 파일 키 네이밍 규칙

```
{feature}_{context}_{element}

예시:
- bookmarkPageTitle: "북마크"
- bookmarkEmptyStateMessage: "저장된 북마크가 없어요"
- bookmarkSortNewest: "최신순"
- searchInputPlaceholder: "검색어를 입력하세요"
- commonConfirm: "확인"
- commonCancel: "취소"
- messageSuccessBookmarkCleared: "모두 삭제했어요!"
```

#### 매개변수 처리 예시

**ARB 파일:**
```json
{
  "bookmarkCount": "{count}개의 북마크",
  "@bookmarkCount": {
    "placeholders": {
      "count": {"type": "int"}
    }
  }
}
```

**코드에서 사용:**
```dart
// Before
Text('${bookmarks.length}개의 북마크')

// After
Text(AppLocalizations.of(context)!.bookmarkCount(bookmarks.length))
```

#### 코드 변경 패턴

**Before:**
```dart
const CommonAppBarWidget(title: '북마크')
AppSnackBar.success(context, '모두 삭제했어요!')
```

**After:**
```dart
CommonAppBarWidget(title: AppLocalizations.of(context)!.bookmarkPageTitle)
AppSnackBar.success(context, AppLocalizations.of(context)!.messageSuccessBookmarkCleared)
```

**주의사항:**
- `const` 제거 필요 (context 사용으로 런타임 평가)
- 모든 위젯에서 `BuildContext context` 매개변수 필요

---

### Phase 7: 영문 번역 초안 (2시간)

**작업 순서:**

1. **번역 초안 작성**
   - Phase 6에서 추출한 모든 한글 텍스트의 영문 번역
   - MD 파일로 정리: `/Users/jun/.claude/plans/translation-draft.md`

2. **번역 가이드라인**
   - **톤**: Friendly, approachable (친근한 톤 유지)
   - ❌ "An error occurred" (딱딱함)
   - ✅ "Oops! Something went wrong" (친근함)

3. **검토 및 승인**
   - 사용자 검토 요청
   - 피드백 반영

4. **ARB 파일 업데이트**
   - `app_en.arb`에 번역 반영

**번역 초안 MD 파일 형식:**
```markdown
# 인하공지 영문 번역 초안

## Common (공통)
| Key | 한글 | 영문 | 비고 |
|-----|------|------|------|
| commonConfirm | 확인 | Confirm | |
| commonCancel | 취소 | Cancel | |
| commonDelete | 삭제 | Delete | |

## Bookmark Feature
| Key | 한글 | 영문 | 비고 |
|-----|------|------|------|
| bookmarkPageTitle | 북마크 | Bookmarks | |
| bookmarkEmptyStateMessage | 저장된 북마크가 없어요 | No bookmarks saved yet | 친근한 톤 |
...
```

---

### Phase 8: 테스트 및 검증 (2시간)

#### 8.1 기능 테스트
- [ ] 언어 설정 변경 (한글 ↔ 영어)
- [ ] 앱 재시작 후 설정 유지
- [ ] 시스템 언어 기본값 적용 (신규 설치)
- [ ] 모든 페이지에서 언어 변경 즉시 반영

#### 8.2 UI 테스트
- [ ] 긴 영문 텍스트 오버플로우 체크
- [ ] 버튼/타일의 레이아웃 깨짐 확인
- [ ] 다이얼로그 텍스트 정렬
- [ ] 한글/영문 폰트 렌더링 확인 (Pretendard)

#### 8.3 엣지 케이스
- [ ] 누락된 번역 키 확인 (빌드 에러 발생)
- [ ] 매개변수 치환 테스트
- [ ] 날짜/시간 포맷 (intl 패키지로 자동 처리됨)

#### 8.4 빌드 확인
```bash
flutter gen-l10n
flutter build apk --debug
flutter build ios --debug --no-codesign
flutter analyze
```

#### 8.5 ARB 파일 검증
- [ ] 모든 키가 `app_ko.arb`와 `app_en.arb`에 동일하게 존재
- [ ] 매개변수 정의가 일치
- [ ] JSON 포맷 유효성

---

### Phase 9: 최적화 및 문서화 (1시간)

#### 9.1 코드 정리
- [ ] 사용되지 않는 하드코딩 텍스트 제거
- [ ] ARB 파일 키 정렬 및 정리 (알파벳순)
- [ ] 파일 헤더 라이선스 확인

#### 9.2 문서화
- [ ] `README.md`에 다국어 지원 안내 추가
  ```markdown
  ## Supported Languages
  - 🇰🇷 한국어 (Korean)
  - 🇺🇸 English

  ### Changing Language
  1. Open the app
  2. Go to "More" → "My App Settings"
  3. Select "Language"
  4. Choose your preferred language
  ```

- [ ] 새 언어 추가 방법 가이드
  ```markdown
  ## Adding a New Language

  1. Add language to AppLanguageType enum:
     ```dart
     enum AppLanguageType {
       korean('한국어', 'ko'),
       english('English', 'en'),
       japanese('日本語', 'ja'), // New
     }
     ```

  2. Create ARB file: `lib/l10n/app_ja.arb`

  3. Translate all keys

  4. Done! The app will automatically support it.
  ```

- [ ] 번역 기여 방법 안내

---

## 📁 변경된 파일 전체 목록

### 새로 생성된 파일 (7개)

1. `l10n.yaml` - L10n 설정
2. `lib/l10n/app_ko.arb` - 한글 번역
3. `lib/l10n/app_en.arb` - 영문 번역
4. `lib/core/config/app_language_type.dart` - 언어 타입 enum
5. `lib/features/user_preference/presentation/widgets/language_selection_dialog.dart` - 언어 선택 다이얼로그
6. `lib/features/user_preference/presentation/widgets/language_preference_tile.dart` - 언어 설정 타일
7. `.inha_notice/plans/implementation-progress.md` - 이 문서

### 수정된 파일 (10개)

#### Core
1. `pubspec.yaml` - 의존성 추가
2. `lib/core/keys/shared_pref_keys.dart` - 언어 설정 키 추가
3. `lib/injection_container.dart` - localeNotifier 주입
4. `lib/main.dart` - 언어 초기화 및 MaterialApp 설정

#### Domain
5. `lib/features/user_preference/domain/entities/user_preference_entity.dart` - languagePreference 필드 추가

#### Data
6. `lib/features/user_preference/data/datasources/user_preference_local_data_source.dart` - 언어 저장/로드

#### Presentation
7. `lib/features/user_preference/presentation/bloc/user_preference_event.dart` - 언어 변경 이벤트
8. `lib/features/user_preference/presentation/bloc/user_preference_bloc.dart` - 언어 변경 로직
9. `lib/features/user_preference/presentation/pages/user_preference_page.dart` - UI 추가

### 자동 생성된 파일

10. `lib/l10n/app_localizations.dart` - Flutter gen-l10n
11. `lib/l10n/app_localizations_en.dart` - 영문 클래스
12. `lib/l10n/app_localizations_ko.dart` - 한글 클래스

### 수정된 테스트 파일 (16개)

- Integration tests: 2개
- Unit tests: 14개

---

## 🔍 주요 기술적 결정사항

### 1. Flutter 공식 다국어 시스템 선택 이유

✅ **선택됨**: `flutter_localizations` + ARB 파일
- 이미 `intl` 패키지 사용 중
- 타입 안전성 (컴파일 타임 에러)
- Clean Architecture와 자연스러운 통합
- 공식 지원으로 장기 안정성

❌ **고려했지만 선택 안 함**:
- `easy_localization`: 추가 의존성, 런타임 에러 가능성
- 커스텀 솔루션: 유지보수 부담

### 2. 언어 설정 위치

✅ **User Preference Feature에 통합**
- 일관성: "나만의 앱 설정"이 자연스러운 위치
- 기존 패턴 재사용 (정렬 설정과 동일 구조)
- Clean Architecture 유지

❌ **별도 Feature 생성 안 함**
- Over-engineering 방지
- 단순히 하나의 설정일 뿐

### 3. 실시간 언어 변경 메커니즘

✅ **ValueNotifier<Locale> 사용**
- 테마 변경과 동일한 패턴
- MaterialApp의 locale 프로퍼티로 전체 리빌드
- 앱 재시작 불필요

**동작 흐름:**
```
사용자 언어 선택
→ BLoC 이벤트 발생 (ChangeLanguagePreferenceEvent)
→ SharedPreferences 저장
→ localeNotifier.value 업데이트
→ MaterialApp 리빌드
→ 전체 UI 새로운 언어로 표시
```

### 4. 시스템 언어 감지

✅ **PlatformDispatcher.instance.locale 사용**
```dart
Locale _getSystemLocale() {
  final systemLocale = PlatformDispatcher.instance.locale;
  if (systemLocale.languageCode == 'en') {
    return const Locale('en');
  }
  return const Locale('ko'); // 기본값
}
```

**장점:**
- 첫 실행 시 사용자 편의성 향상
- 지원하지 않는 언어는 한국어로 폴백

---

## 🚨 다음 세션 시작 시 확인사항

### 1. 코드 검증

```bash
# 브랜치 확인
git branch
# feat/#86/english 확인

# 최신 상태 확인
git status

# 분석 실행
flutter analyze --no-fatal-infos
# 에러 0개 확인

# ARB 파일 코드 생성
flutter gen-l10n

# 의존성 확인
flutter pub get
```

### 2. 실제 실행 테스트

```bash
# iOS 시뮬레이터
flutter run -d "iPhone 15 Pro"

# Android 에뮬레이터
flutter run -d emulator-5554
```

**테스트 시나리오:**
1. 앱 실행
2. "더보기" → "나만의 앱 설정" 이동
3. "언어 설정" 섹션 확인
4. "언어" 타일 탭
5. 다이얼로그에서 "English" 선택
6. 앱 전체가 영어로 변경되는지 확인 (현재는 4개 키만 있으므로 대부분 한글로 보임)
7. 앱 종료 후 재시작
8. 언어 설정이 유지되는지 확인

### 3. 문제 발생 시 대응

**예상 가능한 문제:**

1. **localeNotifier를 찾을 수 없음 에러**
   - `lib/injection_container.dart`에서 `main.dart` import 확인

2. **AppLocalizations을 찾을 수 없음 에러**
   - `flutter gen-l10n` 재실행
   - `lib/l10n/app_localizations.dart` 파일 존재 확인

3. **언어 변경이 즉시 반영 안 됨**
   - `localeNotifier.value` 업데이트 로직 확인
   - MaterialApp의 `locale` 프로퍼티 바인딩 확인

---

## 📝 다음 세션 TODO

### 필수 작업

1. **Phase 6 시작: 텍스트 마이그레이션**
   - Priority 1부터 시작 (Core 공통 요소)
   - `app_snack_bar.dart`의 모든 메시지부터 변환

2. **작업 방식 결정**
   - 한 번에 모든 페이지 vs 기능별로 단계적 진행
   - 추천: 기능별 단계적 진행 (테스트 용이)

### 선택 작업

1. **UI/UX 개선 검토**
   - 언어 설정 섹션 위치 (현재: 중간)
   - 아이콘 색상 (현재: 녹색)

2. **추가 언어 지원 계획**
   - 일본어 추가 시점
   - 중국어 간체/번체 고려

---

## 💡 참고사항

### ARB 파일 위치
- 템플릿: `lib/l10n/app_ko.arb`
- 영문: `lib/l10n/app_en.arb`
- 생성된 코드: `lib/l10n/app_localizations*.dart`

### 중요한 클래스/파일
- `AppLanguageType`: `lib/core/config/app_language_type.dart`
- `localeNotifier`: `lib/main.dart` (전역)
- `UserPreferenceBloc`: DI로 localeNotifier 주입받음

### Git 커밋 가이드

```bash
# 현재까지 완료된 작업 커밋
git add .
git commit -m "feat(i18n): implement multilingual infrastructure (Phase 0-5)

- Add flutter_localizations and ARB files
- Implement AppLanguageType enum and domain entities
- Add language selection UI to UserPreferencePage
- Integrate with SharedPreferences and BLoC
- Update MaterialApp with locale support
- Fix all test files with languagePreference parameter

Related to #86"
```

---

## 📊 예상 일정

- **세션 1 (완료)**: Phase 0-5, 테스트 수정 (~6시간)
- **세션 2 (예정)**: Phase 6 텍스트 마이그레이션 (~12시간)
- **세션 3 (예정)**: Phase 7-9 번역, 테스트, 문서화 (~5시간)

**총 예상**: 20-25시간 (계획대로 진행 중)

---

## ✅ 체크리스트 (다음 세션 시작 전)

- [ ] 이 문서 읽기
- [ ] 브랜치 확인 (`feat/#86/english`)
- [ ] `flutter analyze` 실행 (에러 0개 확인)
- [ ] 실제 디바이스에서 언어 변경 테스트
- [ ] Phase 6 작업 범위 확인
- [ ] 번역 톤 가이드라인 검토
