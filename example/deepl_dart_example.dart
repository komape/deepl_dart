import 'package:deepl_dart/deepl_dart.dart';

void main() async {
  // Construct Translator
  Translator translator = Translator(authKey: '<your_auth_key>');

  // Translate text
  TextResult result = await translator.translateTextSingular(
      text: 'Hello World', targetLang: 'de');
  print(result);

  // Translate list of texts
  List<TextResult> results = await translator
      .translateTextList(texts: ['Hello', 'World'], targetLang: 'de');
  print(results);
}
