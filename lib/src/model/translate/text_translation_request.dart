import 'dart:convert';

import 'package:deepl_dart/deepl_dart.dart';
import 'package:json_annotation/json_annotation.dart';

part 'text_translation_request.g.dart';

@JsonSerializable(
  includeIfNull: false,
  createFactory: false,
)
class TextTranslationRequest {
  final List<String> text;
  final String? sourceLang;
  final String targetLang;
  final String? context;
  final bool? showBilledCharacters;
  @JsonKey(toJson: _splitSentencesToJson)
  final String? splitSentences;
  final bool? preserveFormatting;
  final Formality? formality;
  final ModelType? modelType;
  final String? glossaryId;
  final String? styleId;
  final List<String>? customInstructions;
  final String? tagHandling;
  final String? tagHandlingVersion;
  final bool? outlineDetection;
  final bool? enableBetaLanguages;
  final List<String>? splittingTags;
  final List<String>? nonSplittingTags;
  final List<String>? ignoreTags;

  TextTranslationRequest({
    required this.text,
    this.sourceLang,
    required this.targetLang,
    this.context,
    this.showBilledCharacters,
    this.splitSentences,
    this.preserveFormatting,
    this.formality,
    this.modelType,
    this.glossaryId,
    this.styleId,
    this.customInstructions,
    this.tagHandling,
    this.tagHandlingVersion,
    this.outlineDetection,
    this.enableBetaLanguages,
    this.splittingTags,
    this.nonSplittingTags,
    this.ignoreTags,
  });

  TextTranslationRequest.fromOptions({
    required this.text,
    this.sourceLang,
    required this.targetLang,
    TranslateTextOptions? options,
  })  : context = null,
        showBilledCharacters = options?.showBilledCharacters,
        splitSentences = options?.splitSentences,
        preserveFormatting = options?.preserveFormatting,
        formality = options?.formality,
        modelType = options?.modelType,
        glossaryId = options?.glossaryId,
        styleId = options?.styleId,
        customInstructions = options?.customInstructions,
        tagHandling = options?.tagHandling,
        tagHandlingVersion = options?.tagHandlingVersion,
        outlineDetection = options?.outlineDetection,
        enableBetaLanguages = options?.enableBetaLanguages,
        splittingTags = options?.splittingTags,
        nonSplittingTags = options?.nonSplittingTags,
        ignoreTags = options?.ignoreTags;

  String toJson() => jsonEncode(_$TextTranslationRequestToJson(this));

  static String? _splitSentencesToJson(String? value) {
    if (value == null) {
      return null;
    }
    value = value.toLowerCase();
    if (value == 'on' || value == 'default') {
      return '1';
    } else if (value == 'off') {
      return '0';
    }
    return value;
  }
}
