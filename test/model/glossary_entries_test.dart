import 'package:deepl_dart/deepl_dart.dart';
import 'package:deepl_dart/src/model/errors.dart';
import 'package:test/test.dart';

void main() {
  group('Glossary Entries Test', () {
    test('create with entries', () {
      GlossaryEntries entries = GlossaryEntries(entries: {'hello': 'hi'});
      expect(entries.entries.keys, contains('hello'));
      expect(entries.entries['hello'], equals('hi'));
    });

    test('add entry', () {
      GlossaryEntries entries = GlossaryEntries();
      entries.add('hello', 'hi');
      expect(entries.entries.keys, contains('hello'));
      expect(entries.entries['hello'], equals('hi'));
      expect(() => entries.add('hello', 'hallo'), throwsA(isA<DeepLError>()));
      entries.add('hello', 'hallo', overwrite: true);
      expect(entries.entries.keys, contains('hello'));
      expect(entries.entries['hello'], equals('hallo'));
    });

    group('tsv tests', () {
      test('create from tsv', () {
        GlossaryEntries entries = GlossaryEntries.constructFromTsv(
            'hello\thi\r\nworld\terde\njohn\tjohann\rdoe\tdö');
        expect(entries.entries.keys, contains('hello'));
        expect(entries.entries['hello'], equals('hi'));
        expect(entries.entries.keys, contains('world'));
        expect(entries.entries['world'], equals('erde'));
        expect(entries.entries.keys, contains('john'));
        expect(entries.entries['john'], equals('johann'));
        expect(entries.entries.keys, contains('doe'));
        expect(entries.entries['doe'], equals('dö'));
      });

      test('create from invalid tsv', () {
        expect(() => GlossaryEntries.constructFromTsv('hello\thi\thallo'),
            throwsA(isA<DeepLError>()));
        expect(() => GlossaryEntries.constructFromTsv('hello'),
            throwsA(isA<DeepLError>()));
      });

      test('to tsv', () {
        expect(GlossaryEntries(entries: {'hello': 'hi'}).toTsv(),
            equals('hello\thi'));
      });

      test('to tsv with invalid entries', () {
        expect(() => GlossaryEntries(entries: {'hello': ''}).toTsv(),
            throwsA(isA<AssertionError>()));
        expect(
            () => GlossaryEntries(entries: {'hello': String.fromCharCode(0)})
                .toTsv(),
            throwsA(isA<DeepLError>()));
        expect(
            () => GlossaryEntries(entries: {'hello': String.fromCharCode(1)})
                .toTsv(),
            throwsA(isA<DeepLError>()));
        expect(
            () => GlossaryEntries(entries: {'hello': String.fromCharCode(31)})
                .toTsv(),
            throwsA(isA<DeepLError>()));
        expect(
            () => GlossaryEntries(entries: {'hello': String.fromCharCode(127)})
                .toTsv(),
            throwsA(isA<DeepLError>()));
        expect(
            () => GlossaryEntries(entries: {'hello': String.fromCharCode(128)})
                .toTsv(),
            throwsA(isA<DeepLError>()));
        expect(
            () => GlossaryEntries(entries: {'hello': String.fromCharCode(159)})
                .toTsv(),
            throwsA(isA<DeepLError>()));
        expect(
            () =>
                GlossaryEntries(entries: {'hello': String.fromCharCode(0x2028)})
                    .toTsv(),
            throwsA(isA<DeepLError>()));
        expect(
            () =>
                GlossaryEntries(entries: {'hello': String.fromCharCode(0x2029)})
                    .toTsv(),
            throwsA(isA<DeepLError>()));
      });
    });
  });
}
