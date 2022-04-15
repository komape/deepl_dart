@Timeout(Duration(seconds: 60))

import 'dart:io';

import 'package:deepl_dart/deepl_dart.dart';
import 'package:deepl_dart/src/model/errors.dart';
import 'package:deepl_dart/src/model/document_status.dart';
import 'package:deepl_dart/src/model/document_translate_options.dart';
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
                TextResult(text: sampleTextDe, detectedSourceLanguage: 'en'))));
      });

      test('translate list of text', () {
        expect(
            translator.translateTextList([sampleTextEn, sampleTextPt], 'de'),
            completion(equals([
              TextResult(text: sampleTextDe, detectedSourceLanguage: 'en'),
              TextResult(text: sampleTextPt, detectedSourceLanguage: 'pt')
            ])));
      });

      test('test accept language codes', () {
        expect(
            translator.translateTextSingular(sampleTextEn, 'de',
                sourceLang: 'en'),
            completion(equals(
                TextResult(text: sampleTextDe, detectedSourceLanguage: 'en'))));
      });

      test('test regional language codes', () {
        expect(
            translator.translateTextSingular(sampleTextDe, 'en-us',
                sourceLang: 'de'),
            completion(equals(TextResult(
                text: 'Hello world', detectedSourceLanguage: 'de'))));
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
        expect(translator.translateTextList([''], 'de'),
            throwsA(isA<AssertionError>()));
        expect(translator.translateTextList([], 'de'),
            throwsA(isA<AssertionError>()));
        expect(translator.translateTextList(List.filled(51, ''), 'de'),
            throwsA(isA<AssertionError>()));
      });

      test('translate text with formality', () {
        String input = 'How are you?';
        String formal = 'Wie geht es Ihnen?';
        String informal = 'Wie geht es dir?';

        TextResult formalResult =
            TextResult(text: formal, detectedSourceLanguage: 'EN');
        TextResult informalResult =
            TextResult(text: informal, detectedSourceLanguage: 'EN');

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
                TextResult(text: oneSentence, detectedSourceLanguage: 'en'))));
        expect(
            translator.translateTextSingular(input, 'de',
                options: TranslateTextOptions(splitSentences: 'on')),
            completion(equals(TextResult(
                text: twoSentencesWithLineBreak,
                detectedSourceLanguage: 'en'))));
        expect(
            translator.translateTextSingular(input, 'de',
                options: TranslateTextOptions(splitSentences: 'nonewlines')),
            completion(equals(
                TextResult(text: twoSentences, detectedSourceLanguage: 'en'))));
        expect(
            translator.translateTextSingular(input, 'de',
                options: TranslateTextOptions(splitSentences: 'default')),
            completion(equals(TextResult(
                text: twoSentencesWithLineBreak,
                detectedSourceLanguage: 'en'))));
      });

      test('translate text with invalid split sentences', () {
        expect(
            translator.translateTextSingular(sampleTextEn, 'de',
                options: TranslateTextOptions(splitSentences: 'invalid')),
            throwsA(isA<DeepLError>()));
      });

      test('translate text with glossary id but no source lang', () {
        expect(
            translator.translateTextSingular(sampleTextEn, 'de',
                options: TranslateTextOptions(glossaryId: 'foo')),
            throwsA(isA<DeepLError>()));
      });

      test('translate text with own server url', () {
        Translator translator =
            Translator(authKey: authKey, serverUrl: 'https://example.org');
        expect(translator.translateTextSingular(sampleTextEn, 'de'),
            throwsA(isA<DeepLError>()));
      });
    });

    group('Translate Document', () {
      late File inputFile;
      late File outputFile;

      setUp(() {
        inputFile = File('input.txt');
        outputFile = File('output.txt');
      });

      tearDown(() async {
        await Future.wait([
          deleteIfExists(inputFile),
          deleteIfExists(outputFile),
        ]);
      });

      test('translate document', () async {
        inputFile.writeAsStringSync('Hello World');
        DocumentStatus status =
            await translator.translateDocument(inputFile, outputFile, 'de');
        expect(status.done, equals(true));
        expect(status.ok, equals(true));
        String translation = outputFile.readAsStringSync();
        expect(translation, equals('Hallo Welt'));
      });

      test('translate document with invalid file format', () {
        inputFile = File('input.dart');
        inputFile.writeAsStringSync('// hello world');
        outputFile = File('ouput.dart');
        expect(translator.translateDocument(inputFile, outputFile, 'de'),
            throwsA(isA<DeepLError>()));
      });

      test('translate document with formality', () async {
        inputFile.writeAsStringSync('How are you?');

        DocumentStatus status = await translator.translateDocument(
            inputFile, outputFile, 'de',
            options: DocumentTranslateOptions(formality: 'more'));
        expect(status.done, equals(true));
        expect(status.ok, equals(true));
        String translation = outputFile.readAsStringSync();
        expect(translation, equals('Wie geht es Ihnen?'));

        status = await translator.translateDocument(inputFile, outputFile, 'de',
            options: DocumentTranslateOptions(formality: 'default'));
        expect(status.done, equals(true));
        expect(status.ok, equals(true));
        translation = outputFile.readAsStringSync();
        expect(translation, equals('Wie geht es Ihnen?'));

        status = await translator.translateDocument(inputFile, outputFile, 'de',
            options: DocumentTranslateOptions(formality: 'less'));
        expect(status.done, equals(true));
        expect(status.ok, equals(true));
        translation = outputFile.readAsStringSync();
        expect(translation, equals('Wie geht es dir?'));
      });

      test('translate document with invalid formality', () {
        inputFile.writeAsStringSync('How are you?');

        expect(
            translator.translateDocument(inputFile, outputFile, 'de',
                options: DocumentTranslateOptions(formality: 'invalid')),
            throwsA(isA<DeepLError>()));
      });

      test('translate document with source lang equals target lang', () async {
        inputFile.writeAsStringSync('Hallo Welt');

        expect(
            translator.translateDocument(inputFile, outputFile, 'de',
                sourceLang: 'de'),
            throwsA(isA<DeepLError>()));
      });
    });
  });

  group('Auth Key Check', () {
    test('free auth key check', () {
      expect(Translator.isFreeAccountAuthKey('0000:fx'), equals(true));
      expect(Translator.isFreeAccountAuthKey('0000'), equals(false));
    });
  });
}

Future<void> deleteIfExists(File file) async {
  if (await file.exists()) {
    await file.delete();
  }
}
