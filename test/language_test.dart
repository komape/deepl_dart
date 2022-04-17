import 'dart:io';

import 'package:deepl_dart/deepl_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Language Tests', () {
    String? authKey = Platform.environment['DEEPL_AUTH_KEY'];
    late Translator translator;

    setUpAll(() {
      assert(authKey != null, 'found no authentication key');
      translator = Translator(authKey: authKey!);
    });

    test('get source languages', () async {
      List<Language> langs = await translator.getSourceLanguages();
      expect(langs, isNotEmpty);
      expect(langs.first.supportsFormality, isNull);
    });

    test('get target languages', () async {
      List<Language> langs = await translator.getTargetLanguages();
      expect(langs, isNotEmpty);
      expect(langs.first.supportsFormality, isNotNull);
    });
  });
}
