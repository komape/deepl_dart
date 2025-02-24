// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glossary_info_list_api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GlossaryInfoListApiResponse _$GlossaryInfoListApiResponseFromJson(
        Map<String, dynamic> json) =>
    GlossaryInfoListApiResponse(
      glossaries: (json['glossaries'] as List<dynamic>)
          .map((e) => GlossaryInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
