# 인하공지 영문 버전 지원 기능 구현 계획

## Context

인하공지 앱은 현재 한국어만 지원하며, 모든 UI 텍스트가 각 파일에 하드코딩되어 있습니다. 영문 버전을 도입하여 국제 학생들도 앱을 사용할 수 있도록 하고, 향후 일본어 등 추가 언어 확장이 가능한 구조를 구축합니다.

**현재 브랜치**: `feat/#86/english`

**핵심 요구사항**:
- 한국어/영어 지원 (향후 일본어 등 확장 가능한 구조)
- 시스템 언어를 기본값으로 사용
- 전체 앱 완전 다국어화
- **architecture-agent.md의 Clean Architecture 원칙 엄격히 준수**

## 선택한 접근 방식

### Flutter 공식 다국어 시스템 사용

**선택 이유**:
1. 이미 `intl: ^0.20.1` 패키지 설치됨 (날짜 포맷팅 사용 중)
2. Clean Architecture와 자연스럽게 통합
3. 타입 안전성 보장 (컴파일 타임 에러 감지)
4. 공식 지원으로 장기 안정성
5. ARB 파일로 번역 관리 용이

**주요 구성**:
- `flutter_localizations` 패키지
- ARB(Application Resource Bundle) 번역 파일
- 코드 생성으로 타입 안전한 `AppLocalizations` 클래스 자동 생성
- `ValueNotifier<Locale>`로 실시간 언어 변경 (테마 변경 패턴 재사용)

### User Preference Feature 확장

언어 설정을 별도 Feature가 아닌 **User Preference Feature에 추가**합니다:
- 일관성: "나만의 앱 설정"에 언어 설정이 자연스럽게 포함
- 기존 패턴 재사용: 정렬 설정과 동일한 구조 (SharedPreferences 기반)
- Architecture 준수: Domain-Data-Presentation 3-layer 구조 유지

## 구현 단계

### Phase 0: 다국어 인프라 구축 (30분)

#### 0.1 pubspec.yaml 수정
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.1  # 기존

flutter:
  generate: true  # 추가
```

#### 0.2 l10n.yaml 생성
`/lib/l10n.yaml`:
```yaml
arb-dir: lib/l10n
template-arb-file: app_ko.arb
output-localization-file: app_localizations.dart
```

#### 0.3 ARB 파일 뼈대 생성
- `/lib/l10n/app_ko.arb` - 한글 (템플릿)
- `/lib/l10n/app_en.arb` - 영어

초기 테스트 키:
```json
{
  "@@locale": "ko",
  "appName": "인하공지",
  "commonConfirm": "확인",
  "commonCancel": "취소"
}
```

#### 0.4 코드 생성 확인
```bash
flutter gen-l10n
```

### Phase 1: Domain Layer 구현 (1시간)

**원칙**: 순수 Dart 코드, 외부 의존성 없음

#### 1.1 언어 타입 Enum 생성
`/lib/core/config/app_language_type.dart`:
```dart
enum AppLanguageType {
  korean('한국어', 'ko'),
  english('English', 'en');

  final String text;
  final String value;

  const AppLanguageType(this.text, this.value);

