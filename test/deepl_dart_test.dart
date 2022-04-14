import 'dart:io';

import 'package:deepl_dart/deepl_dart.dart';
import 'package:deepl_dart/src/errors.dart';
import 'package:deepl_dart/src/types.dart';
import 'package:test/test.dart';

void main() {
  group('Translator Tests', () {
    // add your auth key as environment variable or here
    // DO NOT FORGET TO DELETE THE KEY BEFORE COMMITTING!
    String authKey = Platform.environment['AUTH_KEY'] ?? '<your_auth_key>';
    assert(authKey != '<your_auth_key>', 'found no authentication key');
    Translator translator = Translator(authKey: authKey);

    group('Translate Text', () {
      String sampleTextEn = 'Hello World';
      String sampleTextDe = 'Hallo Welt';
      String sampleTextPt = 'Hola Mundo';

      test('translate text', () {
        expect(
            translator.translateTextSingular(sampleTextEn, 'de'),
            completion(equals(
                TextResult(text: sampleTextDe, detectedSourceLang: 'en'))));
      });

      test('translate list of text', () {
        expect(
            translator.translateTextList([sampleTextEn, sampleTextPt], 'de'),
            completion(equals([
              TextResult(text: sampleTextDe, detectedSourceLang: 'en'),
              TextResult(text: sampleTextPt, detectedSourceLang: 'pt')
            ])));
      });

      test('test accept language codes', () {
        expect(
            translator.translateTextSingular(sampleTextEn, 'de',
                sourceLang: 'en'),
            completion(equals(
                TextResult(text: sampleTextDe, detectedSourceLang: 'en'))));
      });

      test('test deprecated language codes', () {
        expect(translator.translateTextSingular(sampleTextDe, 'en'),
            throwsA(isA<AssertionError>()));
        expect(translator.translateTextSingular(sampleTextDe, 'pt'),
            throwsA(isA<AssertionError>()));
      });

      test('test invalid language codes', () {
        expect(
            translator.translateTextSingular(sampleTextEn, 'de',
                sourceLang: 'xx'),
            throwsA(isA<DeepLError>()));
        expect(translator.translateTextSingular(sampleTextEn, 'xx'),
            throwsA(isA<DeepLError>()));
      });

      test('test empty text', () {
        expect(translator.translateTextSingular('', 'de'),
            throwsA(isA<AssertionError>()));
        expect(translator.translateTextList([], 'de'),
            throwsA(isA<AssertionError>()));
        expect(translator.translateTextList([''], 'de'),
            throwsA(isA<AssertionError>()));
      });

      test('translate text with formality', () {
        String input = 'How are you?';
        String formal = 'Wie geht es Ihnen?';
        String informal = 'Wie geht es dir?';

        TextResult formalResult =
            TextResult(text: formal, detectedSourceLang: 'EN');
        TextResult informalResult =
            TextResult(text: informal, detectedSourceLang: 'EN');

        expect(translator.translateTextSingular(input, 'de'),
            completion(equals(formalResult)));
        expect(
            translator.translateTextSingular(input, 'de',
                options: TranslateTextOptions(formality: 'less')),
            completion(equals(informalResult)));
        expect(
            translator.translateTextSingular(input, 'de',
                options: TranslateTextOptions(formality: 'default')),
            completion(equals(formalResult)));
        expect(
            translator.translateTextSingular(input, 'de',
                options: TranslateTextOptions(formality: 'more')),
            completion(equals(formalResult)));
      });

      test('translate text with invalid formality', () {
        expect(
            translator.translateTextSingular(sampleTextEn, 'de',
                options: TranslateTextOptions(formality: 'invalid')),
            throwsA(isA<DeepLError>()));
      });

      test('translate text with split sentences', () async {
        String input = "That is not\nmy fault. It's theirs!";
        String oneSentence = 'Das ist nicht meine Schuld, es ist ihre Schuld!';
        String twoSentences = 'Das ist nicht meine Schuld. Es ist ihre Schuld!';
        String twoSentencesWithLineBreak =
            'Das ist nicht\nmeine Schuld. Es ist ihre Schuld!';

        expect(
            translator.translateTextSingular(input, 'de',
                options: TranslateTextOptions(splitSentences: 'off')),
            completion(equals(
                TextResult(text: oneSentence, detectedSourceLang: 'en'))));
        expect(
            translator.translateTextSingular(input, 'de',
                options: TranslateTextOptions(splitSentences: 'on')),
            completion(equals(TextResult(
                text: twoSentencesWithLineBreak, detectedSourceLang: 'en'))));
        expect(
            translator.translateTextSingular(input, 'de',
                options: TranslateTextOptions(splitSentences: 'nonewlines')),
            completion(equals(
                TextResult(text: twoSentences, detectedSourceLang: 'en'))));
        expect(
            translator.translateTextSingular(input, 'de',
                options: TranslateTextOptions(splitSentences: 'default')),
            completion(equals(TextResult(
                text: twoSentencesWithLineBreak, detectedSourceLang: 'en'))));
      });

      test('translate text with invalid split sentences', () {
        expect(
            translator.translateTextSingular(sampleTextEn, 'de',
                options: TranslateTextOptions(splitSentences: 'invalid')),
            throwsA(isA<DeepLError>()));
      });
    });
  });
}
