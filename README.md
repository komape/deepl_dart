# [deepl_dart](https://pub.dev/packages/deepl_dart)

[![Dart Analyze & Test](https://github.com/komape/deepl_dart/actions/workflows/dart_analyze_test.yml/badge.svg)](https://github.com/komape/deepl_dart/actions/workflows/dart_analyze_test.yml) [![codecov](https://codecov.io/gh/komape/deepl_dart/branch/master/graph/badge.svg?token=RF7B8BPD77)](https://codecov.io/gh/komape/deepl_dart)

**This package is maintained by volunteers but is not a supported DeepL product and not maintained by DeepL SE. Issues here are answered by maintainers and other community members on GitHub on a best-effort basis.**

This package is heavily inspired by the [official Node.js Client Library for the DeepL API](https://github.com/DeepLcom/deepl-node):

>The DeepL API is a language translation API that allows other computer programs to send texts and documents to DeepL's servers and receive high-quality translations. This opens a whole universe of opportunities for developers: any translation product you can imagine can now be built on top of DeepL's best-in-class translation technology.
>
>The DeepL *[Dart]* library offers a convenient way for applications written for *[Dart and Flutter]* to interact with the DeepL API. We intend to support all API functions with the library, though support for new features may be added to the library after they’re added to the API. *~ DeepL*

- [Getting an authentication key](#getting-an-authentication-key)
- [Roadmap](#roadmap)
- [Installation](#installation)
- [Usage](#usage)
  - [Translator Object](#translator-object)
  - [Translate Text](#translate-text)
  - [Translate Documents](#translate-documents)
  - [Manage Glossaries](#manage-glossaries)
  - [Translation Usage](#translation-usage)
- [Additional information](#additional-information)

## Getting an authentication key

To use the package, you'll need an API authentication key. To get a key, [please create an account here](https://www.deepl.com/pro/change-plan#developer). You can translate up to 500,000characters/month for free.

## Roadmap

- [x] [Translating text](https://www.deepl.com/de/docs-api/translating-text/)
- [x] [Translating Document](https://www.deepl.com/de/docs-api/translating-documents/)
- [x] [Managing Glossaries](https://www.deepl.com/de/docs-api/managing-glossaries/)
- [x] [Monitoring usage](https://www.deepl.com/de/docs-api/other-functions/monitoring-usage/)
- [x] [Listing supported languages](https://www.deepl.com/de/docs-api/other-functions/listing-supported-languages/)

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

### Translator Object

All requests to the DeepL API go via a `Translator` object. A `auth_key` from DeepL is required to send requests. Pass it via `Translator` constructor:

```dart
Translator translator = Translator(authKey: '<your_auth_key>');
```

This example is for demonstration purposes only. In production code, the authentication key should not be hard-coded, but instead fetched from a configuration file or environment variable.

Add further arguments to the constructor:

```dart
Translator translator =   Translator(
    authKey: '<your_auth_key>',
    headers: {'My-Header-Key': 'my header value'},
    serverUrl: 'https://alternative.deepl.api.server.url',
    maxRetries: 42,
  );

```

### Translate Text

The basic text translation takes one or more texts and a target language to return the translated text. DeepL detects the source language automatically.

```dart
// Translate a single text
TextResult result =
    await translator.translateTextSingular('Hello World', 'de');

// Translate multiple texts
List<TextResult> results =
    await translator.translateTextList(['Hello World', 'Hola Mundo'], 'de');
```

Optionally you can pass the source language as well.

```dart
TextResult result = await translator
    .translateTextSingular('Hello World', 'de', sourceLang: 'en');
```

If you unsure which languages are supported you can request them.

```dart
  List<Language> sourceLangs = await translator.getSourceLanguages();
  List<Language> targetLangs = await translator.getTargetLanguages();
```

You can pass a `TranslateTextOptions` object to configure the translation.

```dart
TextResult result = await translator.translateTextSingular(
  'Hello World',
  'de',
  options: TranslateTextOptions(
      splitSentences: 'on',
      formality: 'less',
      glossaryId: myGlossary.glossaryId,
  ),
);
```

### Translate Documents

DeepL also supports the translation of documents. At the moment of writing the following file types are supported:

- `.docx`
- `.pptx`
- `.pdf`
- `.txt`

The document translation method internally uploads given input file, waits for the translation to finish and downloads the file into the given output file. As well as with the text translation a target language is required.

```dart
DocumentStatus status = await translator.translateDocument(
    File('<input_file_path>'), File('<output_file_path>'), 'de');
```

Optionally you can pass the source language as well.

```dart
DocumentStatus status = await translator.translateDocument(
    File('<input_file_path>'), File('<output_file_path>'), 'de',
    sourceLang: 'en');
```

You can pass a `DocumentTranslateOptions` object to configure the translation.

```dart
DocumentStatus status = await translator.translateDocument(
  File('<input_file_path>'),
  File('<output_file_path>'),
  'de',
  options: DocumentTranslateOptions(
    formality: 'less',
    glossaryId: myGlossary.glossaryId,
  ),
);
```

### Manage Glossaries

DeepL supports glossaries to manage custom translations. To use them you have to create one.

```dart
GlossaryInfo glossaryInfo = await translator.createGlossary(
  name: 'my glossary',
  sourceLang: 'en',
  targetLang: 'de',
  entries: GlossaryEntries(entries: {
    'hello': 'hi',
    'world': 'erde',
  }),
);
```

Not all languages are supported. You can check the possible language pairs.

```dart
  List<GlossaryLanguagePair> languagePairs =
      await translator.getGlossaryLanguagePairs();
```

Once you created a glossary you can use it for translations as part of the `TranslateTextOptions` and the `DocumentTranslateOptions` (see above).

To get all your glossaries or a specific one, you can request them.

```dart
// List glossaries
List<GlossaryInfo> glossaryList = await translator.listGlossaries();

// Get glossary info
GlossaryInfo glossaryInfo = await translator.getGlossary(glossaryInfo.glossaryId);
```

To get the entries of a glossary, you have to request them seperately.

```dart
GlossaryEntries glossaryEntries =
      await translator.getGlossaryEntries(glossaryId: '<glossary_info_if>');

// with a glossary info object
GlossaryEntries glossaryEntries =
    await translator.getGlossaryEntries(glossaryInfo: glossaryInfo);
```

Lastly, you can delete a glossary.

```dart
await translator.deleteGlossary(glossaryId: glossaryInfo.glossaryId);
```

### Translation Usage

Find out more about the used translations and your limits.

```dart
Usage usage = await translator.getUsage();
```

## Additional information

For more information, check out the [official Node.js Client Library for the DeepL API](https://github.com/DeepLcom/deepl-node) and the [DeepL API Docs](https://www.deepl.com/docs-api).
