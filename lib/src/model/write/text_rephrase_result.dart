import 'package:json_annotation/json_annotation.dart';

part 'text_rephrase_result.g.dart';

@JsonSerializable(
  includeIfNull: false,
  createToJson: false,
)
class TextRephraseResult {
  final String text;
  final String? targetLang;
  final String? detectedSourceLang;

  TextRephraseResult({
    required this.text,
    this.targetLang,
    this.detectedSourceLang,
  });

  factory TextRephraseResult.fromJson(Map<String, dynamic> json) =>
      _$TextRephraseResultFromJson(json);

  @override
  String toString() {
    return 'TextRephraseResult{text: "$text", targetLang: $targetLang, detectedSourceLang: $detectedSourceLang}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextRephraseResult &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          targetLang == other.targetLang &&
          detectedSourceLang == other.detectedSourceLang;

  @override
  int get hashCode =>
      text.hashCode ^ targetLang.hashCode ^ detectedSourceLang.hashCode;
}
