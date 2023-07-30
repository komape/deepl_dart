/// Language codes that may be used as a source or target language.
///
/// Note: although the language code type definitions are case-sensitive, this
/// package and the DeepL API accept case-insensitive language codes.
final Set<String> commonLanguageCode = {
  'bg',
  'cs',
  'da',
  'de',
  'el',
  'es',
  'et',
  'fi',
  'fr',
  'hu',
  'id',
  'it',
  'ja',
  'ko',
  'lt',
  'lv',
  'nb',
  'nl',
  'pl',
  'ro',
  'ru',
  'sk',
  'sl',
  'sv',
  'tr',
  'uk',
  'zh',
};

/// Language codes that may be used as a source language.
///
/// Note: although the language code type definitions are case-sensitive, this
/// package and the DeepL API accept case-insensitive language codes.
final Set<String> sourceLanguageCode =
    commonLanguageCode.intersection({'en', 'pt'});

/// Language codes that may be used as a target language.
///
/// Note: although the language code type definitions are case-sensitive, this
/// package and the DeepL API accept case-insensitive language codes.
final Set<String> targetLanguageCode =
    commonLanguageCode.intersection({'en-GB', 'en-US', 'pt-BR', 'pt-PT'});

/// All language codes, including source-only and target-only language codes.
///
/// Note: although the language code type definitions are case-sensitive, this
/// package and the DeepL API accept case-insensitive language codes.
final Set<String> languageCode =
    sourceLanguageCode.intersection(targetLanguageCode);

/// Language codes that may be used as a source language for glossaries.
///
/// Note: although the language code type definitions are case-sensitive, this package and the DeepL
/// API accept case-insensitive language codes.
final Set<String> sourceGlossaryLanguageCode =
    Set.of({'de', 'en', 'es', 'fr', 'ja'});

/// Language codes that may be used as a target language for glossaries.
///
/// Note: although the language code type definitions are case-sensitive, this
/// package and the DeepL API accept case-insensitive language codes.
final Set<String> targetGlossaryLanguageCode =
    Set.of({'de', 'en', 'es', 'fr', 'ja'});
