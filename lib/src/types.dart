/// Options that can be specified when constructing a Translator.
// ignore_for_file: constant_identifier_names

class TranslatorOptions {
  /// Base URL of DeepL API, can be overridden for example for testing purposes.
  /// By default, the correct DeepL API URL is selected based on the user
  /// account type (free or paid).
  String? serverUrl;

  /// HTTP headers attached to every HTTP request. By default, no extra headers
  /// are used. Note that during Translator initialization headers for
  /// Authorization and User-Agent are added, unless they are overridden in this
  /// option.
  Map<String, String>? headers;

  /// The maximum number of failed attempts that Translator will retry, per
  /// request. By default, 5 retries are made. Note: only errors due to
  /// transient conditions are retried.
  int? maxRetries;

  /// Connection timeout used for each HTTP request retry, in milliseconds. The
  /// default timeout if this value is unspecified is 10 seconds (10000).
  int? minTimeout;

  TranslatorOptions(
      {this.serverUrl, this.headers, this.maxRetries, this.minTimeout});
}

/// Options that can be specified when translating text.
class TranslateTextOptions {
  /// Specifies how input translation text should be split into sentences.
  /// - 'on': Input translation text will be split into sentences using both
  /// newlines and punctuation, this is the default behaviour.
  /// - 'off': Input translation text will not be split into sentences. This
  /// is advisable for applications where each input translation text is only
  /// one sentence.
  /// - 'nonewlines': Input translation text will be split into sentences
  /// using only punctuation but not newlines.
  String? splitSentences;

  /// Set to true to prevent the translation engine from correcting some formatting aspects, and instead leave the formatting unchanged, default is false. */
  bool? preserveFormatting;

  /// Controls whether translations should lean toward formal or informal language.
  String? formality;

  /// Specifies the ID of a glossary to use with translation.
  String? glossaryId;

  /// Type of tags to parse before translation, options are 'html' and 'xml'.
  String? tagHandling;

  /// Set to false to disable automatic tag detection, default is true.
  bool? outlineDetection;

  /// List of XML tags that should be used to split text into sentences.
  String? splittingTags;

  /// List of XML tags that should not be used to split text into sentences.
  String? nonSplittingTags;

  /// List of XML tags containing content that should not be translated.
  String? ignoreTags;

  TranslateTextOptions(
      {this.splitSentences,
      this.preserveFormatting,
      this.formality,
      this.glossaryId,
      this.tagHandling,
      this.outlineDetection,
      this.splittingTags,
      this.nonSplittingTags,
      this.ignoreTags});
}

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
  'it',
  'ja',
  'lt',
  'lv',
  'nl',
  'pl',
  'ro',
  'ru',
  'sk',
  'sl',
  'sv',
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
final Set<String> sourceGlossaryLanguageCode = Set.of({'de', 'en', 'es', 'fr'});

/// Language codes that may be used as a target language for glossaries.
///
/// Note: although the language code type definitions are case-sensitive, this
/// package and the DeepL API accept case-insensitive language codes.
final Set<String> targetGlossaryLanguageCode = Set.of({'de', 'en', 'es', 'fr'});
