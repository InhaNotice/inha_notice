# Inha Notice

<div align="center">
  <img src="public/google_playstore_graphic image.png" alt="inha-notice_introduce-image">
</div>

This project is **a notice board application** designed for Inha family community. It helps students
**stay on top of important announcements** without the hassle of constantly checking the school
website.

## 🎯 Goal

Reduce missed notices as much as possible and maximize the benefits students can receive.

## ✨ Motivation

Students often struggle with inconvenient notice checks and tend to miss critical information (e.g.,
exam schedules, deadlines, events). This project was started to solve that problem through real-time
push notifications and easy management tools.

## 🔑 Key Features

- **Real-time Push Alerts**: Get notified the moment a new notice is posted.

- **Custom Tabs**: Personalize your home screen with only the categories you care about.

- **Bookmarking**: Save and organize important notices for later.

- **Academic Calendar Alerts**: Receive reminders for major academic events.

- **Search**: Quickly find specific notices.

- **Light/Dark Mode**: Choose the style that suits you.

## 📌 Supported Notices

Inha Notice collects and provides announcements from a wide range of university sources. including:

- **Departments** (70+ across Engineering, Natural Sciences, Business, Education, Social Sciences,
  Humanities, Medicine, Arts & Sports, Life Sciences, and interdisciplinary programs)
- **Colleges** (9 colleges)
- **Graduate Schools** (10 schools, including Law, Public Policy, Education, and more)
- **University-wide Notices** (e.g., Academic Affairs, Scholarships, Recruitment, International
  Affairs, Library)
- **Special Projects** (e.g., SW-Oriented University Project, Climate Change Response Project)

In total, the app supports over **100 announcement categories**, ensuring that students can
subscribe only to the notices that matter to them.

## 👥 Contributors

| Name                   | Roles                                     |
|------------------------|-------------------------------------------|
| Kim Jun-Ho(logicallaw) | Full-Stack Developer & Lead Product Owner |

## 📱 Platforms

- **iOS**: Released on 02/17/2025.
- **Android Beta**: 02/17/2025 ~ 03/24/2025.
- **Android Official Release**: 03/03/2025.

## Visit our Notion Page and Get the App (available only in South Korea).

