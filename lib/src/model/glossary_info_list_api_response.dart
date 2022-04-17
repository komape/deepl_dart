import 'package:deepl_dart/src/model/glossary_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'glossary_info_list_api_response.g.dart';

@JsonSerializable(createToJson: false)
class GlossaryInfoListApiResponse {
  final List<GlossaryInfo> glossaries;

  GlossaryInfoListApiResponse({required this.glossaries});

  factory GlossaryInfoListApiResponse.fromJson(Map<String, dynamic> json) =>
      _$GlossaryInfoListApiResponseFromJson(json);
}
