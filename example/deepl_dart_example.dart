import 'dart:io';

import 'package:deepl_dart/deepl_dart.dart';

void main() async {
  // Construct Translator
  Translator translator = Translator(authKey: '<your_auth_key>');
  Translator(
    authKey: '<foo>',
    headers: {'my header key': 'my header value'},
    serverUrl: 'alternative deepl api server url',
    maxRetries: 42,
  );

  // ============ TRANSLATE ====================================================

  // Get available languages
  List<Language> sourceLangs = await translator.getSourceLanguages();
  print(sourceLangs);
  List<Language> targetLangs = await translator.getTargetLanguages();
  print(targetLangs);

  // Translate single text
  TextResult result =
      await translator.translateTextSingular('Hello World', 'de');
  print(result);

  // Translate single text with options
  TextResult resultWithOptions =
      await translator.translateTextSingular('Hello World', 'de',
          options: TranslateTextOptions(
            splitSentences: "0",
            preserveFormatting: true,
            formality: "more",
            glossaryId: "123",
            tagHandling: "xml",
            outlineDetection: true,
            nonSplittingTags: "tag1,tag2",
            splittingTags: "tag3,tag4",
            ignoreTags: "tag5,tag6",
            context: "This is my context.",
          ));
  print(resultWithOptions);

  // Translate multiple texts
  List<TextResult> results =
      await translator.translateTextList(['Hello World', 'Hola Mundo'], 'de');
  print(results);

  // Translate document
  DocumentStatus status = await translator.translateDocument(
      File('<input_file_path>'), File('<output_file_path>'), 'de');
  print(status);

  // ============ GLOSSARY =====================================================

  // Get supported language pairs for glossaries
  List<GlossaryLanguagePair> langPairs =
      await translator.getGlossaryLanguagePairs();
  print(langPairs);

  // Create glossary
  GlossaryInfo glossaryInfo = await translator.createGlossary(
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
  GlossaryInfo csvGlossaryInfo = await translator.createGlossaryWithCsvFile(
    name: 'my glossary',
    sourceLang: 'en',
    targetLang: 'de',
    csvFile: File('<csv_file_path>'),
  );
  print(csvGlossaryInfo);

  // List glossaries
  List<GlossaryInfo> glossaryList = await translator.listGlossaries();
  print(glossaryList);

  // Get glossary info
  glossaryInfo = await translator.getGlossary(glossaryInfo.glossaryId);
  print(glossaryInfo);

  // Get glossary entries
  GlossaryEntries glossaryEntries =
      await translator.getGlossaryEntries(glossaryId: glossaryInfo.glossaryId);
  print(glossaryEntries);

  // Delete glossary
  await translator.deleteGlossary(glossaryId: glossaryInfo.glossaryId);

  // ============ USAGE ========================================================

  // Get usage
  Usage usage = await translator.getUsage();
  print(usage);
}
