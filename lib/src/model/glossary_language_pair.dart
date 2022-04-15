import 'package:json_annotation/json_annotation.dart';

part 'glossary_language_pair.g.dart';

@JsonSerializable(createToJson: false)
class GlossaryLanguagePair {
  final String sourceLang;
  final String targetLang;

  GlossaryLanguagePair({required this.sourceLang, required this.targetLang});

  factory GlossaryLanguagePair.fromJson(Map<String, dynamic> json) =>
      _$GlossaryLanguagePairFromJson(json);
}