  static AppLanguageType fromValue(String value) {
    return AppLanguageType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => AppLanguageType.korean,
    );
  }

  Locale toLocale() => Locale(value);
}
```

**확장성 고려**: 일본어 추가 시 `japanese('日本語', 'ja')` 한 줄만 추가하면 됨

#### 1.2 UserPreferenceEntity 수정
`/lib/features/user_preference/domain/entities/user_preference_entity.dart`:
- `languagePreference` 필드 추가
- `copyWith` 메서드에 포함
- Equatable `props`에 추가

#### 1.3 Repository 인터페이스 수정
`/lib/features/user_preference/domain/repositories/user_preference_repository.dart`:
- 기존 메서드에 언어 설정이 UserPreferenceEntity에 포함되므로 별도 메서드 불필요

### Phase 2: Data Layer 구현 (1시간)

**원칙**: Domain 레이어에만 의존

#### 2.1 SharedPrefKeys 추가
`/lib/core/keys/shared_pref_keys.dart`:
```dart
static const String kLanguagePreference = 'language-preference';
```

#### 2.2 Local DataSource 수정
`/lib/features/user_preference/data/datasources/user_preference_local_data_source.dart`:

`getUserPreferences()`:
```dart
final String languagePref = sharedPrefsManager.getValue<String>(
  SharedPrefKeys.kLanguagePreference
) ?? _getSystemLanguage();  // 시스템 언어 기본값
```

`saveUserPreferences()`:
```dart
await sharedPrefsManager.setValue<String>(
  SharedPrefKeys.kLanguagePreference,
  entity.languagePreference.value
);
```

**시스템 언어 감지**:
```dart
String _getSystemLanguage() {
  final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
  if (systemLocale.languageCode == 'en') {
    return AppLanguageType.english.value;
  }
  return AppLanguageType.korean.value;  // 지원 안 되는 언어는 한국어
}
```

#### 2.3 Repository 구현
`/lib/features/user_preference/data/repositories/user_preference_repository_impl.dart`:
- 기존 코드 수정 없이 Entity에 언어 포함되므로 자동 처리됨

### Phase 3: Presentation Layer 구현 (2시간)

**원칙**: Domain 레이어에만 의존, Data는 DI로 주입

#### 3.1 BLoC Event 추가
`/lib/features/user_preference/presentation/bloc/user_preference_event.dart`:
```dart
class ChangeLanguagePreferenceEvent extends UserPreferenceEvent {
  final AppLanguageType language;
  const ChangeLanguagePreferenceEvent({required this.language});
}
```

#### 3.2 BLoC 로직 구현
`/lib/features/user_preference/presentation/bloc/user_preference_bloc.dart`:
```dart
on<ChangeLanguagePreferenceEvent>(_onChangeLanguage);

Future<void> _onChangeLanguage(
  ChangeLanguagePreferenceEvent event,
  Emitter<UserPreferenceState> emit,
) async {
  if (state is UserPreferenceLoaded) {
    final currentState = state as UserPreferenceLoaded;
    final updatedEntity = currentState.userPreference.copyWith(
      languagePreference: event.language,
    );

    final result = await updateUserPreferencesUseCase(updatedEntity);

    result.fold(
      (failure) => emit(UserPreferenceError(message: '언어 설정 실패')),
      (_) {
        // main.dart의 localeNotifier 업데이트
        localeNotifier.value = event.language.toLocale();
        emit(UserPreferenceLoaded(userPreference: updatedEntity));
      },
    );
  }
}
```

#### 3.3 LanguagePreferenceTile 위젯 생성
`/lib/features/user_preference/presentation/widgets/language_preference_tile.dart`:
- `ThemePreferenceTile` 패턴 참고
- 다이얼로그로 언어 선택 (Cupertino/Material)
- 선택 시 BLoC 이벤트 발생

#### 3.4 UserPreferencePage에 UI 추가
`/lib/features/user_preference/presentation/pages/user_preference_page.dart`:
- "화면 설정" 섹션 또는 별도 "언어 설정" 섹션에 추가
- `LanguagePreferenceTile` 위젯 배치

### Phase 4: 의존성 주입 (30분)

`/lib/injection_container.dart`:
- 기존 UserPreferenceBloc, UseCases, Repository 재사용
- 새로운 등록 불필요 (Entity만 확장했으므로)

### Phase 5: Main.dart 통합 (1시간)

**목표**: MaterialApp에 다국어 설정, 실시간 언어 변경 지원

#### 5.1 Locale Notifier 추가
```dart
final ValueNotifier<Locale> localeNotifier = ValueNotifier(Locale('ko'));

Future<void> _initializeLanguageSetting() async {
  try {
    final userPreference = await sl<GetUserPreferenceUseCase>()();

    userPreference.fold(
      (failure) => localeNotifier.value = _getSystemLocale(),
      (entity) => localeNotifier.value = entity.languagePreference.toLocale(),
    );
  } catch (e) {
    localeNotifier.value = _getSystemLocale();
  }
}

