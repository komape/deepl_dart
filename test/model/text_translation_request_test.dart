import 'package:deepl_dart/src/model/text_translation_request.dart';
import 'package:test/test.dart';
import 'package:deepl_dart/deepl_dart.dart';

void main() {
  group('TextTranslationRequest Tests', () {
    group('TextTranslationRequest Context Tests', () {
      test('Context is null by default', () {
        final request = TextTranslationRequest(
          text: ['Hello, world!'],
          targetLang: 'DE',
        );

        expect(request.context, isNull);
      });

      test('Context can be set in constructor', () {
        final request = TextTranslationRequest(
          text: ['Hello, world!'],
          targetLang: 'DE',
          context: 'This is a friendly greeting.',
        );

        expect(request.context, 'This is a friendly greeting.');
      });

      test('Context is included in JSON output', () {
        final request = TextTranslationRequest(
          text: ['Hello, world!'],
          targetLang: 'DE',
          context: 'This is a friendly greeting.',
        );

        final json = request.toJson();
        expect(json, contains('"context":"This is a friendly greeting."'));
      });

      test('Context is not included in JSON when null', () {
        final request = TextTranslationRequest(
          text: ['Hello, world!'],
          targetLang: 'DE',
        );

        final json = request.toJson();
        expect(json, isNot(contains('context')));
      });

      test('Context can be set using fromOptions constructor', () {
        final options = TranslateTextOptions(
          context: 'This is an informal message.',
        );

        final request = TextTranslationRequest.fromOptions(
          text: ['How are you?'],
          targetLang: 'FR',
          options: options,
        );

        expect(request.context, 'This is an informal message.');
      });

      test('Context with special characters', () {
        final request = TextTranslationRequest(
          text: ['Test'],
          targetLang: 'IT',
          context: 'Special chars: áéíóú ñ',
        );

        expect(request.context, 'Special chars: áéíóú ñ');
        expect(
            request.toJson(), contains('"context":"Special chars: áéíóú ñ"'));
      });

      test('Empty context is included in JSON', () {
        final request = TextTranslationRequest(
          text: ['Test'],
          targetLang: 'ES',
          context: '',
        );

        final json = request.toJson();
        expect(json, contains('"context":""'));
      });
    });
  });
}
