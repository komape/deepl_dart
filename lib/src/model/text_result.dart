import 'package:json_annotation/json_annotation.dart';

part 'text_result.g.dart';

/// Holds the result of a text translation request.
@JsonSerializable(createToJson: false)
class TextResult {
  /// [String] containing the translated text.
  final String text;

  /// [String] code of the detected source language.
  final String detectedSourceLanguage;

  TextResult({required this.text, required this.detectedSourceLanguage});

  factory TextResult.fromJson(Map<String, dynamic> json) =>
      _$TextResultFromJson(json);

  @override
  String toString() =>
      'TextResult[text: $text, detectedSourceLang: $detectedSourceLanguage]';

  @override
  bool operator ==(Object other) {
    if (other is! TextResult) return false;
    return text == other.text &&
        detectedSourceLanguage.toLowerCase() ==
            other.detectedSourceLanguage.toLowerCase();
  }

  @override
  int get hashCode =>
      text.hashCode + detectedSourceLanguage.toLowerCase().hashCode;
}
