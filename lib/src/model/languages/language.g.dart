// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Language _$LanguageFromJson(Map<String, dynamic> json) => Language(
      languageCode: json['language'] as String,
      name: json['name'] as String,
      isTranslationSourceLanguage:
          json['is_translation_source_language'] as bool? ?? false,
      isTranslationTargetLanguage:
          json['is_translation_target_language'] as bool? ?? false,
      isBetaLanguage: json['is_beta_language'] as bool? ?? false,
      isWriteLanguage: json['is_write_language'] as bool? ?? false,
      supportsFormality: json['supports_formality'] as bool? ?? false,
    );
