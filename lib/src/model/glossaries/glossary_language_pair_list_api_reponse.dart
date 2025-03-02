import 'package:deepl_dart/src/model/glossaries/glossary_language_pair.dart';
import 'package:json_annotation/json_annotation.dart';

part 'glossary_language_pair_list_api_reponse.g.dart';

@JsonSerializable(createToJson: false)
class GlossaryLanguagePairListApiResponse {
  final List<GlossaryLanguagePair> supportedLanguages;

  GlossaryLanguagePairListApiResponse({required this.supportedLanguages});

  factory GlossaryLanguagePairListApiResponse.fromJson(
          Map<String, dynamic> json) =>
      _$GlossaryLanguagePairListApiResponseFromJson(json);
}
