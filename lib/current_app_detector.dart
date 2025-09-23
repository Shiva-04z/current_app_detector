import 'package:flutter/services.dart';

/// A class to interact with native platform functionality for detecting 
/// the current foreground application and interacting with system features.
class CurrentAppDetector {
  static const MethodChannel _channel = MethodChannel('current_app_detector');

  /// Navigates to the device's home screen.
  /// Returns `true` on success, otherwise throws an exception.
  static Future<bool> goHome() async {
    try {
      final result = await _channel.invokeMethod<bool>('goHome');
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('Failed to go home: ${e.message}');
    }
  }



  static Future<bool> getBack() async {
    try {
      final result = await _channel.invokeMethod<bool>('getBack');
      return result ?? false;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        throw Exception(
            'Accessibility permission is not enabled. Please grant permission first.');
      } else {
        throw Exception('Failed to perform back action: ${e.message}');
      }
    }
  }

  /// Gets the package name of the current foreground app.
  /// Requires Usage Stats permission on Android.
  /// Returns the package name as a [String].
  static Future<String> getCurrentApp() async {
    try {
      final result = await _channel.invokeMethod<String>('getCurrentApp');
      if (result == null) {
        throw Exception('No foreground app detected');
      }
      return result;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        throw Exception(
            'Usage stats permission required. Please grant the permission in settings.');
      } else {
        throw Exception('Failed to get current app: ${e.message}');
      }
    }
  }

  /// Launches an app by its package name (if it's installed).
  /// [packageName] is the package identifier of the app to launch.
  /// Returns `true` if launch was successful, otherwise throws an exception.
  static Future<bool> launchApp(String packageName) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'launchApp',
        {'packageName': packageName},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      if (e.code == 'APP_NOT_FOUND') {
        throw Exception('App not found: ${e.message}');
      } else {
        throw Exception('Failed to launch app: ${e.message}');
      }
    }
  }

  /// Requests Usage Stats permission from the user.
  /// This will open the system settings screen for the user to grant access.
  /// Returns "granted" if permission is already enabled, or "need_permission"
  /// if the settings screen was opened.
  static Future<String> getUsagePermission() async {
    try {
      final result = await _channel.invokeMethod<String>('getUsagePermission');
      return result ?? "unknown";
    } on PlatformException catch (e) {
      throw Exception('Failed to get usage permission: ${e.message}');
    }
  }

  /// Checks if Usage Stats permission has been granted.
  /// Returns `true` if permission is granted, `false` otherwise.
  static Future<bool> checkUsagePermission() async {
    try {
      final result =
          await _channel.invokeMethod<bool>('checkUsagePermission');
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('Failed to check usage permission: ${e.message}');
    }
  }

  //==================================================================
  // NEW METHODS FOR ACCESSIBILITY SERVICE
  //==================================================================

  /// Requests Accessibility permission from the user.
  /// This will open the system's accessibility settings screen.
  /// Returns "granted" if the service is already enabled, or "need_permission"
  /// if the settings screen was opened.
  static Future<String> getAccessibilityPermission() async {
    try {
      final result =
          await _channel.invokeMethod<String>('getAccessibilityPermission');
      return result ?? 'unknown';
    } on PlatformException catch (e) {
      throw Exception('Failed to handle accessibility permission: ${e.message}');
    }
  }

  /// Checks if the Accessibility Service for this app is enabled.
  /// Returns `true` if the service is enabled, `false` otherwise.
  static Future<bool> checkAccessibilityPermission() async {
    try {
      final result =
          await _channel.invokeMethod<bool>('checkAccessibilityPermission');
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception(
          'Failed to check accessibility permission: ${e.message}');
    }
  }

  /// Retrieves all text currently visible on the screen.
  /// Requires the Accessibility Service to be enabled.
  /// Returns the screen text as a single [String].
  static Future<String> getScreenText() async {
    try {
      final result = await _channel.invokeMethod<String>('getScreenText');
      return result ?? '';
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        throw Exception(
            'Accessibility permission is not enabled. Please grant permission first.');
      } else {
        throw Exception('Failed to get screen text: ${e.message}');
      }
    }
  }
}

class CurrentAppDetectorPlugin {
  static void registerWith() {
    // No registration needed for V2 embedding
  }
}


