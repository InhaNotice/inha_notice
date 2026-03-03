// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Inha Notice';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get noticeUntitled => 'Untitled Post';

  @override
  String noticeViewCount(String count) {
    return 'Views $count';
  }

  @override
  String get webViewDesktopMode => 'Switched to desktop mode.';

  @override
  String get webViewMobileMode => 'Switched to mobile mode.';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSettingTitle => 'Theme Setting';

  @override
  String get themeSettingMessage => 'Please select your preferred mode.';

  @override
  String get messageSuccessSettingSaved => 'Settings saved!';

  @override
  String get messageErrorRetry => 'Please try again.';

  @override
  String get bookmarkPageTitle => 'Bookmarks';

  @override
  String get bookmarkSortNewest => 'Newest';

  @override
  String get bookmarkSortOldest => 'Oldest';

  @override
  String get bookmarkSortName => 'Name';

  @override
  String get bookmarkEmptyMessage => 'No bookmarks yet.';

  @override
  String get messageWarnNoBookmarksToDelete => 'No bookmarks to delete.';

  @override
  String get messageSuccessBookmarksCleared => 'All bookmarks deleted!';

  @override
  String get bookmarkRefreshIdle => 'Pull down to refresh bookmarks.';

  @override
  String get bookmarkRefreshRelease => 'Release to refresh!';

  @override
  String get bookmarkRefreshRefreshing => 'Loading bookmarks...';

  @override
  String get bookmarkRefreshComplete => 'Bookmarks updated!';

  @override
  String get searchPageTitle => 'Search';

  @override
  String get searchInputPlaceholder => 'Enter search term';

  @override
  String get searchRecentSearches => 'Recent Searches';

  @override
  String get searchRecentEmpty => 'No recent searches.';

  @override
  String get searchClearAll => 'Clear All';

  @override
  String get searchPopularKeywords => 'Popular Keywords';

  @override
  String get searchPopularEmpty => 'No popular keywords.';

  @override
  String searchResultTitle(String query) {
    return 'Search Results: $query';
  }

  @override
  String get searchSortRank => 'Relevance';

  @override
  String get searchSortDate => 'Newest';

  @override
  String get messageWarnSearchMinLength =>
      'Please enter at least 2 characters.';

  @override
  String get messageWarnNoRecentSearches => 'No recent searches found.';

  @override
  String get messageSuccessRecentSearchesCleared => 'Recent searches cleared!';

  @override
  String get messageSuccessBookmarkDeleted => 'Deleted.';

  @override
  String get messageSuccessBookmarkAdded => 'Saved.';

  @override
  String messageSuccessSearchWordDeleted(String word) {
    return '$word deleted!';
  }
}
