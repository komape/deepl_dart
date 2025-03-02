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
      if (instance.preserveFormatting case final value?)
        'preserve_formatting': value,
      if (_$FormalityEnumMap[instance.formality] case final value?)
        'formality': value,
      if (_$ModelTypeEnumMap[instance.modelType] case final value?)
        'model_type': value,
      if (instance.glossaryId case final value?) 'glossary_id': value,
      if (instance.tagHandling case final value?) 'tag_handling': value,
      if (instance.outlineDetection case final value?)
        'outline_detection': value,
      if (instance.splittingTags case final value?) 'splitting_tags': value,
      if (instance.nonSplittingTags case final value?)
        'non_splitting_tags': value,
      if (instance.ignoreTags case final value?) 'ignore_tags': value,
      if (instance.context case final value?) 'context': value,
    };

const _$FormalityEnumMap = {
  Formality.more: 'more',
  Formality.less: 'less',
  Formality.preferMore: 'prefer_more',
  Formality.preferLess: 'prefer_less',
};

const _$ModelTypeEnumMap = {
  ModelType.qualityOptimized: 'quality_optimized',
  ModelType.preferQualityOptimized: 'prefer_quality_optimized',
  ModelType.latencyOptimized: 'latency_optimized',
};
