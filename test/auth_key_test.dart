import 'package:deepl_dart/deepl_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Auth Key Check', () {
    test('create translator with empty auth key', () {
      expect(() => DeepL(authKey: ''), throwsA(isA<AssertionError>()));
    });

    test('free auth key check', () {
      expect(isFreeAccountAuthKey('0000:fx'), equals(true));
      expect(isFreeAccountAuthKey('0000'), equals(false));
    });
  });
}
