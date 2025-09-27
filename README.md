# Inha Notice
<div align="center">
  <img src="public/google_playstore_graphic image.png" alt="inha-notice_introduce-image">
</div>

This project is **a notice board application** designed for Inha family community. It helps students **stay on top of important announcements** without the hassle of constantly checking the school website.

## 🎯 Goal
Reduce missed notices as much as possible and maximize the benefits students can receive.

## ✨ Motivation
Students often struggle with inconvenient notice checks and tend to miss critical information (e.g., exam schedules, deadlines, events). This project was started to solve that problem through real-time push notifications and easy management tools.

## 🔑 Key Features
- **Real-time Push Alerts**: Get notified the moment a new notice is posted.

- **Custom Tabs**: Personalize your home screen with only the categories you care about.

- **Bookmarking**: Save and organize important notices for later.

- **Academic Calendar Alerts**: Receive reminders for major academic events.

- **Search**: Quickly find specific notices.

- **Light/Dark Mode**: Choose the style that suits you.

## 📌 Supported Notices
Inha Notice collects and provides announcements from a wide range of university sources. including:

- **Departments** (80+ across Engineering, Natural Sciences, Business, Education, Social Sciences, Humanities, Medicine, Arts & Sports, Life Sciences, and interdisciplinary programs)
- **Colleges** (9 colleges)
- **Graduate Schools** (10 schools, including Law, Public Policy, Education, and more)
- **University-wide Notices** (e.g., Academic Affairs, Scholarships, Recruitment, International Affairs, Library)
- **Special Projects** (e.g., SW-Oriented University Project, Climate Change Response Project)

In total, the app supports over **100 announcement categories**, ensuring that students can subscribe only to the notices that matter to them.

## 👥 Contributors

| Name                       | Roles                                       |
|----------------------------|---------------------------------------------|
| Kim Jun-Ho(logicallaw)     | Full-Stack Developer & Lead Product Owner   |

## 📱 Platforms
- **iOS**: Released on 02/17/2025.
- **Android Beta**: 02/17/2025 ~ 03/24/2025.
- **Android Official Release**: 03/03/2025.

## Visit our Notion Page and Get the App.
- **Notion**: [Click](https://inha-notice.notion.site/)
- **iOS** (iPhone, iPad, Mac): [Download on the App Store](https://apps.apple.com/app/인하공지/id6740850198)
- **Android**: [Download on Google Play](https://play.google.com/store/apps/details?id=com.logicallawbio.inha_notice&pcampaignid=web_share)

## 🚀 Start

### 1. Requirements

This project was developed and tested in the following environment.

- **Flutter v3.27.4**
- **Dart v3.6.2**
- **Supported Platforms:** iOS (13.0+), Android (SDK 21+)
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
   - **Add required keys**: Copy the following structure into your new ```.env``` file, replacing the placeholder values with your actual keys:

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

4. **Android Signing Setup (required for Android)**

   To successfully build and release the Android application, you must configure the signing keys. **These files are sensitive and are not included in the repository.**

   1. **Obtain Key Files**: You will need the following files, which must be obtained from the project maintainer:
      - **Keystore File** (```*.jks``` or ```*.keystore```)
      - **Key Properties File** (```key.properties```) - <i>This file contains the key alias, password, and store password</i>
   
   2. **Place Key Files**:
      - Place the keystore file (e.g., ```inha_notice_key.jks```) in the ```android/app/``` directory.
      - Place the ```key.properties``` file in the ```android/``` directory.
   
   3. **Verify** ```key.properties```: The ```key.properties``` file must contain the following format:
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
This project providers an **API Reference** for all major classes and methods, generated using DartDoc.

**API Reference (DartDoc)**
The API documentation is automatically generated from the code comments and is stored in the ```doc/api``` directory.

1. **Generate and Update the Docs**:

   To generate the latest documentation reflecting the current codebase, run the following command from the project root:
   ```bash
   dart doc
   ```
2. View the Documentation:

   Once generated, you can view the documentation by opening the ```index.html``` file in your web browser.

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
This project is licensed under the Apache License 2.0. For more details, please refer to the [LICENSE](LICENSE.txt) file.

## 📝 Questions or Support
If you have any questions or need support, feel free to open an issue on GitHub or reach out via the following contact methods:
 - Email: ingong.korea@gmail.com
 - GitHub: InhaNotice
