import 'dart:io';

import 'package:deepl_dart/deepl_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Language Tests', () {
    String? authKey = Platform.environment['DEEPL_AUTH_KEY'];
    late Languages languages;

    setUpAll(() {
      assert(authKey != null, 'found no authentication key');
      languages = DeepL(authKey: authKey!).languages;
    });

    test('get source languages', () async {
      List<Language> langs = await languages.getSources();
      expect(langs, isNotEmpty);
      expect(langs.first.supportsFormality, isNull);
    });

    test('get target languages', () async {
      List<Language> langs = await languages.getTargets();
      expect(langs, isNotEmpty);
      expect(langs.first.supportsFormality, isNotNull);
    });
  });
}
