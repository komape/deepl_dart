/// Language codes that may be used as a source or target language.
///
/// Note: although the language code type definitions are case-sensitive, this
/// package and the DeepL API accept case-insensitive language codes.
@Deprecated('Use LanguageCodes class for all language codes instead.')
final Set<String> commonLanguageCode = {
  'ar',
  'bg',
  'cs',
  'da',
  'de',
  'el',
  'es',
  'et',
  'fi',
  'fr',
  'he',
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
  'th',
  'tr',
  'uk',
  'vi',
  'zh',
};

/// Language codes that may be used as a source language.
///
/// Note: although the language code type definitions are case-sensitive, this
/// package and the DeepL API accept case-insensitive language codes.
@Deprecated(
    'Use Language.getSourceLanguages() to get the list of source languages instead.')
final Set<String> sourceLanguageCode =
    commonLanguageCode.intersection({'en', 'pt'});

/// Language codes that may be used as a target language.
///
/// Note: although the language code type definitions are case-sensitive, this
/// package and the DeepL API accept case-insensitive language codes.
@Deprecated(
    'Use Language.getTargetLanguages() to get the list of target languages instead.')
final Set<String> targetLanguageCode = commonLanguageCode
    .intersection({'es-419', 'en-GB', 'en-US', 'pt-BR', 'pt-PT', 'zh-HANT'});

/// All language codes, including source-only and target-only language codes.
///
/// Note: although the language code type definitions are case-sensitive, this
/// package and the DeepL API accept case-insensitive language codes.
@Deprecated('Use Language class for all language codes instead.')
final Set<String> languageCode =
    sourceLanguageCode.intersection(targetLanguageCode);

/// Language codes that may be used as a source language for glossaries.
///
/// Note: although the language code type definitions are case-sensitive, this package and the DeepL
/// API accept case-insensitive language codes.
@Deprecated('All languages support glossaries now. Except beta languages.')
final Set<String> sourceGlossaryLanguageCode = Set.of({
  'ar',
  'bg',
  'cs',
  'de',
  'en',
  'el',
  'es',
  'et',
  'fr',
  'he',
  'hu',
  'id',
  'ja',
});

/// Language codes that may be used as a target language for glossaries.
///
/// Note: although the language code type definitions are case-sensitive, this
/// package and the DeepL API accept case-insensitive language codes.
@Deprecated('All languages support glossaries now. Except beta languages.')
final Set<String> targetGlossaryLanguageCode =
    Set.of({'de', 'en', 'es', 'fr', 'ja'});
