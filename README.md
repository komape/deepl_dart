# deepl_dart

[![Dart Analyze & Test](https://github.com/komape/deepl_dart/actions/workflows/dart_analyze_test.yml/badge.svg)](https://github.com/komape/deepl_dart/actions/workflows/dart_analyze_test.yml)

**This package is maintained by volunteers but is not a supported DeepL product and not maintained by DeepL SE. Issues here are answered by maintainers and other community members on GitHub on a best-effort basis.**

This package is heavily inspired by the [official Node.js Client Library for the DeepL API](https://github.com/DeepLcom/deepl-node):

>The DeepL API is a language translation API that allows other computer programs to send texts and documents to DeepL's servers and receive high-quality translations. This opens a whole universe of opportunities for developers: any translation product you can imagine can now be built on top of DeepL's best-in-class translation technology.
>
>The DeepL *[Dart]* library offers a convenient way for applications written for *[Dart and Flutter]* to interact with the DeepL API. We intend to support all API functions with the library, though support for new features may be added to the library after they’re added to the API. *~ DeepL*

## Getting an authentication key

To use the package, you'll need an API authentication key. To get a key, [please create an account here](https://www.deepl.com/pro/change-plan#developer). You can translate up to 500,000characters/month for free.

## Roadmap

- [x] [Translating text](https://www.deepl.com/de/docs-api/translating-text/)
- [x] [Translating Document](https://www.deepl.com/de/docs-api/translating-documents/)
- [ ] [Managing Glossaries](https://www.deepl.com/de/docs-api/managing-glossaries/)
- [ ] [Monitoring usage](https://www.deepl.com/de/docs-api/other-functions/monitoring-usage/)
- [ ] [Listing supported languages](https://www.deepl.com/de/docs-api/other-functions/listing-supported-languages/)

## Installation

In the `dependencies`: section of your `pubspec.yaml`, add the following line:

```yaml
dependencies:
  deepl_dart: <latest_version>
```

## Usage

Import the package and construct a `Translator`. The required argument `authKey` is a string containing your API authentication key as found in your [DeepL Pro Account](https://www.deepl.com/pro-account/).

Be careful not to expose your key, for example when sharing source code.

An example using `async/await`:

```dart
import 'package:deepl_dart/deepl_dart.dart';

void main() async {
  // Construct Translator
  Translator translator = Translator(authKey: '<your_auth_key>');

  // Translate text
  TextResult result =
      await translator.translateTextSingular('Hello World', 'de');
  print(result);

  // Translate list of texts
  List<TextResult> results =
      await translator.translateTextList(['Hello World', 'Hola Mundo'], 'de');
  print(results);
}
```

This example is for demonstration purposes only. In production code, the authentication key should not be hard-coded, but instead fetched from a configuration file or environment variable.

## Additional information

For more information, check out the [official Node.js Client Library for the DeepL API](https://github.com/DeepLcom/deepl-node) and the [DeepL API Docs](https://www.deepl.com/docs-api).