Locale _getSystemLocale() {
  final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
  if (systemLocale.languageCode == 'en') {
    return Locale('en');
  }
  return Locale('ko');
}
```

#### 5.2 MaterialApp 설정
```dart
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, _) {
        return ValueListenableBuilder<Locale>(
          valueListenable: localeNotifier,
          builder: (context, locale, _) {
            return MaterialApp(
              title: '인하공지',
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              // ... 기존 설정
            );
          },
        );
      },
    );
  }
}
```

### Phase 6: 텍스트 마이그레이션 (12-15시간)

**전략**: 전체 앱 완전 다국어화

#### 6.1 ARB 파일 작성

**작업 순서**:
1. 모든 페이지/위젯에서 한글 텍스트 추출
2. 체계적인 키 네이밍으로 `app_ko.arb` 작성
3. 영문 번역 초안 작성 후 **별도 MD 파일**로 정리
4. 사용자 검토 후 `app_en.arb`에 반영

**키 네이밍 규칙**:
```
{feature}_{context}_{element}
- bookmark_page_title
- search_input_placeholder
- message_success_bookmark_cleared
- common_confirm
```

**매개변수 처리**:
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

#### 6.2 우선순위별 마이그레이션

**Priority 1: Core 공통 요소** (2시간)
- `/lib/core/widgets/app_snack_bar.dart` - 모든 알림 메시지
- `/lib/core/widgets/dialogs/` - 다이얼로그 텍스트
- 공통 버튼 텍스트 (확인, 취소, 삭제 등)

**Priority 2: 주요 페이지** (5시간)
- Home Page (`/lib/features/home/`)
- Bookmark Page (`/lib/features/bookmark/`)
- Search Page (`/lib/features/search/`)
- More Page (`/lib/features/more/`)
- User Preference Page (`/lib/features/user_preference/`)
- Notification Setting Page (`/lib/features/notification_setting/`)

**Priority 3: 세부 페이지 및 위젯** (3시간)
- Notice Board Page
- Search Result Page
- Custom Tab Page
- University Setting Page
- 각종 타일 위젯들

**Priority 4: 기타** (2시간)
- Onboarding Page
- FAQ, 서비스 이용약관 등

#### 6.3 코드 변경 패턴

**Before**:
```dart
Text('북마크')
CommonAppBarWidget(title: '나만의 앱 설정')
AppSnackBar.success(context, '모두 삭제했어요!')
```

**After**:
```dart
Text(AppLocalizations.of(context)!.bookmarkPageTitle)
CommonAppBarWidget(title: AppLocalizations.of(context)!.userPreferencePageTitle)
AppSnackBar.success(context, AppLocalizations.of(context)!.messageSuccessBookmarkCleared)
```

**주의사항**:
- `const` 제거 필요 (context 사용으로 런타임 평가)
- StatelessWidget에서도 `build(BuildContext context)` 매개변수로 접근 가능

### Phase 7: 영문 번역 초안 작성 (2시간)

모든 한글 텍스트의 영문 번역을 작성하여 **별도 MD 파일**로 정리:
- `.inha_notice/plans/translation-draft.md`

**포함 내용**:
- 키 / 한글 / 영문 / 비고 (테이블 형식)
- 톤 가이드라인 (친근한 톤 유지)
- 검토 필요 항목 표시

사용자 검토 후 승인받으면 `app_en.arb`에 반영

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

### Phase 9: 최적화 및 문서화 (1시간)

#### 9.1 코드 정리
- [ ] 사용되지 않는 하드코딩 텍스트 제거
- [ ] ARB 파일 키 정렬 및 정리
- [ ] 파일 헤더 라이선스 확인

#### 9.2 문서화
- [ ] README에 다국어 지원 안내 추가
- [ ] 새 언어 추가 방법 가이드
- [ ] 번역 기여 방법 안내

## Critical Files

**Core 설정**:
- `/lib/main.dart` - MaterialApp 다국어 설정, localeNotifier 관리
- `/pubspec.yaml` - flutter_localizations 의존성, generate 설정
- `/lib/l10n.yaml` - l10n 코드 생성 설정
- `/lib/core/config/app_language_type.dart` - 언어 타입 enum
- `/lib/core/keys/shared_pref_keys.dart` - SharedPreferences 키

**Domain Layer**:
- `/lib/features/user_preference/domain/entities/user_preference_entity.dart` - 언어 설정 필드

**Data Layer**:
- `/lib/features/user_preference/data/datasources/user_preference_local_data_source.dart` - 언어 저장/로드

**Presentation Layer**:
- `/lib/features/user_preference/presentation/bloc/user_preference_bloc.dart` - 언어 변경 로직
- `/lib/features/user_preference/presentation/widgets/language_preference_tile.dart` - 언어 선택 UI
- `/lib/features/user_preference/presentation/pages/user_preference_page.dart` - UI 통합

**번역 파일**:
- `/lib/l10n/app_ko.arb` - 한글 번역 (템플릿)
- `/lib/l10n/app_en.arb` - 영문 번역

## 주요 고려사항

### Clean Architecture 준수

**architecture-agent.md 원칙 엄격히 준수**:

1. **Domain Layer** (순수 Dart, 외부 의존성 없음)
   - ✅ AppLanguageType enum만 추가
   - ✅ UserPreferenceEntity에 필드 추가
   - ✅ Repository 인터페이스는 수정 불필요

2. **Data Layer** (Domain에만 의존)
   - ✅ LocalDataSource에서 SharedPreferences 접근
   - ✅ Repository 구현체는 Domain 인터페이스 구현
   - ✅ Either 패턴으로 에러 처리

3. **Presentation Layer** (Domain에만 의존)
   - ✅ BLoC에서 UseCase 호출
   - ✅ UI는 BLoC 상태만 구독
   - ✅ AppLocalizations는 Presentation에서만 사용

### 확장성

**향후 일본어 등 추가 언어 지원**:
1. AppLanguageType enum에 `japanese('日本語', 'ja')` 추가
2. `/lib/l10n/app_ja.arb` 파일 생성
3. 번역 작업
4. 코드 수정 불필요 (자동 지원)

### 폰트

- **Pretendard**: 한글 + 라틴 문자 모두 지원 → 그대로 사용
- 영문 전용 폰트 불필요
- 기존 weight 설정 유지

### 번역 톤

**한글**: 친근한 톤 ('~해요', '~돼요')
**영문**: Friendly tone 유지
- ❌ "An error occurred" (딱딱함)
- ✅ "Oops! Something went wrong" (친근함)

### 성능

- ARB 파일 로드: 앱 시작 시 1회, 무시할 수 있는 수준
- 코드 생성: 컴파일 타임, 런타임 영향 없음
- Locale 변경: MaterialApp 재빌드 (테마 변경과 동일)

## Verification

### 수동 테스트 체크리스트

**언어 설정 기능**:
- [ ] "나만의 앱 설정" 페이지에 "언어" 타일 표시됨
- [ ] 타일 탭 시 다이얼로그로 한국어/English 선택 가능
- [ ] 언어 선택 시 즉시 앱 전체 언어 변경됨
- [ ] 앱 종료 후 재시작해도 설정 유지됨

**신규 설치 시나리오**:
- [ ] 영어 디바이스에서 설치 시 영어로 시작
- [ ] 한국어 디바이스에서 설치 시 한국어로 시작
- [ ] 기타 언어 디바이스는 한국어로 시작

**주요 페이지 번역 확인**:
- [ ] 홈 페이지 제목 ("인하공지" → "Inha Notice")
- [ ] 북마크 페이지 모든 텍스트
- [ ] 검색 페이지 플레이스홀더
- [ ] 더보기 페이지 메뉴 항목들
- [ ] 설정 페이지 모든 섹션
- [ ] 알림 설정 페이지

**공통 요소**:
- [ ] 앱바 제목들
- [ ] 버튼 텍스트 (확인, 취소, 삭제 등)
- [ ] 스낵바 메시지들 (성공, 경고, 에러)
- [ ] 다이얼로그 텍스트들

**UI 레이아웃**:
- [ ] 긴 영문 텍스트에도 오버플로우 없음
- [ ] 버튼/타일 크기 적절히 조정됨
- [ ] 다이얼로그 정렬 정상
- [ ] Pretendard 폰트로 한글/영문 모두 깔끔하게 표시

### 빌드 확인

```bash
# 코드 생성 확인
flutter gen-l10n

