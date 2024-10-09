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
  @JsonKey(toJson: _splitSentencesToJson)
  final String? splitSentences;
  @JsonKey(toJson: _boolToJson)
  final bool? preserveFormatting;
  final String? formality;
  final String? glossaryId;
  final String? tagHandling;
  @JsonKey(toJson: _boolToJson)
  final bool? outlineDetection;
  final String? splittingTags;
  final String? nonSplittingTags;
  final String? ignoreTags;
  final String? context;

  TextTranslationRequest({
    required this.text,
    this.sourceLang,
    required this.targetLang,
    this.splitSentences,
    this.preserveFormatting,
    this.formality,
    this.glossaryId,
    this.tagHandling,
    this.outlineDetection,
    this.splittingTags,
    this.nonSplittingTags,
    this.ignoreTags,
    this.context,
  });

  TextTranslationRequest.fromOptions({
    required this.text,
    this.sourceLang,
    required this.targetLang,
    TranslateTextOptions? options,
  })  : splitSentences = options?.splitSentences,
        preserveFormatting = options?.preserveFormatting,
        formality = options?.formality,
        glossaryId = options?.glossaryId,
        tagHandling = options?.tagHandling,
        outlineDetection = options?.outlineDetection,
        splittingTags = options?.splittingTags,
        nonSplittingTags = options?.nonSplittingTags,
        ignoreTags = options?.ignoreTags,
        context = options?.context;

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

  static String? _boolToJson(bool? value) {
    if (value == null) return null;
    return value ? '1' : '0';
  }
}
