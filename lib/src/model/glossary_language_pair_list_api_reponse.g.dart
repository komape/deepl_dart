// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glossary_language_pair_list_api_reponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GlossaryLanguagePairListApiResponse
    _$GlossaryLanguagePairListApiResponseFromJson(Map<String, dynamic> json) =>
        GlossaryLanguagePairListApiResponse(
          supportedLanguages: (json['supported_languages'] as List<dynamic>)
              .map((e) =>
                  GlossaryLanguagePair.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
