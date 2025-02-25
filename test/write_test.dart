import 'dart:io';

import 'package:deepl_dart/deepl_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Writer Tests', () {
    String? authKey = Platform.environment['DEEPL_AUTH_KEY'];
    late Write write;

    setUpAll(() {
      assert(authKey != null, 'found no authentication key');
      write = DeepL(authKey: authKey!).write;
    });

    group('Rephrase Text', () {
      test('rephrase text', () {
        expect(
          write.rephraseText('This is a sample sentence to improve.'),
          completion(equals(TextRephraseResult(
            text: 'This is an example sentence to improve.',
          ))),
        );
      });
      test('rephrase text list', () {
        expect(
          write.rephraseTextList([
            'This is a sample sentence to improve.',
            'This is another sample sentence to improve.'
          ]),
          completion(equals([
            TextRephraseResult(
              text: 'This is an example sentence to improve.',
            ),
            TextRephraseResult(
              text: 'This is another example sentence to improve.',
            )
          ])),
        );
      });
      test('rephrase text with writing style', () {
        expect(
          write.rephraseText('This is a sample sentence to improve.',
              writingStyle: WritingStyle.academic),
          completion(equals(TextRephraseResult(
            text:
                'The following sentence exemplifies the kind of improvement that is sought.',
          ))),
        );
      });
      test('rephrase text with tone', () {
        expect(
          write.rephraseText('This is a sample sentence to improve.',
              tone: Tone.diplomatic),
          completion(equals(TextRephraseResult(
            text: 'This is a sample sentence that could be improved.',
          ))),
        );
      });
      test('rephrase text with target lang', () {
        expect(
          write.rephraseText('This is a sample sentence to improve.',
              targetLang: 'DE'),
          completion(equals(TextRephraseResult(
            text: 'Dies ist ein Beispielsatz, der verbessert werden kann.',
          ))),
        );
      });
      test('rephrase text with writing style and tone', () {
        expect(
            write.rephraseText('This is a sample sentence to improve.',
                writingStyle: WritingStyle.academic, tone: Tone.diplomatic),
            throwsA(isA<AssertionError>()));
      });
    });
  });
}
