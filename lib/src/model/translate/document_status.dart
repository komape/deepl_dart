import 'package:json_annotation/json_annotation.dart';

part 'document_status.g.dart';

/// Status of a document translation request.
@JsonSerializable(createToJson: false)
class DocumentStatus {
  /// One of the Status enum values below.
  final DocumentStatusCode status;

  /// Estimated time until document translation completes in seconds, otherwise
  /// undefined if unknown.
  final double? secondsRemaining;

  /// Number of characters billed for this document, or undefined if unknown or
  /// before translation is complete.
  final int? billedCharacters;

  /// A short description of the error, or undefined if no error has occurred.
  final String? errorMessage;

  DocumentStatus({
    required this.status,
    this.secondsRemaining,
    this.billedCharacters,
    this.errorMessage,
  });

  factory DocumentStatus.fromJson(Map<String, dynamic> json) =>
      _$DocumentStatusFromJson(json);

  /// True if no error has occurred, otherwise false. Note that if the document
  /// translation is in progress, this returns true.
  bool get ok => status != DocumentStatusCode.error;

  /// True if the document translation completed successfully, otherwise false.
  bool get done => status == DocumentStatusCode.done;

  @override
  String toString() =>
      'DocumentStatus[status: $status, secondsRemaining: $secondsRemaining, billedCharacters: $billedCharacters, errorMessage: $errorMessage, ok: $ok, done: $done]';
}

@JsonEnum()
enum DocumentStatusCode { queued, translating, error, done }
