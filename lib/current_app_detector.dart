import 'package:flutter/services.dart';

class CurrentAppDetector {
  static const MethodChannel _channel =
      MethodChannel('current_app_detector');

  /// Navigates to the home screen
  static Future<bool> goHome() async {
    try {
      final result = await _channel.invokeMethod<bool>('goHome');
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('Failed to go home: ${e.message}');
    }
  }

  /// Gets the package name of the current foreground app
  static Future<String> getCurrentApp() async {
    try {
      final result = await _channel.invokeMethod<String>('getCurrentApp');
      if (result == null) {
        throw Exception('No foreground app detected');
      }
      return result;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        throw Exception('Usage stats permission required. Please grant the permission in settings.');
      } else {
        throw Exception('Failed to get current app: ${e.message}');
      }
    }
  }


  /// Launches an app by its package name (if installed)
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

  /// Request usage stats permission
  static Future<String> getUsagePermission() async {
    try {
      final result = await _channel.invokeMethod<String>('getUsagePermission');
      return result ?? "unknown";
    } on PlatformException catch (e) {
      throw Exception('Failed to get usage permission: ${e.message}');
    }
  }

  /// Check if usage stats permission is granted
  static Future<bool> checkUsagePermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('checkUsagePermission');
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('Failed to check usage permission: ${e.message}');
    }
  }
}

class CurrentAppDetectorPlugin {
  static void registerWith() {
    // No registration needed for V2 embedding
  }
}


