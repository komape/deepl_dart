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
      if (instance.context case final value?) 'context': value,
      if (instance.showBilledCharacters case final value?)
        'show_billed_characters': value,
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
      if (instance.styleId case final value?) 'style_id': value,
      if (instance.customInstructions case final value?)
        'custom_instructions': value,
      if (instance.tagHandling case final value?) 'tag_handling': value,
      if (instance.tagHandlingVersion case final value?)
        'tag_handling_version': value,
      if (instance.outlineDetection case final value?)
        'outline_detection': value,
      if (instance.enableBetaLanguages case final value?)
        'enable_beta_languages': value,
      if (instance.splittingTags case final value?) 'splitting_tags': value,
      if (instance.nonSplittingTags case final value?)
        'non_splitting_tags': value,
      if (instance.ignoreTags case final value?) 'ignore_tags': value,
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
