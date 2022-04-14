import 'package:json_annotation/json_annotation.dart';

part 'document_handle.g.dart';

/// Handle to an in-progress document translation.
@JsonSerializable(createToJson: false)
class DocumentHandle {
  /// ID of associated document request.
  final String documentId;

  /// Key of associated document request.
  final String documentKey;

  DocumentHandle(this.documentId, this.documentKey);

  factory DocumentHandle.fromJson(Map<String, dynamic> json) =>
      _$DocumentHandleFromJson(json);
}
