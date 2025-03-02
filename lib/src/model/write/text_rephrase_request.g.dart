// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_rephrase_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$TextRephraseRequestToJson(
        TextRephraseRequest instance) =>
    <String, dynamic>{
      'text': instance.text,
      if (instance.targetLang case final value?) 'target_lang': value,
      if (_$WritingStyleEnumMap[instance.writingStyle] case final value?)
        'writing_style': value,
      if (_$ToneEnumMap[instance.tone] case final value?) 'tone': value,
    };

const _$WritingStyleEnumMap = {
  WritingStyle.simple: 'simple',
  WritingStyle.business: 'business',
  WritingStyle.academic: 'academic',
  WritingStyle.casual: 'casual',
  WritingStyle.preferSimple: 'prefer_simple',
  WritingStyle.preferBusiness: 'prefer_business',
  WritingStyle.preferAcademic: 'prefer_academic',
  WritingStyle.preferCasual: 'prefer_casual',
};

const _$ToneEnumMap = {
  Tone.enthusiastic: 'enthusiastic',
  Tone.friendly: 'friendly',
  Tone.confident: 'confident',
  Tone.diplomatic: 'diplomatic',
  Tone.preferEnthusiastic: 'prefer_enthusiastic',
  Tone.preferFriendly: 'prefer_friendly',
  Tone.preferConfident: 'prefer_confident',
  Tone.preferDiplomatic: 'prefer_diplomatic',
};
