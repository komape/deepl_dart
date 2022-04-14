import 'dart:io';

import 'package:deepl_dart/deepl_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Translator Tests', () {
    String? authKey = Platform.environment['AUTH_KEY'];
    assert(authKey != null, 'found no authKey in environment');
    Translator translator = Translator(authKey: authKey!);

    test('Translate Singular Text Test', () async {
      TextResult result = await translator.translateTextSingular(
          text: 'Hello World', targetLang: 'de');
      expect(result.text, 'Hallo Welt');
      expect(result.detectedSourceLang.toLowerCase(), 'en');
    });

    test('Translate Array Text Test', () async {
      List<TextResult> results = await translator
          .translateTextList(texts: ['Hello', 'World'], targetLang: 'de');
      expect(results[0].text, 'Hallo');
      expect(results[0].detectedSourceLang.toLowerCase(), 'en');
      expect(results[1].text, 'Welt');
      expect(results[1].detectedSourceLang.toLowerCase(), 'en');
    });
  });
}
