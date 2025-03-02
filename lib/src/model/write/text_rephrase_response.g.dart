// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_rephrase_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextRephraseResponse _$TextRephraseResponseFromJson(
        Map<String, dynamic> json) =>
    TextRephraseResponse(
      improvements: (json['improvements'] as List<dynamic>)
          .map((e) => TextRephraseResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
