import 'package:deepl_dart/src/model/usage/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'usage.g.dart';

/// Retrieve usage information within the current billing period together with
/// the corresponding account limits. For Pro API users, the /usage endpoint
/// returns the following:
///
/// - Text and document translation characters consumed in the current billing
/// period in total and for the API key used to make the request
/// - Text improvement (/write) characters consumed in the current billing
/// period in total and for the API key used to make the request
/// - Total characters consumed in the current billing period by the API key
/// used to make the request
/// - The key-level character limit for the API key used to make the request, if
/// applicable (if a key-level usage limit is set, it will be reflected in the
/// [apiKeyCharacterLimit] field in the response; 1000000000000 will be returned
/// if no key-level limit is set)
/// - The current billing period start timestamp
/// - The current billing period end timestamp
/// - Total characters consumed in the current billing period
/// - Subscription-level character limit that applies to the current billing
/// period (if Cost Control is set, it will be reflected in the [characterLimit]
/// field in the response; 1000000000000 will be returned if no limit is set)
///
/// Note that responses for Free API and Pro Classic users only contain
/// [characterCount] and [characterLimit].
///
/// The value in the [characterCount] field includes both text and document
/// translations as well as text improvement (DeepL API for Write) characters.
/// Characters are counted based on the source text length in Unicode code
/// points, so for example “A”, “Δ”, “あ”, and “深” are each counted as a single
/// character.
///
/// The [anyLimitReached] function checks if any usage type is exceeded.
@JsonSerializable(createToJson: false)
class Usage {
  /// Characters translated so far in the current billing period.
  final int characterCount;

  /// Current maximum number of characters that can be translated per billing
  /// period. If cost control is set, the cost control limit will be returned in this field.
  final int characterLimit;

  /// Per-product usage details.
  final List<Product>? products;

  /// Total characters used by this API key in the current period.
  final int? apiKeyCharacterCount;

  /// Character limit for this API key in the current period.
  final int? apiKeyCharacterLimit;

  /// Milliseconds of speech-to-text used in the current period.
  final int? speechToTextMillisecondsCount;

  /// Milliseconds of speech-to-text limit in the current period.
  final int? speechToTextMillisecondsLimit;

  /// Start time of the current billing period (ISO 8601).
  final DateTime? startTime;

  /// End time of the current billing period (ISO 8601).
  final DateTime? endTime;

  Usage({
    required this.characterCount,
    required this.characterLimit,
    this.products,
    this.apiKeyCharacterCount,
    this.apiKeyCharacterLimit,
    this.speechToTextMillisecondsCount,
    this.speechToTextMillisecondsLimit,
    this.startTime,
    this.endTime,
  });

  factory Usage.fromJson(Map<String, dynamic> json) => _$UsageFromJson(json);

  /// Returns true if any usage type limit has been reached or passed, otherwise
  /// false.
  bool anyLimitReached() {
    return characterCount >= characterLimit ||
        (apiKeyCharacterCount ?? 0) >= (apiKeyCharacterLimit ?? 1) ||
        (speechToTextMillisecondsCount ?? 0) >=
            (speechToTextMillisecondsLimit ?? 1);
  }

  /// Converts the usage details to a human-readable string.
  @override
  String toString() =>
      'Usage[characterCount: $characterCount, characterLimit: $characterLimit, apiKeyCharacterCount: $apiKeyCharacterCount, apiKeyCharacterLimit: $apiKeyCharacterLimit, speechToTextMillisecondsCount: $speechToTextMillisecondsCount, speechToTextMillisecondsLimit: $speechToTextMillisecondsLimit]';
}