# 빌드 에러 없는지 확인
flutter build apk --debug
flutter build ios --debug --no-codesign

# 분석 확인
flutter analyze
```

### ARB 파일 검증

- [ ] 모든 키가 `app_ko.arb`와 `app_en.arb`에 동일하게 존재
- [ ] 매개변수 정의가 일치
- [ ] JSON 포맷 유효성

## 타임라인

**총 예상 시간: 20-25시간**

- Phase 0: 인프라 구축 - 0.5시간
- Phase 1: Domain Layer - 1시간
- Phase 2: Data Layer - 1시간
- Phase 3: Presentation Layer - 2시간
- Phase 4: 의존성 주입 - 0.5시간
- Phase 5: Main.dart 통합 - 1시간
- Phase 6: 텍스트 마이그레이션 - 12시간
- Phase 7: 영문 번역 초안 - 2시간 (MD 파일로 정리)
- Phase 8: 테스트 - 2시간
- Phase 9: 문서화 - 1시간

**일정 예상** (하루 3-4시간 작업):
- Day 1-2: Phase 0-5 (인프라 + Architecture 레이어)
- Day 3-5: Phase 6 (텍스트 마이그레이션)
- Day 6: Phase 7 (번역 초안 작성 및 사용자 검토)
- Day 7: Phase 8-9 (테스트 및 정리)
