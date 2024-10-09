@Timeout(Duration(seconds: 60))

import 'dart:io';

import 'package:deepl_dart/deepl_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Translator Tests', () {
    String? authKey = Platform.environment['DEEPL_AUTH_KEY'];
    late Translator translator;

    setUpAll(() {
      assert(authKey != null, 'found no authentication key');
      translator = Translator(authKey: authKey!);
    });

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

      test('translate text with utf-8 check', () {
        expect(
            translator.translateTextSingular('The force be with you.', 'pl'),
            completion(equals(TextResult(
                text: 'Siła niech będzie z tobą.',
                detectedSourceLanguage: 'en'))));
      });

      test('translate list of text', () {
        expect(
            translator.translateTextList([sampleTextEn, sampleTextPt], 'de'),
            completion(equals([
              TextResult(text: sampleTextDe, detectedSourceLanguage: 'en'),
              TextResult(text: sampleTextDe, detectedSourceLanguage: 'pt')
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

      // TODO pause due to bug in DeepL API
      // test('test deprecated language codes', () {
      //   expect(translator.translateTextSingular(sampleTextDe, 'en-us'),
      //       throwsA(isA<AssertionError>()));
      //   expect(translator.translateTextSingular(sampleTextDe, 'pt'),
      //       throwsA(isA<AssertionError>()));
      // });

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
            Translator(authKey: authKey!, serverUrl: 'https://example.org');
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

    group('Translate Text with Context', () {
      test('translate text with context - basic', () async {
        String text = 'The mouse is fast.';
        String context = 'This text is about computer hardware.';

        var result = await translator.translateTextSingular(text, 'de',
            options: TranslateTextOptions(context: context));

        expect(result.text.toLowerCase(), contains('maus'));
        expect(result.detectedSourceLanguage, equals('EN'));
      });

      test('translate text with context - ambiguous word', () async {
        String text = 'The bank is closed.';
        String financialContext = 'This text is about financial institutions.';
        String riverContext =
            'This text is about a river and its surroundings.';

        var financialResult = await translator.translateTextSingular(text, 'de',
            options: TranslateTextOptions(context: financialContext));

        var riverResult = await translator.translateTextSingular(text, 'de',
            options: TranslateTextOptions(context: riverContext));

        expect(financialResult.text.toLowerCase(), contains('bank'));
        expect(riverResult.text.toLowerCase(), contains('ufer'));
        expect(financialResult.detectedSourceLanguage, equals('EN'));
        expect(riverResult.detectedSourceLanguage, equals('EN'));
      });

      test('translate text with context - gender', () async {
        String text = 'The doctor said they would be available tomorrow.';
        String maleContext = 'The doctor is a man named John.';
        String femaleContext = 'The doctor is a woman named Sarah.';

        var maleResult = await translator.translateTextSingular(text, 'de',
            options: TranslateTextOptions(context: maleContext));

        var femaleResult = await translator.translateTextSingular(text, 'de',
            options: TranslateTextOptions(context: femaleContext));

        expect(maleResult.text.toLowerCase(), contains('er'));
        expect(femaleResult.text.toLowerCase(), contains('sie'));
        expect(maleResult.detectedSourceLanguage, equals('EN'));
        expect(femaleResult.detectedSourceLanguage, equals('EN'));
      });

      test('translate text with context - long context', () async {
        String text = 'The application crashed.';
        String context = '''
          This text is about software development.
          The application is a mobile app written in Flutter.
          It has been crashing frequently due to memory leaks.
          The development team is working on fixing these issues.
        ''';

        var result = await translator.translateTextSingular(text, 'de',
            options: TranslateTextOptions(context: context));

        expect(result.text.toLowerCase(),
            anyOf(contains('anwendung'), contains('app')));
        expect(result.detectedSourceLanguage, equals('EN'));
      });

      test('translate text with empty context', () async {
        String text = 'Hello, world!';
        String context = '';

        var result = await translator.translateTextSingular(text, 'de',
            options: TranslateTextOptions(context: context));

        expect(result.text, equals('Hallo, Welt!'));
        expect(result.detectedSourceLanguage, equals('EN'));
      });
    });
  });

  group('Auth Key Check', () {
    test('create translator with empty auth key', () {
      expect(() => Translator(authKey: ''), throwsA(isA<AssertionError>()));
    });

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
