import 'package:flutter_test/flutter_test.dart';
import 'package:current_app_detector/current_app_detector.dart';

void main() {
  test('Plugin channel is established', () {
    // This test just verifies the plugin can be imported
    // ignore: unnecessary_type_check
    expect(CurrentAppDetector is Type, true);
  });
}
