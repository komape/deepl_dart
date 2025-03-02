import 'package:json_annotation/json_annotation.dart';

import 'model_type.dart';

part 'text_result.g.dart';

/// Holds the result of a text translation request.
@JsonSerializable(createToJson: false)
class TextResult {
  /// [String] containing the translated text.
  final String text;

  /// [String] code of the detected source language.
  final String detectedSourceLanguage;

  /// Indicates the translation model used. Only present if [modelType]
  /// parameter is included in the request.
  final ModelType? modelTypeUsed;

  TextResult(
      {required this.text,
      required this.detectedSourceLanguage,
      this.modelTypeUsed});

  factory TextResult.fromJson(Map<String, dynamic> json) =>
      _$TextResultFromJson(json);

  @override
  String toString() =>
      'TextResult[text: $text, detectedSourceLang: $detectedSourceLanguage, modelTypeUsed: $modelTypeUsed]';

  @override
  bool operator ==(Object other) {
    if (other is! TextResult) return false;
    return text == other.text &&
        detectedSourceLanguage.toLowerCase() ==
            other.detectedSourceLanguage.toLowerCase() &&
        modelTypeUsed == other.modelTypeUsed;
  }

  @override
  int get hashCode =>
      text.hashCode +
      detectedSourceLanguage.toLowerCase().hashCode +
      modelTypeUsed.hashCode;
}
