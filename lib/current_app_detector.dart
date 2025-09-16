import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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
}



class CurrentAppDetectorPlugin {
  static void registerWith() {
    // No registration needed for V2 embedding
  }
}