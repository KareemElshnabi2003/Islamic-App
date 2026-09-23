# Islamic App

A Flutter-based Islamic application that brings prayer times, Qibla direction, Quran, Hadith, Azkar, Duas, stories, radio, videos, Azan audio, notifications, and phone-number authentication into one mobile experience.

## ✨ Features

* Prayer times based on the user's location.
* Qibla direction using device location and compass data.
* Phone number login with OTP using Firebase Authentication.
* Quran browsing with Surahs, Ayahs, and audio content.
* Hadith browsing and collection/author information.
* Duas organized by categories.
* Azkar and Sebha experience.
* Islamic stories from bundled local data.
* Quran/Islamic radio streaming.
* Islamic video content.
* Azan audio with selectable recitation/voice options.
* Scheduled local notifications for reminders and Azkar/Prayer related events.
* Dark and light themes.
* Arabic/English localization.
* Offline/cache support for selected network data.
* Responsive layouts for different screen sizes.

## 🏗️ Architecture

The project follows a feature-based structure inspired by Clean Architecture, separating Data, Domain, and Presentation concerns within the main feature modules.


lib/
├── core/
│   ├── api/
│   ├── constant/
│   ├── di/
│   ├── errors/
│   ├── helper/
│   ├── network/
│   ├── routing/
│   ├── services/
│   ├── theme/
│   └── widgets/
│
└── features/
    ├── auth/
    ├── drawer/
    │   ├── azan/
    │   ├── compus/
    │   ├── doaa/
    │   ├── stories/
    │   ├── times/
    │   ├── videos/
    │   └── zekr/
    ├── home/
    │   ├── ahadeth/
    │   ├── azkar/
    │   ├── quran/
    │   └── radio/
    ├── main/
    └── splash/

Core services and most feature modules follow a layered separation such as:

feature/
├── data/
├── domain/
└── presentation/

## 🧰 Tech Stack

* **Flutter / Dart**
* **BLoC / Cubit** for state management
* **GetIt** for dependency injection
* **Dio** for HTTP networking
* **GoRouter** for navigation
* **fpdart** for `Either`-based result handling
* **SharedPreferences** for local preferences/cache
* **Dio Cache Interceptor + Hive Store** for network caching
* **Geolocator + Geocoding** for location features
* **Flutter Compass** for Qibla direction
* **just_audio + just_audio_background** for audio playback
* **flutter_local_notifications** for local notifications
* **Android Alarm Manager Plus** for scheduled background alarms
* **Firebase Authentication** for phone number / OTP login
* **Screen Go** for responsive UI utilities

## 🌐 APIs & Data Sources

The app integrates with external services for Islamic content and prayer information, including:

* AlAdhan API — prayer times and next-prayer information.
* MP3Quran API — Surahs, radio, and video content.
* Ummah API — Quran, Hadith, and Duas.
* Local bundled JSON — Islamic stories.

## 🔐 Authentication

The app uses Firebase Authentication with phone number verification:


Phone Number
    ↓
Send OTP
    ↓
Verify OTP
    ↓
Firebase Authentication
    ↓
Authenticated User

## 📦 Project Setup

### 1. Clone the repository

git clone https://github.com/KareemElshnabi2003/Islamic-App
cd Islamic-App

### 2. Install dependencies

flutter pub get

### 3. Configure Firebase

Configure Firebase for the target platform and enable **Phone Authentication** in Firebase Console.

For Android, make sure the Firebase configuration file is placed at:

android/app/google-services.json

### 4. Run the application

flutter run

## 🖼️ Screenshots

Screenshots will be added here to showcase the main application flows, including:

* Home / Prayer Times
* Quran
* Hadith
* Qibla
* Azan
* Azkar / Sebha
* Authentication
* Dark / Light Theme

## 📌 Notes

* Some features depend on device permissions such as location, notifications, and audio-related functionality.
* Background Azan/audio behavior should be verified on a physical Android device because background execution and notification behavior can vary by device and OS configuration.

## 👨‍💻 Author

**Kareem Elshnabi**

* GitHub: https://github.com/KareemElshnabi2003
* LinkedIn: https://www.linkedin.com/in/kareem-elshnabi-087624258
