# current_app_detector

A Flutter plugin to interact with foreground apps, navigate home, handle usage & accessibility permissions, and read screen text.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/docs/development/packages-and-plugins/developing-packages),
a specialized package that includes platform-specific implementation code for Android.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials, samples, guidance on mobile development, and a full API reference.

## Features

- **Detect Current Foreground App**
  - `getCurrentApp()` – Returns the package name of the app currently in the foreground.
- **Navigate to Home Screen**
  - `goHome()` – Minimizes the current app and navigates to the home screen.
- **Usage Permission Handling**
  - `getUsagePermission()` – Requests Usage Access permission.
  - `checkUsagePermission()` – Checks if Usage Access permission is granted.
- **Launch Apps**
  - `launchApp(String packageName)` – Launches an installed app using its package name.
- **Accessibility Service**
  - `getAccessibilityPermission()` – Requests Accessibility Service permission.
  - `checkAccessibilityPermission()` – Checks whether Accessibility Service is enabled.
- **Screen Text Reading**
  - `getScreenText()` – Reads all visible text from the screen using Accessibility Service.

## Version History

### 1.0.0
- Initial release
- Added `getCurrentApp()` and `goHome()` methods

### 1.0.1
- Added `getUsagePermission()` method

### 1.0.2
- Added `checkUsagePermission()` method

### 1.0.3
- Added `launchApp()` method

### 1.0.4
- Added Accessibility Service methods:
  - `getAccessibilityPermission()`
  - `checkAccessibilityPermission()`
- Added `getScreenText()` method

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  current_app_detector: ^1.0.4
````

## Android Manifest Setup

To use Accessibility Service and screen text reading, add the following to your `AndroidManifest.xml`:

```xml
<service
    android:name=".ScreenTextService"
    android:permission="android.permission.BIND_ACCESSIBILITY_SERVICE"
    android:exported="false">
    <intent-filter>
        <action android:name="android.accessibilityservice.AccessibilityService" />
    </intent-filter>
    <meta-data
        android:name="android.accessibilityservice"
        android:resource="@xml/accessibility_service_config" />
</service>
```

Also, ensure you have proper permissions in `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.PACKAGE_USAGE_STATS" />
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
```

## Usage

```dart
import 'package:current_app_detector/current_app_detector.dart';

void main() async {
  // Get current foreground app
  String currentApp = await CurrentAppDetector.getCurrentApp();

  // Go to home screen
  await CurrentAppDetector.goHome();

  // Request usage permission
  await CurrentAppDetector.getUsagePermission();

  // Check usage permission
  bool isUsageGranted = await CurrentAppDetector.checkUsagePermission();

  // Launch an app
  await CurrentAppDetector.launchApp("com.example.app");

  // Accessibility permission
  await CurrentAppDetector.getAccessibilityPermission();
  bool isAccessibilityEnabled = await CurrentAppDetector.checkAccessibilityPermission();

  // Read screen text
  String screenText = await CurrentAppDetector.getScreenText();
}
```

## Notes

* Some methods require **special permissions**: Usage Access and Accessibility Service.
* Works **only on Android devices**.
* Make sure your `accessibility_service_config.xml` is correctly defined in `res/xml/`.


