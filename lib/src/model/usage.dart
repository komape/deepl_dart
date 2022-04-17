import 'package:json_annotation/json_annotation.dart';

part 'usage.g.dart';

/// Information about the API usage: how much has been translated in this
/// billing period, and the maximum allowable amount.
///
/// Depending on the account type, different usage types are included: the
/// [characterCount]/[characterLimit], [documentCount]/[documentLimit] and
/// [teamDocumentCount]/[teamDocumentLimit] fields provide details about each
/// corresponding usage type, allowing each usage type to be checked
/// individually. The [anyLimitReached] function checks if any usage type is
/// exceeded.
@JsonSerializable(createToJson: false)
class Usage {
  final int characterCount;
  final int characterLimit;
  final int? documentCount;
  final int? documentLimit;
  final int? teamDocumentCount;
  final int? teamDocumentLimit;

  Usage({
    required this.characterCount,
    required this.characterLimit,
    this.documentCount,
    this.documentLimit,
    this.teamDocumentCount,
    this.teamDocumentLimit,
  });

  factory Usage.fromJson(Map<String, dynamic> json) => _$UsageFromJson(json);

  /// Returns true if any usage type limit has been reached or passed, otherwise
  /// false.
  bool anyLimitReached() {
    return characterCount >= characterLimit ||
        (documentCount ?? 0) >= (documentLimit ?? 1) ||
        (teamDocumentCount ?? 0) >= (teamDocumentLimit ?? 1);
  }

  /// Converts the usage details to a human-readable string.
  @override
  String toString() =>
      'Usage[characterCount: $characterCount, characterLimit: $characterLimit, documentCount: $documentCount, documentLimit: $documentLimit, teamDocumentCount: $teamDocumentCount, teamDocumentLimit: $teamDocumentLimit]';
}
