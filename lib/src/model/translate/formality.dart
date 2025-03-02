import 'package:json_annotation/json_annotation.dart';

/// Sets whether the translated text should lean towards formal or informal
/// language.
///
/// Setting this parameter with a target language that does not support
/// formality will fail, unless one of the prefer... options are used. Possible
/// options are:
///
/// - [more] - for a more formal language
/// - [less] - for a more informal language
/// - [preferMore] - for a more formal language if available, otherwise fallback
/// to default formality
/// - [preferLess] - for a more informal language if available, otherwise
/// fallback to default formality
@JsonEnum(fieldRename: FieldRename.snake)
enum Formality {
  more,
  less,
  preferMore,
  preferLess;
}
