import 'formality.dart';
import 'model_type.dart';

/// Options that can be specified when translating text.
class TranslateTextOptions {
  /// Provides additional context to improve translation accuracy.
  /// This text is not translated itself, but helps the engine
  /// understand the surrounding meaning.
  String? context;

  /// When true, the response will include the [billedCharacters] parameter,
  /// giving the number of characters from the request that will be counted by
  /// DeepL for billing purposes.
  bool? showBilledCharacters;

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
  Formality? formality;

  /// Specifies which DeepL model should be used for translation.
  ModelType? modelType;

  /// Specifies the ID of a glossary to use with translation.
  String? glossaryId;

  /// Specify the style rule list to use for the translation.
  ///
  /// Important:  The target language has to match the language of the style
  /// rule list.
  ///
  /// Note: Any request with the [style_id] parameter enabled will use
  /// [quality_optimized] models. Requests combining [style_id] and
  /// [model_type]: [latency_optimized] will be rejected.
  String? styleId;

  /// Specify a list of instructions to customize the translation behavior. Up
  /// to 10 custom instructions can be specified, each with a maximum of 300
  /// characters.
  ///
  /// Note: Any request with the [custom_instructions] parameter enabled will
  /// default to use the [quality_optimized] model type. Requests combining
  /// [custom_instructions] and [model_type]: [latency_optimized] will be
  /// rejected.
  List<String>? customInstructions;

  /// Type of tags to parse before translation, options are 'html' and 'xml'.
  String? tagHandling;

  /// Sets which version of the tag handling algorithm should be used.
  String? tagHandlingVersion;

  /// Set to false to disable automatic tag detection, default is true.
  bool? outlineDetection;

  /// Enables additional beta languages.
  ///
  /// Note: Any request with the [enable_beta_languages] parameter enabled will
  /// use [quality_optimized] models. Requests combining
  /// [enable_beta_languages]: [true] and [model_type]: [latency_optimized] will
  /// be rejected. Beta languages do not support formality or glossaries.
  bool? enableBetaLanguages;

  /// List of XML tags that should be used to split text into sentences.
  List<String>? splittingTags;

  /// List of XML tags that should not be used to split text into sentences.
  List<String>? nonSplittingTags;

  /// List of XML tags containing content that should not be translated.
  List<String>? ignoreTags;

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
