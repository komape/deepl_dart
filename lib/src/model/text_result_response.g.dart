// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_result_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextResultResponse _$TextResultResponseFromJson(Map<String, dynamic> json) =>
    TextResultResponse(
      (json['translations'] as List<dynamic>)
          .map((e) => TextResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
