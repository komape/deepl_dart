/// Options that can be specified when translating documents.
class DocumentTranslateOptions {
  /// Controls whether translations should lean toward formal or informal
  /// language.
  String? formality;

  /// Specifies the ID of a glossary to use with translation.
  String? glossaryId;

  /// Filename including extension, only required when translating documents as
  /// streams.
  String? filename;

  DocumentTranslateOptions({this.formality, this.glossaryId, this.filename});
}
