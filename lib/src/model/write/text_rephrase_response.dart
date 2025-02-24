import 'package:deepl_dart/src/model/write/text_rephrase_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'text_rephrase_response.g.dart';

@JsonSerializable(
  includeIfNull: false,
  createToJson: false,
)
class TextRephraseResponse {
  final List<TextRephraseResult> improvements;

  TextRephraseResponse({
    required this.improvements,
  });

  factory TextRephraseResponse.fromJson(Map<String, dynamic> json) =>
      _$TextRephraseResponseFromJson(json);
}
