// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Usage _$UsageFromJson(Map<String, dynamic> json) => Usage(
      characterCount: (json['character_count'] as num).toInt(),
      characterLimit: (json['character_limit'] as num).toInt(),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      apiKeyCharacterCount: (json['api_key_character_count'] as num?)?.toInt(),
      apiKeyCharacterLimit: (json['api_key_character_limit'] as num?)?.toInt(),
      speechToTextMillisecondsCount:
          (json['speech_to_text_milliseconds_count'] as num?)?.toInt(),
      speechToTextMillisecondsLimit:
          (json['speech_to_text_milliseconds_limit'] as num?)?.toInt(),
      startTime: json['start_time'] == null
          ? null
          : DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] == null
          ? null
          : DateTime.parse(json['end_time'] as String),
    );
