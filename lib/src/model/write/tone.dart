import 'package:json_annotation/json_annotation.dart';

/// Changes the tone of your improvements.
///
/// Using the `defaultTone` behaves the same as not using a `Tone`.
///
/// Tones prefixed with `prefer` will fall back to the default tone when used
/// with a language that does not support tones (this is recommended for cases
/// where no `targetLang` is set), the non-prefixed tone (except default) will
/// return an error in that case.
///
/// It’s not possible to include both `WritingStyle and `Tone` in a request;
/// only one or the other can be included.
@JsonEnum(fieldRename: FieldRename.snake)
enum Tone {
  enthusiastic,
  friendly,
  confident,
  diplomatic,
  defaultTone,
  preferEnthusiastic,
  preferFriendly,
  preferConfident,
  preferDiplomatic;
}
