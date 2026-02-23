# 인하공지 Architecture Agent

## 개요

이 문서는 인하공지(inha_notice) 프로젝트의 아키텍처 설계 정책을 정의합니다.
프로젝트는 **Clean Architecture**와 **BLoC 패턴**을 기반으로 구성되어 있습니다.

## 아키텍처 원칙

### 1. Clean Architecture

프로젝트는 다음 3개의 레이어로 구성됩니다:

```
lib/features/{feature_name}/
├── domain/           # 비즈니스 로직 레이어 (가장 안쪽)
├── data/             # 데이터 처리 레이어 (중간)
└── presentation/     # UI 레이어 (가장 바깥쪽)
```

#### 의존성 규칙
- **Domain** 레이어는 다른 레이어에 의존하지 않음 (순수 Dart 코드)
- **Data** 레이어는 Domain 레이어에만 의존
- **Presentation** 레이어는 Domain 레이어에만 의존 (Data 레이어는 DI를 통해 주입)

### 2. 레이어별 책임

#### Domain 레이어
```
domain/
├── entities/         # 비즈니스 객체
├── repositories/     # Repository 인터페이스 (추상 클래스)
├── usecases/         # 비즈니스 로직 Use Case
└── failures/         # 에러 처리 객체 (freezed 사용)
```

**책임:**
- 비즈니스 로직 정의
- 데이터 접근 인터페이스 정의 (Repository)
- 에러 타입 정의 (Failure)

**예시:**
```dart
// Entity
class BookmarkEntity extends Equatable {
  final List<NoticeTileModel> bookmarks;
  const BookmarkEntity({required this.bookmarks});

  @override
  List<Object?> get props => [bookmarks];
}

// Repository Interface
abstract class BookmarkRepository {
  Future<Either<BookmarkFailure, BookmarkEntity>> getBookmarks();
  Future<Either<BookmarkFailure, void>> removeBookmark(int id);
  Future<Either<BookmarkFailure, void>> clearBookmarks();
}

// Use Case
class GetBookmarksUseCase {
  final BookmarkRepository repository;

  GetBookmarksUseCase({required this.repository});

  Future<Either<BookmarkFailure, BookmarkEntity>> call() async {
    return await repository.getBookmarks();
  }
}

// Failure (freezed 사용)
@freezed
class BookmarkFailure with _$BookmarkFailure {
  const factory BookmarkFailure.bookmarks(String message) = _Bookmarks;
}
```

#### Data 레이어
```
data/
├── datasources/      # 데이터 소스 (Local/Remote)
├── models/           # 데이터 전송 객체 (DTO)
└── repositories/     # Repository 구현체
```

**책임:**
- 데이터 소스 구현 (로컬 DB, SharedPreferences, API 등)
- Entity와 Model 간 변환
- Repository 인터페이스 구현

**예시:**
```dart
// Data Source Interface
abstract class BookmarkLocalDataSource {
  Future<void> initialize();
  Future<BookmarkModel> getBookmarks();
  Future<void> addBookmark(NoticeTileModel notice);
  Future<void> removeBookmark(String noticeId);
  Future<void> clearBookmarks();
  bool isBookmarked(String noticeId);
  Set<String> getBookmarkIds();
}

// Data Source Implementation
class BookmarkLocalDataSourceImpl implements BookmarkLocalDataSource {
  Database? _database;
  Set<String> _bookmarkIds = {};

  @override
  Future<void> initialize() async {
    // SQLite 초기화 로직
  }

  @override
  Future<BookmarkModel> getBookmarks() async {
    final db = await _getDatabase();
    final result = await db.query(tableName);
    return BookmarkModel.fromList(result);
  }
// ...
}

// Repository Implementation
class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkLocalDataSource localDataSource;

  BookmarkRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<BookmarkFailure, BookmarkEntity>> getBookmarks() async {
    try {
      final result = await localDataSource.getBookmarks();
      return Right(result);
    } catch (e) {
      return Left(BookmarkFailure.bookmarks(e.toString()));
    }
  }
}
```

#### Presentation 레이어
```
presentation/
├── bloc/             # BLoC 상태 관리
│   ├── {feature}_bloc.dart
│   ├── {feature}_event.dart
│   └── {feature}_state.dart
├── pages/            # 페이지 위젯
└── widgets/          # 재사용 가능한 위젯
```

**책임:**
- UI 렌더링
- 사용자 이벤트 처리
- BLoC을 통한 상태 관리

