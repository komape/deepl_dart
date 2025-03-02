import 'package:json_annotation/json_annotation.dart';

part 'language.g.dart';

/// Information about a language supported by DeepL translator.
@JsonSerializable(createToJson: false)
class Language {
  /// Language code according to ISO 639-1, for example 'en'. Some target
  /// languages also include the regional variant according to ISO 3166-1, for
  /// example 'en-US'.
  @JsonKey(name: 'language')
  final String languageCode;

  /// Name of the language in English.
  final String name;

  /// Only defined for target languages. If defined, specifies whether the
  /// formality option is available for this target language.
  final bool? supportsFormality;

  Language({
    required this.languageCode,
    required this.name,
    this.supportsFormality,
  });

  factory Language.fromJson(Map<String, dynamic> json) =>
      _$LanguageFromJson(json);

  @override
  String toString() =>
      'Language[language: $languageCode, name: $name, supportsFormality: $supportsFormality]';
}
