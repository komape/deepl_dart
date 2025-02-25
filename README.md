# [deepl_dart](https://pub.dev/packages/deepl_dart)

[![Dart Analyze & Test](https://github.com/komape/deepl_dart/actions/workflows/dart_analyze_test.yml/badge.svg)](https://github.com/komape/deepl_dart/actions/workflows/dart_analyze_test.yml) [![codecov](https://codecov.io/gh/komape/deepl_dart/branch/master/graph/badge.svg?token=RF7B8BPD77)](https://codecov.io/gh/komape/deepl_dart)

> ⚠️ Prior to version 2.0.0 there was only one `Translator` object which combined the functionality of translation, glossary management and language information. The `Translator` is deprecated and will be removed in a future release. In addition, some methods have been renamed. The old ones still exist, but are deprecated and will be removed in a future release. If you upgrade to version 2.0.0 or higher, please update your code to use the `DeepL` object.

**This package is maintained by volunteers but is not a supported DeepL product and not maintained by DeepL SE. Issues here are answered by maintainers and other community members on GitHub on a best-effort basis.**

This package is heavily inspired by the [official Node.js Client Library for the DeepL API](https://github.com/DeepLcom/deepl-node):

> The DeepL API is a language translation API that allows other computer programs to send texts and documents to DeepL's servers and receive high-quality translations. This opens a whole universe of opportunities for developers: any translation product you can imagine can now be built on top of DeepL's best-in-class translation technology.
>
> The DeepL *[Dart]* library offers a convenient way for applications written for *[Dart and Flutter]* to interact with the DeepL API. We intend to support all API functions with the library, though support for new features may be added to the library after they’re added to the API. *~ DeepL*

- [deepl\_dart](#deepl_dart)
  - [Getting an authentication key](#getting-an-authentication-key)
  - [Installation](#installation)
  - [Usage](#usage)
    - [DeepL Object](#deepl-object)
    - [Translator](#translator)
      - [Translate Text](#translate-text)
      - [Translate Documents](#translate-documents)
    - [Writer](#writer)
    - [Glossaries](#glossaries)
    - [Languages](#languages)
    - [Usage](#usage-1)
  - [Additional information](#additional-information)

## Getting an authentication key

To use the package, you'll need an API authentication key. To get a key, [please create an account here](https://www.deepl.com/pro/change-plan#developer). You can translate up to 500,000characters/month for free.

## Installation

In the `dependencies`: section of your `pubspec.yaml`, add the following line:

```yaml
dependencies:
  deepl_dart: <latest_version>
```

## Usage

Import the package and construct a `DeepL` object. The required argument `authKey` is a string containing your API authentication key as found in your [DeepL Pro Account](https://www.deepl.com/pro-account/).

Be careful not to expose your key, for example when sharing source code.

An example using `async/await`:

```dart
import 'package:deepl_dart/deepl_dart.dart';

void main() async {
  // Construct Translator
  DeepL deepl = DeepL(authKey: '<your_auth_key>');

  // Translate text
  TextResult result =
      await deepl.translate.translateText('Hello World', 'de');
  print(result);

  // Translate list of texts
  List<TextResult> results =
      await deepl.translate.translateTextList(['Hello World', 'Hola Mundo'], 'de');
  print(results);
}
```

### DeepL Object

All requests to the DeepL API go via a `DeepL`. A `auth_key` from DeepL is required to send requests. Pass it via its constructor:

```dart
DeepL deepl = DeepL(authKey: '<your_auth_key>');
```

This example is for demonstration purposes only. In production code, the authentication key should not be hard-coded, but instead fetched from a configuration file or environment variable.

Add further arguments to the constructor:

```dart
DeepL deepl = DeepL(
    authKey: '<your_auth_key>',
    headers: {'My-Header-Key': 'my header value'},
    serverUrl: 'https://alternative.deepl.api.server.url',
    maxRetries: 42,
  );
```

The `DeepL` class contains modules for the different functionality of DeepL's API. Here's an overview of the currently available modules which are described in more detail further below.

| Module     | Access             | Description                         |
| ---------- | ------------------ | ----------------------------------- |
| Translator | `deepl.translate`  | Translate text and documents.       |
| Writer     | `deepl.write`      | Rephrase and improve text.          |
| Glossaries | `deepl.glossaries` | Manage your glossaries.             |
| Languages  | `deepl.languages`  | Get info about supported languages. |

### Translator

#### Translate Text

The basic text translation takes one or more texts and a target language to return the translated text. DeepL detects the source language automatically.

```dart
// Translate a single text
TextResult result =
    await deepl.translate.translateTextSingular('Hello World', 'de');

// Translate multiple texts
List<TextResult> results =
    await deepl.translate.translateTextList(['Hello World', 'Hola Mundo'], 'de');
```

Optionally you can pass the source language as well.

```dart
TextResult result = await deepl.translate
    .translateTextSingular('Hello World', 'de', sourceLang: 'en');
```

If you unsure which languages are supported you can request them.

```dart
  List<Language> sourceLangs = await deepl.languages.getSources();
  List<Language> targetLangs = await deepl.languages.getTargets();
```

You can pass a `TranslateTextOptions` object to configure the translation.

```dart
TextResult result = await deepl.translate.translateTextSingular(
  'Hello World',
  'de',
  options: TranslateTextOptions(
      splitSentences: 'on',
      formality: 'less',
      glossaryId: myGlossary.glossaryId,
  ),
);
```

#### Translate Documents

DeepL also supports the translation of documents. At the moment of writing the following file types are supported:

- `.docx`
- `.pptx`
- `.pdf`
- `.txt`

The document translation method internally uploads given input file, waits for the translation to finish and downloads the file into the given output file. As well as with the text translation a target language is required.

```dart
DocumentStatus status = await deepl.translate.translateDocument(
    File('<input_file_path>'), File('<output_file_path>'), 'de');
```

Optionally you can pass the source language as well.

```dart
DocumentStatus status = await deepl.translate.translateDocument(
    File('<input_file_path>'), File('<output_file_path>'), 'de',
    sourceLang: 'en');
```

You can pass a `DocumentTranslateOptions` object to configure the translation.

```dart
DocumentStatus status = await deepl.translate.translateDocument(
  File('<input_file_path>'),
  File('<output_file_path>'),
  'de',
  options: DocumentTranslateOptions(
    formality: 'less',
    glossaryId: myGlossary.glossaryId,
  ),
);
```

### Writer

Rephrase and improve your text with DeepL Write.

> ⚠ At the moment the text improvement feature is currently only available to DeepL API Pro customers and is not yet available in DeepL API Free.

Pass a text that should be improved.

```dart
TextRephraseResult rephraseResult =
    await deepl.write.rephraseText('This is a sample sentence to improve.');
```

You can also pass multiple texts. Each of the texts may contain multiple sentences. 

Note: All texts must be in the same language.

```dart
List<TextRephraseResult> rephraseResults =
    await deepl.write.rephraseTextList([
  'This is a sample sentence to improve.',
  'This is another sample sentence to improve.',
]);
```

Use a `WritingStyle` to change the style of writing. See the `WritingStyle` enum for the available values.

```dart
TextRephraseResult rephraseResultWithStyle = await deepl.write.rephraseText(
  'This is a sample sentence to improve.',
  writingStyle: WritingStyle.academic,
);
```

Use a `Tone` to set the tone of the text. See the `Tone` enum for the available values.

```dart
TextRephraseResult rephraseResultWithTone = await deepl.write.rephraseText(
  'This is a sample sentence to improve.',
  tone: Tone.diplomatic,
);
```

Be aware that you cannot use `WritingStyle` and `Tone` at the same time.

### Glossaries

DeepL supports glossaries to manage custom translations. To use them you have to create one.

```dart
GlossaryInfo glossaryInfo = await deepl.glossaries.create(
  name: 'my glossary',
  sourceLang: 'en',
  targetLang: 'de',
  entries: GlossaryEntries(entries: {
    'hello': 'hi',
    'world': 'erde',
  }),
);
```

You can also upload a glossary downloaded from the DeepL website using `createGlossaryFromCsv()`. Instead of supplying the entries as a GlossaryEntries object, provide the CSV file as a File containing the CSV file content:

```dart
GlossaryInfo csvGlossaryInfo = await deepl.glossaries.createWithCsvFile(
  name: 'my glossary',
  sourceLang: 'en',
  targetLang: 'de',
  csvFile: File('<csv_file_path>'),
);
```

The [API documentation](https://www.deepl.com/docs-api/managing-glossaries/supported-glossary-formats/) explains the expected CSV format in detail.

Not all languages are supported. You can check the possible language pairs.

```dart
  List<GlossaryLanguagePair> languagePairs =
      await deepl.glossaries.getLanguagePairs();
```

Once you created a glossary you can use it for translations as part of the `TranslateTextOptions` and the `DocumentTranslateOptions` (see above).

To get all your glossaries or a specific one, you can request them.

```dart
// List glossaries
List<GlossaryInfo> glossaryList = await deepl.glossaries.list();

// Get glossary info
GlossaryInfo glossaryInfo = await deepl.glossaries.get(glossaryInfo.glossaryId);
```

To get the entries of a glossary, you have to request them seperately.

```dart
GlossaryEntries glossaryEntries =
      await deepl.glossaries.getEntries(glossaryId: '<glossary_info_if>');

// with a glossary info object
GlossaryEntries glossaryEntries =
    await deepl.glossaries.getEntries(glossaryInfo: glossaryInfo);
```

Lastly, you can delete a glossary.

```dart
await deepl.glossaries.delete(glossaryId: glossaryInfo.glossaryId);
```

### Languages

### Usage

Find out more about the used translations and your limits.

```dart
Usage usage = await deepl.getUsage();
```

## Additional information

For more information, check out the [official Node.js Client Library for the DeepL API](https://github.com/DeepLcom/deepl-node) and the [DeepL API Docs](https://www.deepl.com/docs-api).