**예시:**
```dart
// Event
abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();
  @override
  List<Object> get props => [];
}

class LoadBookmarksEvent extends BookmarkEvent {
  final bool isRefresh;
  final Completer? completer;
  const LoadBookmarksEvent({required this.isRefresh, this.completer});
}

class ChangeSortingEvent extends BookmarkEvent {
  final BookmarkSortingType sortType;
  const ChangeSortingEvent({required this.sortType});
}

// State
abstract class BookmarkState extends Equatable {
  const BookmarkState();
  @override
  List<Object?> get props => [];
}

class BookmarkInitial extends BookmarkState {}
class BookmarkLoading extends BookmarkState {}

class BookmarkLoaded extends BookmarkState {
  final List<NoticeTileModel> bookmarks;
  final BookmarkSortingType sortType;

  const BookmarkLoaded({required this.bookmarks, required this.sortType});

  @override
  List<Object?> get props => [bookmarks, sortType];
}

class BookmarkError extends BookmarkState {
  final String message;
  const BookmarkError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final GetBookmarksUseCase getBookmarksUseCase;
  final ClearBookmarksUseCase clearBookmarksUseCase;
  final RemoveBookmarkUseCase removeBookmarkUseCase;

  BookmarkBloc({
    required this.getBookmarksUseCase,
    required this.clearBookmarksUseCase,
    required this.removeBookmarkUseCase,
  }) : super(BookmarkInitial()) {
    on<LoadBookmarksEvent>(_onLoadBookmarks);
    on<RemoveBookmarkEvent>(_onRemoveBookmark);
    on<ChangeSortingEvent>(_onChangeSorting);
    on<ClearBookmarksEvent>(_onClearBookmarks);
  }

  Future<void> _onLoadBookmarks(
      LoadBookmarksEvent event,
      Emitter<BookmarkState> emit
      ) async {
    if (!event.isRefresh) {
      emit(BookmarkLoading());
    }

    final results = await getBookmarksUseCase();

    results.fold(
          (failure) {
        final errorMessage = failure.when(bookmarks: (msg) => msg);
        emit(BookmarkError(message: errorMessage));
      },
          (bookmarkWrapper) {
        final sortedList = _sortBookmarks(bookmarkWrapper.bookmarks, sortType);
        emit(BookmarkLoaded(bookmarks: sortedList, sortType: sortType));
      },
    );
  }
}
```

### 3. BLoC 패턴

#### BLoC 구조
- **Event**: 사용자 또는 시스템에서 발생하는 이벤트
- **State**: UI에 반영되는 상태
- **BLoC**: Event를 받아 UseCase를 호출하고 State를 변경

#### 상태 관리 흐름
```
사용자 액션 → Event 발생 → BLoC에서 UseCase 호출
→ Repository를 통한 데이터 처리 → 결과를 State로 변환 → UI 업데이트
```

#### BLoC 사용 패턴
```dart
// 페이지에서 BLoC 제공
class BookmarkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookmarkBloc>()
        ..add(const LoadBookmarksEvent(isRefresh: false)),
      child: const _BookmarkPageView(),
    );
  }
}

// BLoC 사용
class _BookmarkPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        if (state is BookmarkLoading) {
          return const BlueLoadingIndicatorWidget();
        }
        if (state is BookmarkError) {
          return Text(state.message);
        }
        if (state is BookmarkLoaded) {
          return ListView.builder(
            itemCount: state.bookmarks.length,
            itemBuilder: (context, index) {
              return NoticeTileWidget(notice: state.bookmarks[index]);
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
```

### 4. 에러 처리

#### Either 패턴 (dartz 라이브러리)
- 성공: `Right(결과값)`
- 실패: `Left(Failure)`

```dart
Future<Either<BookmarkFailure, BookmarkEntity>> getBookmarks() async {
  try {
    final result = await localDataSource.getBookmarks();
    return Right(result);
  } catch (e) {
    return Left(BookmarkFailure.bookmarks(e.toString()));
  }
}

// 사용
final results = await getBookmarksUseCase();
results.fold(
(failure) => print('Error: ${failure.message}'),
(success) => print('Success: $success'),
);
```

### 5. 의존성 주입 (DI)

#### GetIt 사용
- `injection_container.dart`에서 모든 의존성 등록
- `sl<T>()`로 인스턴스 가져오기

```dart
// 등록
final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(() => BookmarkBloc(
    getBookmarksUseCase: sl(),
    clearBookmarksUseCase: sl(),
    removeBookmarkUseCase: sl(),
  ));

  // Use Cases
  sl.registerLazySingleton(() => GetBookmarksUseCase(repository: sl()));
  sl.registerLazySingleton(() => ClearBookmarksUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<BookmarkRepository>(
          () => BookmarkRepositoryImpl(localDataSource: sl())
  );

  // Data Sources
  sl.registerLazySingleton<BookmarkLocalDataSource>(
          () => BookmarkLocalDataSourceImpl()
  );
}

// 사용
final bloc = sl<BookmarkBloc>();
```