- **Notion**: [Click](https://inha-notice.notion.site/)
- **iOS** (iPhone, iPad,
  Mac): [Download on the App Store](https://apps.apple.com/app/인하공지/id6740850198)
- **Android**: [Download on Google Play](https://play.google.com/store/apps/details?id=com.logicallawbio.inha_notice&pcampaignid=web_share)

## 📂 Project structure

```bash
inha_notice
├─ android # Android build files and configuration
├─ ios # iOS build files and configuration
│ 
├─ lib/
│  ├─ main.dart # App entry point
│  ├─ core/ # Core settings and resources
│  │  ├─ constants/
│  │  ├─ font/ 
│  │  ├─ keys/
│  │  └─ theme/
│  ├─ firebase/ # Firebase 
│  ├─ models/ # Data model definitions
│  ├─ screens/ # App screens (pages)
│  │  ├─ bottom_navigation/ # Bottom navigation bar (Home, Search, Bookmark, More)
│  │  │  ├─ bookmark/ # Bookmark (saved notice) page
│  │  │  ├─ home/ # Home page (aggregated notices)
│  │  │  ├─ more/ # More (settings and utilities) page
│  │  │  │  ├─ more_page.dart # Main 'More' page
│  │  │  │  ├─ cache_deletetion/ # Cache deletion feature widget
│  │  │  │  ├─ custom_license/ # License page
│  │  │  │  ├─ custom_tab_bar_page/ # 'My Tabs' setup page
│  │  │  │  │  ├─ custom_tab_bar_page.dart
│  │  │  │  │  └─ custom_tab_bar_page_widgets/
│  │  │  │  ├─ more_page_titles/ # Menu item widgets for 'More' page
│  │  │  │  │  ├─ more_navigation_tile.dart
│  │  │  │  │  ├─ more_non_navigation_tile.dart
│  │  │  │  │  ├─ more_title_tile.dart
│  │  │  │  │  └─ more_web_navigation_tile.dart
│  │  │  │  ├─ notification_setting/ # Notice topic notification settings
│  │  │  │  │  ├─ categories/ # (Major, College, Graduate School, Research/Academic Support, Academic Notices)
│  │  │  │  │  ├─ notification_major_item.dart
│  │  │  │  │  ├─ notification_setting_page.dart
│  │  │  │  │  └─ notification_tile.dart
│  │  │  │  ├─ theme_preference/ # Theme settings (Light/Dark)
│  │  │  │  └─ university_settings/ # User's department settings
│  │  │  └─ search/ # Search page
│  │  ├─ notice_board/ # Notice board
│  │  ├─ onboarding/ # Onboarding page
│  │  ├─ pagination/ # Page navigation button definitions
│  │  └─ webview/ # WebView screen
│  ├─ services/ # Scraping and API services
│  │  ├─ absolute_style_scraper/ 
│  │  ├─ relative_style_scraper/
│  │  ├─ search/
│  │  └─ trending_topics/
│  ├─ utils/ 
│  │  ├─ bookmark/ # Bookmark related logic (save, delete)
│  │  ├─ custom_tab_list_utils/ # 'My Tabs' list management utility
│  │  ├─ read_notice/ # Notice read status logic
│  │  ├─ recent_search/ # Recent search query logic
│  │  ├─ selectors/ # HTML element selector utility (scraping helper)
│  │  ├─ shared_prefs/ # Shared Preferences management helper
│  │  └─ university_utils/ # Department/university information utility
│  └─ widgets/ 
│     ├─ app_bars/ # Custom App Bar widgets
│     ├─ buttons/ # Custom Button widgets
│     ├─ dialogs/ # Custom Dialog widgets
│     ├─ dropdowns/ # Custom Dropdown widgets
│     ├─ loading_indicators/ # Loading indicator widgets
│     ├─ refresh_headers/ # 'Pull-to-refresh' header widgets
│     ├─ snack_bars/ # Snackbar widgets
│     ├─ textfields/ # Custom Text Field widgets
│     └─ texts/ # Custom Text style widgets
```

## 🚀 Start

### 1. Requirements

This project was developed and tested in the following environment.

- **Flutter v3.38.1**
- **Dart v3.10.0**
- **Supported Platforms:** iOS (15.0+), Android (SDK 21+)
- **Encoding:** UTF-8 (includes some Korean content)

### 2. Install

#### **Copy your local environment**

1. **Clone the repository**
   ```bash
   git clone https://github.com/InhaNotice/inha_notice.git
   cd inha_notice
2. **Install dependency**
   ```bash
   flutter pub get
3. **Configure Environment Variables (.env)**

   This project uses environment variables to manage API keys and service configurations.

    - **Create the file**: Create a new file named ```.env``` in the root directory of the project.
    - **Add required keys**: Copy the following structure into your new ```.env``` file, replacing
      the placeholder values with your actual keys:

       ```bash
       # Firebase Configuration
       FIREBASE_API_KEY = your-api-key
       FIREBASE_APP_ID = your-app-id
       FIREBASE_MESSAGING_SENDER_ID = your-messaging-sender-id
       FIREBASE_PROJECT_ID = your-project-id
       FIREBASE_STORAGE_BUCKET = your-storage-bucket
       FIREBASE_IOS_BUNDLE_ID = your-ios-bundle-id
 
       # Other Keys (e.g., department-specific APIs)
       # Other department-specific keys are requested to the person in charge of this project.
       ```

4. **Android Signing Setup (Required for Android)**

   To successfully build and release the Android application, you must configure the signing keys. *
   *These files are sensitive and are not included in the repository.**

    1. **Obtain Key Files**: You will need the following files, which must be obtained from the
       project maintainer:
        - **Keystore File** (```*.jks``` or ```*.keystore```)
        - **Key Properties File** (```key.properties```) - <i>This file contains the key alias,
          password, and store password</i>

    2. **Place Key Files**:
        - Place the keystore file (e.g., ```inha_notice_key.jks```) in the ```android/app/```
          directory.
        - Place the ```key.properties``` file in the ```android/``` directory.

    3. **Verify** ```key.properties```: The ```key.properties``` file must contain the following
       format:
       ```
       storePassword=[your_store_password]
       keyPassword=[your_key_password]
       keyAlias=[your_key_alias]
       storeFile=[your_keystore_filename].jks
       ```

5. **Build and Run the App**
   After configuring all keys, you can run the app on a connected device or build the final package.

**Run Locally**:

```bash
flutter run
```

**Build for Release**

```bash
# For Android (APK/AAB)
flutter build appbundle --release

# For iOS (Requires XCode)
flutter build ipa --release

# For Web (Chrome)
flutter build web
```

## 📚 Documentation (Developer Docs)

This project providers an **API Reference** for all major classes and methods, generated using
DartDoc.

**API Reference (DartDoc)**
The API documentation is automatically generated from the code comments and is stored in
the ```doc/api``` directory.

1. **Generate and Update the Docs**:

   To generate the latest documentation reflecting the current codebase, run the following command
   from the project root:
   ```bash
   dart doc
   ```
2. View the Documentation:

   Once generated, you can view the documentation by opening the ```index.html``` file in your web
   browser.

   **Local Path Example**:
   ```file:///Users/logicallaw/Downloads/inha_notice/doc/api/index.html```

   <i> Note: The actual path will vary depending on your local machine environment.</i>

## 🧑‍💻 How to contribute

1. **Fork this repository**
2. **Create a new branch**
   ```bash
   git checkout -b feature/your-new-feature-name your-remote-name/feature/your-new-feature-name
   ```
3. **Commit your change logs**
   ```bash
   git commit -m "feat: add your-change-logs"
   ```
4. **Push your branch**
   ```bash
   git push your-remote-name feature/your-new-feature-name
   ```
5. **Create a pull request at github**

## 📄 License

This project is licensed under the Apache License 2.0. For more details, please refer to
the [LICENSE](LICENSE.txt) file.

## 💻 Open-Source Software (OSS)

This project utilizes the following open-source libraries and packages to deliver its core
functionality:

| Category                      | Package(s)                                                                 | Description                                                                                                                 |
|:------------------------------|:---------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------|
| **Firebase Services**         | `firebase_core`, `firebase_messaging`                                      | Core integration and services for real-time push notifications.                                                             |
| **Notification Handling**     | `flutter_local_notifications`, `flutter_background_service`                | Manages local notifications and background processing tasks for receiving updates.                                          |
| **Networking & Data Parsing** | `http`, `xml`                                                              | Handles HTTP requests for network communication and parses XML data from web sources.                                       |
| **Data & Locale Utilities**   | `intl`                                                                     | Provides internationalization and localization features, including date/number formatting.                                  |
| **Storage & File System**     | `shared_preferences`, `sqflite`, `path_provider`, `path`                   | Manages local key-value storage, stores data in a local SQLite database, and handles platform-specific file paths.          |
| **User Interface & UX**       | `flutter_inappwebview`, `share_plus`, `pull_to_refresh`, `cupertino_icons` | Provides an embedded web view, enables content sharing, implements pull-to-refresh functionality, and uses iOS-style icons. |
| **Development Utilities**     | `flutter_dotenv`, `logger`                                                 | Loads environment variables from `.env` files and provides advanced logging capabilities for development and debugging.     |
| **Custom Fonts**              | `Pretendard`, `Tossface`, `NanumGothic`                                    | Custom typeface assets used to ensure optimal readability and design consistency across the application.                    |

## 📝 Questions or Support

If you have any questions or need support, feel free to open an issue on GitHub or reach out via the
following contact methods:

- Email: ingong.korea@gmail.com

- GitHub: InhaNotice
