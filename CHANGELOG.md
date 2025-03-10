# deepl_dart Changelog

## 2.0.0

- #27 Add writer functionality to rephrase and improve text
- Add `modelType` parameter to text translation requests, see `ModelType` for more info
- Add `showBilledCharacters` parameter to text translation request
  - If set to true, the response will contain the `billedCharacters` field

### Breaking changes

- The `Translator` class has been restructured into modules grouped in the `DeepL` class. See the README and the deprecation notes in the code on on how to update. 
- The `formality` parameter for text translation requests has been converted from a `String` to the `Formality` enum

## 1.5.0

- #25 Add translation context

## 1.4.0

- Use JSON over URL params for text translation

## 1.3.1

- Export errors

## 1.3.0

- #22 Upgrade supported languages
- Update dependencies

## 1.2.0

- #21 Replace IO dependency to support Web

## 1.1.0

- #18: Added Option to Create Glossary with CSV File

## 1.0.2

- Fix #14: Support UTF-8

## 1.0.1

- More examples

## 1.0.0

- #3 Monitor Usage
- #4 List Supported Languages
- First production-ready version

## 0.3.0

- #2 Manage Glossaries

## 0.2.0

- #1 Translate Documents

## 0.1.0

- Initial version.
- Translate text.