/// Holds the result of a text translation request.
class TextResult {
  /// [String] containing the translated text.
  final String text;

  /// [String] code of the detected source language.
  final String detectedSourceLang;

  TextResult({required this.text, required this.detectedSourceLang});

  @override
  String toString() =>
      'TextResult[text: $text, detectedSourceLang: $detectedSourceLang]';

  @override
  bool operator ==(Object other) {
    if (other is! TextResult) return false;
    return text == other.text &&
        detectedSourceLang.toLowerCase() ==
            other.detectedSourceLang.toLowerCase();
  }

  @override
  int get hashCode => text.hashCode + detectedSourceLang.toLowerCase().hashCode;
}
