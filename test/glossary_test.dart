@Timeout(Duration(seconds: 60))
library;

import 'dart:io';

import 'package:deepl_dart/deepl_dart.dart';
import 'package:test/test.dart';

import 'translation_test.dart';

void main() {
  group('Glossary Tests', () {
    String? authKey = Platform.environment['DEEPL_AUTH_KEY'];
    late Glossaries glossaries;

    String name = 'test glossary';
    String sourceLang = 'en';
    String targetLang = 'de';
    GlossaryEntries entries = GlossaryEntries(entries: {'Hello': 'Hi'});

    setUpAll(() {
      assert(authKey != null, 'found no authentication key');
      glossaries = DeepL(authKey: authKey!).glossaries;
    });

    test('get glossary language pairs', () async {
      expect(glossaries.getLanguagePairs(), completion(isNotEmpty));
    });

    test('create glossary', () async {
      GlossaryInfo info = await glossaries.create(
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
          glossaries.create(
              name: '',
              sourceLang: sourceLang,
              targetLang: targetLang,
              entries: entries),
          throwsA(isA<AssertionError>()));
    });

    test('create glossary with empty entries', () {
      expect(
          glossaries.create(
              name: name,
              sourceLang: sourceLang,
              targetLang: targetLang,
              entries: GlossaryEntries()),
          throwsA(isA<AssertionError>()));
    });

    test('create glossary with invalid lang code', () {
      expect(
          glossaries.create(
              name: name,
              sourceLang: '',
              targetLang: targetLang,
              entries: entries),
          throwsA(isA<AssertionError>()));
    });

    test('create glossary with csv file', () async {
      File csvFile = File('csvFile.csv');
      csvFile.writeAsStringSync('"Hello","Hi",en,de');
      GlossaryInfo info = await glossaries.createWithCsvFile(
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
      List<GlossaryInfo> infos = await glossaries.list();
      expect(infos, isNotEmpty);
      expect(glossaries.get(infos.first.glossaryId),
          completion(equals(infos.first)));
    });

    test('get glossary with invalid id', () {
      expect(glossaries.get(''), throwsA(isA<AssertionError>()));
      expect(glossaries.get('invalid id'), throwsA(isA<DeepLError>()));
      expect(glossaries.get('96ab91fd-e715-41a1-adeb-5d701f84a483'),
          throwsA(isA<GlossaryNotFoundError>()));
    });

    test('get glossary entries', () async {
      List<GlossaryInfo> infos = await glossaries.list();
      expect(infos, isNotEmpty);
      expect(glossaries.getEntries(glossaryId: infos.first.glossaryId),
          completion(equals(entries)));
      expect(glossaries.getEntries(glossaryInfo: infos.first),
          completion(equals(entries)));
    });

    test('get glossary entries with invalid params', () async {
      List<GlossaryInfo> infos = await glossaries.list();
      expect(infos, isNotEmpty);
      expect(
          glossaries.getEntries(
              glossaryId: infos.first.glossaryId, glossaryInfo: infos.first),
          throwsA(isA<AssertionError>()));
      expect(glossaries.getEntries(), throwsA(isA<AssertionError>()));
    });

    test('get glossary entries with invalid id', () {
      expect(glossaries.getEntries(glossaryId: ''),
          throwsA(isA<AssertionError>()));
    });
    test('delete glossary', () async {
      List<GlossaryInfo> infos = await glossaries.list();
      expect(infos, isNotEmpty);
      glossaries.delete(glossaryId: infos.first.glossaryId);
      glossaries.delete(glossaryInfo: infos.first);
    });

    test('delete glossary with invalid params', () async {
      List<GlossaryInfo> infos = await glossaries.list();
      expect(infos, isNotEmpty);
      expect(
          glossaries.delete(
              glossaryId: infos.first.glossaryId, glossaryInfo: infos.first),
          throwsA(isA<AssertionError>()));
      expect(glossaries.delete(), throwsA(isA<AssertionError>()));
    });

    test('delete glossary with invalid id', () {
      expect(glossaries.delete(glossaryId: ''), throwsA(isA<AssertionError>()));
    });
  });
}
