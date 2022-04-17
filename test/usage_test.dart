import 'dart:io';

import 'package:deepl_dart/deepl_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Usage Tests', () {
    String? authKey = Platform.environment['DEEPL_AUTH_KEY'];
    late Translator translator;

    setUpAll(() {
      assert(authKey != null, 'found no authentication key');
      translator = Translator(authKey: authKey!);
    });

    test('get usage', () async {
      Usage usage = await translator.getUsage();
      expect(usage.characterCount <= usage.characterLimit, isTrue);
      expect(usage.anyLimitReached(), isFalse);
    });
  });
}
