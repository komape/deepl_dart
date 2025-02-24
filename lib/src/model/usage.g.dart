// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Usage _$UsageFromJson(Map<String, dynamic> json) => Usage(
      characterCount: (json['character_count'] as num).toInt(),
      characterLimit: (json['character_limit'] as num).toInt(),
      documentCount: (json['document_count'] as num?)?.toInt(),
      documentLimit: (json['document_limit'] as num?)?.toInt(),
      teamDocumentCount: (json['team_document_count'] as num?)?.toInt(),
      teamDocumentLimit: (json['team_document_limit'] as num?)?.toInt(),
    );