### 6. 로컬 저장소

#### SQLite (sqflite)
- 북마크, 읽은 공지사항 등 구조화된 데이터 저장
- Data Source에서 Database 초기화 및 관리

#### SharedPreferences
- 사용자 설정값 저장 (테마, 정렬 기본값 등)
- `SharedPrefsManager`를 통한 중앙 관리

```dart
abstract class ThemePreferenceLocalDataSource {
  ThemeMode getThemeMode();
  Future<void> setThemeMode(ThemeMode themeMode);
}

class ThemePreferenceLocalDataSourceImpl
    implements ThemePreferenceLocalDataSource {
  final SharedPrefsManager sharedPrefsManager;

  ThemePreferenceLocalDataSourceImpl({required this.sharedPrefsManager});

  @override
  ThemeMode getThemeMode() {
    final userThemeSetting =
        sharedPrefsManager.getValue<String>(SharedPrefKeys.kUserThemeSetting)
            ?? AppThemeType.system.text;

    if (userThemeSetting == AppThemeType.light.text) {
      return ThemeMode.light;
    }
    // ...
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    final value = /* convert to string */;
    await sharedPrefsManager.setValue<String>(
        SharedPrefKeys.kUserThemeSetting,
        value
    );
  }
}
```

### 7. 명명 규칙

#### 파일명
- 스네이크 케이스: `bookmark_repository.dart`
- 구현체: `bookmark_repository_impl.dart`
- BLoC: `bookmark_bloc.dart`, `bookmark_event.dart`, `bookmark_state.dart`

#### 클래스명
- 파스칼 케이스: `BookmarkRepository`
- 구현체: `BookmarkRepositoryImpl`
- Entity: `BookmarkEntity`
- Model: `BookmarkModel`
- UseCase: `GetBookmarksUseCase`

#### 변수명
- 카멜 케이스: `bookmarkList`, `sortingType`
- 상수: `kUserThemeSetting` (k prefix)

### 8. 코드 스타일

#### 파일 헤더
모든 파일은 다음 헤더를 포함해야 합니다:

```dart
/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: YYYY-MM-DD
 */
```

#### Equatable 사용
Entity, Event, State는 Equatable을 상속하여 동등성 비교 구현:

```dart
class BookmarkEntity extends Equatable {
  final List<NoticeTileModel> bookmarks;

  const BookmarkEntity({required this.bookmarks});

  @override
  List<Object?> get props => [bookmarks];
}
```

#### Freezed 사용
Failure 클래스는 freezed를 사용하여 불변 객체 생성:

```dart
@freezed
class BookmarkFailure with _$BookmarkFailure {
  const factory BookmarkFailure.bookmarks(String message) = _Bookmarks;
}
```

## 새 기능 추가 체크리스트

새로운 기능을 추가할 때는 다음 순서로 작업합니다:

### 1. Domain 레이어
- [ ] Entity 정의
- [ ] Failure 정의 (freezed)
- [ ] Repository 인터페이스 정의
- [ ] Use Case 구현

### 2. Data 레이어
- [ ] Data Source 인터페이스 정의
- [ ] Data Source 구현 (Local/Remote)
- [ ] Model 정의 (필요시)
- [ ] Repository 구현

### 3. Presentation 레이어
- [ ] Event 정의
- [ ] State 정의
- [ ] BLoC 구현
- [ ] Page 구현
- [ ] Widget 구현

### 4. 의존성 주입
- [ ] `injection_container.dart`에 등록

### 5. 테스트 (선택적)
- [ ] Unit Test
- [ ] Widget Test
- [ ] Integration Test

## 확장 가능한 설계 원칙

### 1. 개방-폐쇄 원칙 (OCP)
- 새로운 기능 추가 시 기존 코드 수정 최소화
- 인터페이스를 통한 추상화

### 2. 단일 책임 원칙 (SRP)
- 각 클래스는 하나의 책임만 가짐
- Use Case는 하나의 비즈니스 로직만 처리

### 3. 의존성 역전 원칙 (DIP)
- 구체적인 구현이 아닌 추상화에 의존
- Repository 인터페이스를 통한 데이터 접근

### 4. 인터페이스 분리 원칙 (ISP)
- Data Source는 Local/Remote로 분리
- 필요한 메서드만 정의

## 참고 사항

- 모든 비동기 작업은 `async/await` 사용
- 에러 처리는 `Either` 패턴 사용
- UI와 비즈니스 로직은 명확히 분리
- 테스트 가능한 코드 작성을 위해 의존성 주입 활용
