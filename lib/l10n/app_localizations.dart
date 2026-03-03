import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// No description provided for @appName.
  ///
  /// In ko, this message translates to:
  /// **'인하공지'**
  String get appName;

  /// No description provided for @commonConfirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get commonConfirm;

  /// No description provided for @commonCancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get commonCancel;

  /// No description provided for @noticeUntitled.
  ///
  /// In ko, this message translates to:
  /// **'제목이 없는 게시글입니다'**
  String get noticeUntitled;

  /// No description provided for @noticeViewCount.
  ///
  /// In ko, this message translates to:
  /// **'조회 {count}'**
  String noticeViewCount(String count);

  /// No description provided for @webViewDesktopMode.
  ///
  /// In ko, this message translates to:
  /// **'데스크탑 모드로 전환되었습니다.'**
  String get webViewDesktopMode;

  /// No description provided for @webViewMobileMode.
  ///
  /// In ko, this message translates to:
  /// **'모바일 모드로 전환되었습니다.'**
  String get webViewMobileMode;

  /// No description provided for @themeSystem.
  ///
  /// In ko, this message translates to:
  /// **'시스템 설정'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In ko, this message translates to:
  /// **'화이트'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ko, this message translates to:
  /// **'다크'**
  String get themeDark;

  /// No description provided for @themeSettingTitle.
  ///
  /// In ko, this message translates to:
  /// **'테마 설정'**
  String get themeSettingTitle;

  /// No description provided for @themeSettingMessage.
  ///
  /// In ko, this message translates to:
  /// **'원하는 모드를 선택해주세요.'**
  String get themeSettingMessage;

  /// No description provided for @messageSuccessSettingSaved.
  ///
  /// In ko, this message translates to:
  /// **'설정되었어요.'**
  String get messageSuccessSettingSaved;

  /// No description provided for @messageErrorRetry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도해주세요.'**
  String get messageErrorRetry;

  /// No description provided for @bookmarkPageTitle.
  ///
  /// In ko, this message translates to:
  /// **'북마크'**
  String get bookmarkPageTitle;

  /// No description provided for @bookmarkSortNewest.
  ///
  /// In ko, this message translates to:
  /// **'최신순'**
  String get bookmarkSortNewest;

  /// No description provided for @bookmarkSortOldest.
  ///
  /// In ko, this message translates to:
  /// **'과거순'**
  String get bookmarkSortOldest;

  /// No description provided for @bookmarkSortName.
  ///
  /// In ko, this message translates to:
  /// **'이름순'**
  String get bookmarkSortName;

  /// No description provided for @bookmarkEmptyMessage.
  ///
  /// In ko, this message translates to:
  /// **'북마크한 공지사항이 없어요.'**
  String get bookmarkEmptyMessage;

  /// No description provided for @messageWarnNoBookmarksToDelete.
  ///
  /// In ko, this message translates to:
  /// **'삭제할 북마크가 없어요.'**
  String get messageWarnNoBookmarksToDelete;

  /// No description provided for @messageSuccessBookmarksCleared.
  ///
  /// In ko, this message translates to:
  /// **'모두 삭제했어요!'**
  String get messageSuccessBookmarksCleared;

  /// No description provided for @bookmarkRefreshIdle.
  ///
  /// In ko, this message translates to:
  /// **'북마크를 새로고침하려면 아래로 당겨주세요.'**
  String get bookmarkRefreshIdle;

  /// No description provided for @bookmarkRefreshRelease.
  ///
  /// In ko, this message translates to:
  /// **'놓으면 북마크를 다시 불러와요!'**
  String get bookmarkRefreshRelease;

  /// No description provided for @bookmarkRefreshRefreshing.
  ///
  /// In ko, this message translates to:
  /// **'잠시만 기다려주세요, 북마크를 가져오는 중이에요.'**
  String get bookmarkRefreshRefreshing;

  /// No description provided for @bookmarkRefreshComplete.
  ///
  /// In ko, this message translates to:
  /// **'북마크가 업데이트 되었어요. 확인해보세요!'**
  String get bookmarkRefreshComplete;

  /// No description provided for @searchPageTitle.
  ///
  /// In ko, this message translates to:
  /// **'검색'**
  String get searchPageTitle;

  /// No description provided for @searchInputPlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'검색어를 입력하세요'**
  String get searchInputPlaceholder;

  /// No description provided for @searchRecentSearches.
  ///
  /// In ko, this message translates to:
  /// **'최근 검색어'**
  String get searchRecentSearches;

  /// No description provided for @searchRecentEmpty.
  ///
  /// In ko, this message translates to:
  /// **'최근 검색 기록이 없습니다.'**
  String get searchRecentEmpty;

  /// No description provided for @searchClearAll.
  ///
  /// In ko, this message translates to:
  /// **'전체삭제'**
  String get searchClearAll;

  /// No description provided for @searchPopularKeywords.
  ///
  /// In ko, this message translates to:
  /// **'실시간 인기 검색어'**
  String get searchPopularKeywords;

  /// No description provided for @searchPopularEmpty.
  ///
  /// In ko, this message translates to:
  /// **'인기 검색어가 없어요.'**
  String get searchPopularEmpty;

  /// No description provided for @searchResultTitle.
  ///
  /// In ko, this message translates to:
  /// **'검색 결과: {query}'**
  String searchResultTitle(String query);

  /// No description provided for @searchSortRank.
  ///
  /// In ko, this message translates to:
  /// **'정확도순'**
  String get searchSortRank;

  /// No description provided for @searchSortDate.
  ///
  /// In ko, this message translates to:
  /// **'최신순'**
  String get searchSortDate;

  /// No description provided for @messageWarnSearchMinLength.
  ///
  /// In ko, this message translates to:
  /// **'검색어는 두 글자 이상 입력해주세요.'**
  String get messageWarnSearchMinLength;

  /// No description provided for @messageWarnNoRecentSearches.
  ///
  /// In ko, this message translates to:
  /// **'최근 검색어가 존재하지 않아요.'**
  String get messageWarnNoRecentSearches;

  /// No description provided for @messageSuccessRecentSearchesCleared.
  ///
  /// In ko, this message translates to:
  /// **'최근 검색어를 모두 삭제하였어요!'**
  String get messageSuccessRecentSearchesCleared;

  /// No description provided for @messageSuccessBookmarkDeleted.
  ///
  /// In ko, this message translates to:
  /// **'삭제되었습니다.'**
  String get messageSuccessBookmarkDeleted;

  /// No description provided for @messageSuccessBookmarkAdded.
  ///
  /// In ko, this message translates to:
  /// **'저장되었습니다.'**
  String get messageSuccessBookmarkAdded;

  /// No description provided for @messageSuccessSearchWordDeleted.
  ///
  /// In ko, this message translates to:
  /// **'{word}이 삭제되었어요!'**
  String messageSuccessSearchWordDeleted(String word);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
