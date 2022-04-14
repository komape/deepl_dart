// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentStatus _$DocumentStatusFromJson(Map<String, dynamic> json) =>
    DocumentStatus(
      status: $enumDecode(_$DocumentStatusCodeEnumMap, json['status']),
      secondsRemaining: (json['seconds_remaining'] as num?)?.toDouble(),
      billedCharacters: json['billed_characters'] as int?,
      errorMessage: json['error_message'] as String?,
    );

const _$DocumentStatusCodeEnumMap = {
  DocumentStatusCode.queued: 'queued',
  DocumentStatusCode.translating: 'translating',
  DocumentStatusCode.error: 'error',
  DocumentStatusCode.done: 'done',
};
