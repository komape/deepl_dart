import 'package:json_annotation/json_annotation.dart';

/// Changes the writing style of your improvements.
///
/// Using the `defaultStyle` behaves the same as not using a `WritingStyle`.
///
/// Styles prefixed with `prefer` will fall back to the default style when used
/// with a language that does not support styles (this is recommended for cases
/// where no `targetLang` is set), the non-prefixed writing styles (except
/// default) will return an error in that case.
///
/// It’s not possible to include both `WritingStyle and `Tone` in a request;
/// only one or the other can be included.
@JsonEnum(fieldRename: FieldRename.snake)
enum WritingStyle {
  simple,
  business,
  academic,
  casual,
  defaultStyle,
  preferSimple,
  preferBusiness,
  preferAcademic,
  preferCasual;
}
