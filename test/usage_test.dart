import 'dart:io';

import 'package:deepl_dart/deepl_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Usage Tests', () {
    String? authKey = Platform.environment['DEEPL_AUTH_KEY'];
    late DeepL deepl;

    setUpAll(() {
      assert(authKey != null, 'found no authentication key');
      deepl = DeepL(authKey: authKey!);
    });

    test('get usage', () async {
      final Usage usage = await deepl.getUsage();
      print(usage);
      expect(usage.characterCount <= usage.characterLimit, isTrue);
      expect(usage.anyLimitReached(), isFalse);
    });
  });
}
