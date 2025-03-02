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

  /// Number of characters counted by DeepL for billing purposes. Only present
  /// if the [showBilledCharacters] parameter is set to true.
  final int? billedCharacters;

  /// Indicates the translation model used. Only present if [modelType]
  /// parameter is included in the request.
  final ModelType? modelTypeUsed;

  TextResult({
    required this.text,
    required this.detectedSourceLanguage,
    this.billedCharacters,
    this.modelTypeUsed,
  });

  factory TextResult.fromJson(Map<String, dynamic> json) =>
      _$TextResultFromJson(json);

  @override
  String toString() =>
      'TextResult[text: $text, detectedSourceLang: $detectedSourceLanguage, billedCharacters: $billedCharacters, modelTypeUsed: $modelTypeUsed]';

  @override
  bool operator ==(Object other) {
    if (other is! TextResult) return false;
    return text == other.text &&
        detectedSourceLanguage.toLowerCase() ==
            other.detectedSourceLanguage.toLowerCase() &&
        billedCharacters == other.billedCharacters &&
        modelTypeUsed == other.modelTypeUsed;
  }

  @override
  int get hashCode =>
      text.hashCode +
      detectedSourceLanguage.toLowerCase().hashCode +
      (billedCharacters?.hashCode ?? 0) +
      (modelTypeUsed?.hashCode ?? 0);
}
