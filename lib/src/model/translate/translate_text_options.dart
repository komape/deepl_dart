import 'formality.dart';
import 'model_type.dart';

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

  /// When true, the response will include the [billedCharacters] parameter,
  /// giving the number of characters from the request that will be counted by
  /// DeepL for billing purposes.
  bool? showBilledCharacters;

  /// Set to true to prevent the translation engine from correcting some formatting aspects, and instead leave the formatting unchanged, default is false. */
  bool? preserveFormatting;

  /// Controls whether translations should lean toward formal or informal language.
  Formality? formality;

  /// Specifies which DeepL model should be used for translation.
  ModelType? modelType;

  /// Specifies the ID of a glossary to use with translation.
  String? glossaryId;

  /// Type of tags to parse before translation, options are 'html' and 'xml'.
  String? tagHandling;

  /// Set to false to disable automatic tag detection, default is true.
  bool? outlineDetection;

  /// List of XML tags that should be used to split text into sentences.
  List<String>? splittingTags;

  /// List of XML tags that should not be used to split text into sentences.
  List<String>? nonSplittingTags;

  /// List of XML tags containing content that should not be translated.
  List<String>? ignoreTags;

  /// Provides additional context to improve translation accuracy.
  /// This text is not translated itself, but helps the engine
  /// understand the surrounding meaning.
  String? context;

  TranslateTextOptions({
    this.splitSentences,
    this.showBilledCharacters,
    this.preserveFormatting,
    this.formality,
    this.modelType,
    this.glossaryId,
    this.tagHandling,
    this.outlineDetection,
    this.splittingTags,
    this.nonSplittingTags,
    this.ignoreTags,
    this.context,
  });
}
