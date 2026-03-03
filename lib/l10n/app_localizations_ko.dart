// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => '인하공지';

  @override
  String get commonConfirm => '확인';

  @override
  String get commonCancel => '취소';

  @override
  String get noticeUntitled => '제목이 없는 게시글입니다';

  @override
  String noticeViewCount(String count) {
    return '조회 $count';
  }

  @override
  String get webViewDesktopMode => '데스크탑 모드로 전환되었습니다.';

  @override
  String get webViewMobileMode => '모바일 모드로 전환되었습니다.';

  @override
  String get themeSystem => '시스템 설정';

  @override
  String get themeLight => '화이트';

  @override
  String get themeDark => '다크';

  @override
  String get themeSettingTitle => '테마 설정';

  @override
  String get themeSettingMessage => '원하는 모드를 선택해주세요.';

  @override
  String get messageSuccessSettingSaved => '설정되었어요.';

  @override
  String get messageErrorRetry => '다시 시도해주세요.';

  @override
  String get bookmarkPageTitle => '북마크';

  @override
  String get bookmarkSortNewest => '최신순';

  @override
  String get bookmarkSortOldest => '과거순';

  @override
  String get bookmarkSortName => '이름순';

  @override
  String get bookmarkEmptyMessage => '북마크한 공지사항이 없어요.';

  @override
  String get messageWarnNoBookmarksToDelete => '삭제할 북마크가 없어요.';

  @override
  String get messageSuccessBookmarksCleared => '모두 삭제했어요!';

  @override
  String get bookmarkRefreshIdle => '북마크를 새로고침하려면 아래로 당겨주세요.';

  @override
  String get bookmarkRefreshRelease => '놓으면 북마크를 다시 불러와요!';

  @override
  String get bookmarkRefreshRefreshing => '잠시만 기다려주세요, 북마크를 가져오는 중이에요.';

  @override
  String get bookmarkRefreshComplete => '북마크가 업데이트 되었어요. 확인해보세요!';

  @override
  String get searchPageTitle => '검색';

  @override
  String get searchInputPlaceholder => '검색어를 입력하세요';

  @override
  String get searchRecentSearches => '최근 검색어';

  @override
  String get searchRecentEmpty => '최근 검색 기록이 없습니다.';

  @override
  String get searchClearAll => '전체삭제';

  @override
  String get searchPopularKeywords => '실시간 인기 검색어';

  @override
  String get searchPopularEmpty => '인기 검색어가 없어요.';

  @override
  String searchResultTitle(String query) {
    return '검색 결과: $query';
  }

  @override
  String get searchSortRank => '정확도순';

  @override
  String get searchSortDate => '최신순';

  @override
  String get messageWarnSearchMinLength => '검색어는 두 글자 이상 입력해주세요.';

  @override
  String get messageWarnNoRecentSearches => '최근 검색어가 존재하지 않아요.';

  @override
  String get messageSuccessRecentSearchesCleared => '최근 검색어를 모두 삭제하였어요!';

  @override
  String get messageSuccessBookmarkDeleted => '삭제되었습니다.';

  @override
  String get messageSuccessBookmarkAdded => '저장되었습니다.';

  @override
  String messageSuccessSearchWordDeleted(String word) {
    return '$word이 삭제되었어요!';
  }
}
