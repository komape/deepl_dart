// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_translation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$TextTranslationRequestToJson(
    TextTranslationRequest instance) {
  final val = <String, dynamic>{
    'text': instance.text,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('source_lang', instance.sourceLang);
  val['target_lang'] = instance.targetLang;
  writeNotNull('split_sentences',
      TextTranslationRequest._splitSentencesToJson(instance.splitSentences));
  writeNotNull('preserve_formatting',
      TextTranslationRequest._boolToJson(instance.preserveFormatting));
  writeNotNull('formality', instance.formality);
  writeNotNull('glossary_id', instance.glossaryId);
  writeNotNull('tag_handling', instance.tagHandling);
  writeNotNull('outline_detection',
      TextTranslationRequest._boolToJson(instance.outlineDetection));
  writeNotNull('splitting_tags', instance.splittingTags);
  writeNotNull('non_splitting_tags', instance.nonSplittingTags);
  writeNotNull('ignore_tags', instance.ignoreTags);
  writeNotNull('context', instance.context);
  return val;
}
