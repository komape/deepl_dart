// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextResult _$TextResultFromJson(Map<String, dynamic> json) => TextResult(
      text: json['text'] as String,
      detectedSourceLanguage: json['detected_source_language'] as String,
      modelTypeUsed:
          $enumDecodeNullable(_$ModelTypeEnumMap, json['model_type_used']),
    );

const _$ModelTypeEnumMap = {
  ModelType.qualityOptimized: 'quality_optimized',
  ModelType.preferQualityOptimized: 'prefer_quality_optimized',
  ModelType.latencyOptimized: 'latency_optimized',
};
