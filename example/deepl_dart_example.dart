import 'dart:io';

import 'package:deepl_dart/deepl_dart.dart';

void main() async {
  // Construct Translator
  DeepL deepl = DeepL(authKey: '<your_auth_key>');
  DeepL(
    authKey: '<foo>',
    headers: {'my header key': 'my header value'},
    serverUrl: 'alternative deepl api server url',
    maxRetries: 42,
  );

  // ============ TRANSLATE ====================================================

  // Translate single text
  TextResult result = await deepl.translate.translateText('Hello World', 'de');
  print(result);

  // Translate single text with options
  TextResult resultWithOptions =
      await deepl.translate.translateText('Hello World', 'de',
          sourceLang: 'en',
          options: TranslateTextOptions(
            splitSentences: "0",
            preserveFormatting: true,
            formality: "more",
            glossaryId: "123",
            tagHandling: "xml",
            outlineDetection: true,
            nonSplittingTags: ["tag1", "tag2"],
            splittingTags: ["tag3", "tag4"],
            ignoreTags: ["tag5", "tag6"],
            context: "This is my context.",
          ));
  print(resultWithOptions);

  // Translate multiple texts
  List<TextResult> results = await deepl.translate
      .translateTextList(['Hello World', 'Hola Mundo'], 'de');
  print(results);

  // Translate document
  DocumentStatus status = await deepl.translate.translateDocument(
      File('<input_file_path>'), File('<output_file_path>'), 'de');
  print(status);

  // ============ WRITE ========================================================

  // Rephrase text
  TextRephraseResult rephraseResult =
      await deepl.write.rephraseText('This is a sample sentence to improve.');
  print(rephraseResult);

  // Rephrase multiple texts
  List<TextRephraseResult> rephraseResults =
      await deepl.write.rephraseTextList([
    'This is a sample sentence to improve.',
    'This is another sample sentence to improve.',
  ]);
  print(rephraseResults);

  // Rephrase text with writing style
  TextRephraseResult rephraseResultWithStyle = await deepl.write.rephraseText(
    'This is a sample sentence to improve.',
    writingStyle: WritingStyle.academic,
  );
  print(rephraseResultWithStyle);

  // Rephrase text with tone
  TextRephraseResult rephraseResultWithTone = await deepl.write.rephraseText(
    'This is a sample sentence to improve.',
    tone: Tone.diplomatic,
  );
  print(rephraseResultWithTone);

  // ============ GLOSSARY =====================================================

  // Get supported language pairs for glossaries
  List<GlossaryLanguagePair> langPairs =
      await deepl.glossaries.getLanguagePairs();
  print(langPairs);

  // Create glossary
  GlossaryInfo glossaryInfo = await deepl.glossaries.create(
    name: 'my glossary',
    sourceLang: 'en',
    targetLang: 'de',
    entries: GlossaryEntries(entries: {
      'hello': 'hi',
      'world': 'erde',
    }),
  );
  print(glossaryInfo);

  // Create glossary with CSV file
  GlossaryInfo csvGlossaryInfo = await deepl.glossaries.createWithCsvFile(
    name: 'my glossary',
    sourceLang: 'en',
    targetLang: 'de',
    csvFile: File('<csv_file_path>'),
  );
  print(csvGlossaryInfo);

  // List glossaries
  List<GlossaryInfo> glossaryList = await deepl.glossaries.list();
  print(glossaryList);

  // Get glossary info
  glossaryInfo = await deepl.glossaries.get(glossaryInfo.glossaryId);
  print(glossaryInfo);

  // Get glossary entries
  GlossaryEntries glossaryEntries =
      await deepl.glossaries.getEntries(glossaryId: glossaryInfo.glossaryId);
  print(glossaryEntries);

  // Delete glossary
  await deepl.glossaries.delete(glossaryId: glossaryInfo.glossaryId);

  // ============ LANGUAGES ====================================================

  // Get available languages
  List<Language> sourceLangs = await deepl.languages.getSources();
  print(sourceLangs);
  List<Language> targetLangs = await deepl.languages.getTargets();
  print(targetLangs);

  // ============ USAGE ========================================================

  // Get usage
  Usage usage = await deepl.getUsage();
  print(usage);
}
