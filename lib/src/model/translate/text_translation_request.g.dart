// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_translation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$TextTranslationRequestToJson(
        TextTranslationRequest instance) =>
    <String, dynamic>{
      'text': instance.text,
      if (instance.sourceLang case final value?) 'source_lang': value,
      'target_lang': instance.targetLang,
      if (TextTranslationRequest._splitSentencesToJson(instance.splitSentences)
          case final value?)
        'split_sentences': value,
      if (TextTranslationRequest._boolToJson(instance.preserveFormatting)
          case final value?)
        'preserve_formatting': value,
      if (instance.formality case final value?) 'formality': value,
      if (instance.glossaryId case final value?) 'glossary_id': value,
      if (instance.tagHandling case final value?) 'tag_handling': value,
      if (TextTranslationRequest._boolToJson(instance.outlineDetection)
          case final value?)
        'outline_detection': value,
      if (instance.splittingTags case final value?) 'splitting_tags': value,
      if (instance.nonSplittingTags case final value?)
        'non_splitting_tags': value,
      if (instance.ignoreTags case final value?) 'ignore_tags': value,
      if (instance.context case final value?) 'context': value,
    };
