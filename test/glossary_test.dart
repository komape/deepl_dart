@Timeout(Duration(seconds: 60))
library;

import 'dart:io';

import 'package:deepl_dart/deepl_dart.dart';
import 'package:test/test.dart';

import 'translation_test.dart';

void main() {
  group('Glossary Tests', () {
    String? authKey = Platform.environment['DEEPL_AUTH_KEY'];
    late Translator translator;

    String name = 'test glossary';
    String sourceLang = 'en';
    String targetLang = 'de';
    GlossaryEntries entries = GlossaryEntries(entries: {'Hello': 'Hi'});

    setUpAll(() {
      assert(authKey != null, 'found no authentication key');
      translator = Translator(authKey: authKey!);
    });

    test('get glossary language pairs', () async {
      expect(translator.getGlossaryLanguagePairs(), completion(isNotEmpty));
    });

    test('create glossary', () async {
      GlossaryInfo info = await translator.createGlossary(
          name: name,
          sourceLang: sourceLang,
          targetLang: targetLang,
          entries: entries);
      expect(info.glossaryId, isNotEmpty);
      expect(info.name, equals(name));
      expect(info.sourceLang, equals(sourceLang));
      expect(info.targetLang, equals(targetLang));
      expect(info.creationTime, isNotEmpty);
      expect(info.ready, isTrue);
      expect(info.entryCount, equals(1));
    });

    test('create glossary with invalid name', () {
      expect(
          translator.createGlossary(
              name: '',
              sourceLang: sourceLang,
              targetLang: targetLang,
              entries: entries),
          throwsA(isA<AssertionError>()));
    });

    test('create glossary with empty entries', () {
      expect(
          translator.createGlossary(
              name: name,
              sourceLang: sourceLang,
              targetLang: targetLang,
              entries: GlossaryEntries()),
          throwsA(isA<AssertionError>()));
    });

    test('create glossary with invalid lang code', () {
      expect(
          translator.createGlossary(
              name: name,
              sourceLang: '',
              targetLang: targetLang,
              entries: entries),
          throwsA(isA<AssertionError>()));
    });

    test('create glossary with csv file', () async {
      File csvFile = File('csvFile.csv');
      csvFile.writeAsStringSync('"Hello","Hi",en,de');
      GlossaryInfo info = await translator.createGlossaryWithCsvFile(
          name: name,
          sourceLang: sourceLang,
          targetLang: targetLang,
          csvFile: csvFile);
      expect(info.glossaryId, isNotEmpty);
      expect(info.name, equals(name));
      expect(info.sourceLang, equals(sourceLang));
      expect(info.targetLang, equals(targetLang));
      expect(info.creationTime, isNotEmpty);
      expect(info.ready, isTrue);
      expect(info.entryCount, equals(1));
      deleteIfExists(csvFile);
    });

    test('get glossary', () async {
      List<GlossaryInfo> infos = await translator.listGlossaries();
      expect(infos, isNotEmpty);
      expect(translator.getGlossary(infos.first.glossaryId),
          completion(equals(infos.first)));
    });

    test('get glossary with invalid id', () {
      expect(translator.getGlossary(''), throwsA(isA<AssertionError>()));
      expect(translator.getGlossary('invalid id'), throwsA(isA<DeepLError>()));
      expect(translator.getGlossary('96ab91fd-e715-41a1-adeb-5d701f84a483'),
          throwsA(isA<GlossaryNotFoundError>()));
    });

    test('get glossary entries', () async {
      List<GlossaryInfo> infos = await translator.listGlossaries();
      expect(infos, isNotEmpty);
      expect(translator.getGlossaryEntries(glossaryId: infos.first.glossaryId),
          completion(equals(entries)));
      expect(translator.getGlossaryEntries(glossaryInfo: infos.first),
          completion(equals(entries)));
    });

    test('get glossary entries with invalid params', () async {
      List<GlossaryInfo> infos = await translator.listGlossaries();
      expect(infos, isNotEmpty);
      expect(
          translator.getGlossaryEntries(
              glossaryId: infos.first.glossaryId, glossaryInfo: infos.first),
          throwsA(isA<AssertionError>()));
      expect(translator.getGlossaryEntries(), throwsA(isA<AssertionError>()));
    });

    test('get glossary entries with invalid id', () {
      expect(translator.getGlossaryEntries(glossaryId: ''),
          throwsA(isA<AssertionError>()));
    });
    test('delete glossary', () async {
      List<GlossaryInfo> infos = await translator.listGlossaries();
      expect(infos, isNotEmpty);
      translator.deleteGlossary(glossaryId: infos.first.glossaryId);
      translator.deleteGlossary(glossaryInfo: infos.first);
    });

    test('delete glossary with invalid params', () async {
      List<GlossaryInfo> infos = await translator.listGlossaries();
      expect(infos, isNotEmpty);
      expect(
          translator.deleteGlossary(
              glossaryId: infos.first.glossaryId, glossaryInfo: infos.first),
          throwsA(isA<AssertionError>()));
      expect(translator.deleteGlossary(), throwsA(isA<AssertionError>()));
    });

    test('delete glossary with invalid id', () {
      expect(translator.deleteGlossary(glossaryId: ''),
          throwsA(isA<AssertionError>()));
    });
  });
}
