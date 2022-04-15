// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glossary_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GlossaryInfo _$GlossaryInfoFromJson(Map<String, dynamic> json) => GlossaryInfo(
      glossaryId: json['glossary_id'] as String,
      name: json['name'] as String,
      ready: json['ready'] as bool,
      sourceLang: json['source_lang'] as String,
      targetLang: json['target_lang'] as String,
      creationTime: json['creation_time'] as String,
      entryCount: json['entry_count'] as int,
    );
