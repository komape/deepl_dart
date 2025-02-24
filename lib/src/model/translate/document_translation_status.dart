import 'package:deepl_dart/src/model/translate/document_handle.dart';
import 'package:deepl_dart/src/model/translate/document_status.dart';

class DocumentTranslationStatus {
  final DocumentHandle handle;
  final DocumentStatus status;

  DocumentTranslationStatus(this.handle, this.status);
}
