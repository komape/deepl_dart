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
