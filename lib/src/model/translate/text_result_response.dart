import 'package:deepl_dart/deepl_dart.dart';
import 'package:json_annotation/json_annotation.dart';

part 'text_result_response.g.dart';

@JsonSerializable(createToJson: false)
class TextResultResponse {
  final List<TextResult> translations;

  TextResultResponse(this.translations);

  factory TextResultResponse.fromJson(Map<String, dynamic> json) =>
      _$TextResultResponseFromJson(json);
}
