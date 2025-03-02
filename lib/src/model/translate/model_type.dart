import 'package:json_annotation/json_annotation.dart';

/// Specifies which DeepL model should be used for translation. The
/// [qualityOptimized] value is supported only in the Pro v2 API at this
/// time.
///
/// Possible values are:
///
/// - [latencyOptimized] (uses lower latency “classic” translation models, which
/// support all language pairs; default value)
/// - [qualityOptimized] (uses higher latency, improved quality “next-gen”
/// translation models, which support only a subset of language pairs; if a
/// language pair that is not supported by next-gen models is included in the
/// request, it will fail. Consider using [preferQualityOptimized] instead.)
/// - [preferQualityOptimized] (prioritizes use of higher latency, improved
/// quality “next-gen” translation models, which support only a subset of Deep
/// languages; if a request includes a language pair not supported by next-gen
/// models, the request will fall back to [latencyOptimized] classic models)
///
/// Requests with the [ModelType] parameter will include an additional response
/// field [modelTypeUsed] to specify whether DeepL’s  [latencyOptimized] or
/// [qualityOptimized] model was used for translation.
///
/// Note: in the future, if DeepL’s quality optimized models achieve language
/// pair and latency performance parity with classic models, it’s possible that
/// next-gen models will be used regardless of the value passed in the
/// [ModelType] parameter.
@JsonEnum(fieldRename: FieldRename.snake)
enum ModelType {
  qualityOptimized,
  preferQualityOptimized,
  latencyOptimized;
}
