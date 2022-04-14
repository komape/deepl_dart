import 'dart:convert';

import 'package:deepl_dart/src/errors.dart';
import 'package:deepl_dart/src/model/text_result.dart';

/// Parses the given JSON string to an array of TextResult objects.
List<TextResult> parseTextResultArray(String json) {
  try {
    Map<String, dynamic> map = jsonDecode(json);
    List<dynamic> translations = map['translations'];
    return translations
        .map((translation) => translation as Map<String, dynamic>)
        .map((translation) {
      return TextResult(
          text: translation['text'],
          detectedSourceLang: translation['detected_source_language']);
    }).toList();
  } catch (error) {
    throw DeepLError(message: 'Error parsing response JSON: $error');
  }
}
