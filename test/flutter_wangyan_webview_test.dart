import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wangyan_webview/flutter_wangyan_webview.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_wangyan_webview');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterWangyanWebview.platformVersion, '42');
  });
}
