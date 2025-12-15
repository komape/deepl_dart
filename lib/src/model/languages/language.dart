import 'package:json_annotation/json_annotation.dart';

part 'language.g.dart';

/// Information about a language supported by DeepL translator.
// ignore_for_file: non_constant_identifier_names
@JsonSerializable(createToJson: false)
class Language {
  /// Language code according to ISO 639-1, for example 'en'. Some target
  /// languages also include the regional variant according to ISO 3166-1, for
  /// example 'en-US'.
  @JsonKey(name: 'language')
  final String languageCode;

  /// Name of the language in English.
  final String name;

  /// Indicates whether the language can be used as a source language for
  /// translation.
  final bool isTranslationSourceLanguage;

  /// Indicates whether the language can be used as a target language for
  /// translation.
  final bool isTranslationTargetLanguage;

  /// Indicates whether the language is a beta language.
  final bool isBetaLanguage;

  /// Indicates whether the language can be used with DeepL Write.
  final bool isWriteLanguage;

  /// Only defined for target languages. If defined, specifies whether the
  /// formality option is available for this target language.
  final bool supportsFormality;

  Language({
    required this.languageCode,
    required this.name,
    this.isTranslationSourceLanguage = false,
    this.isTranslationTargetLanguage = false,
    this.isBetaLanguage = false,
    this.isWriteLanguage = false,
    this.supportsFormality = false,
  });

  factory Language.fromJson(Map<String, dynamic> json) =>
      _$LanguageFromJson(json);

  @override
  String toString() =>
      'Language[languageCode: $languageCode, name: $name, isSourceLanguage: $isTranslationSourceLanguage, isTargetLanguage: $isTranslationTargetLanguage, supportsFormality: $supportsFormality]';

  /// Get Language by language code.
  ///
  /// [code] Language code to look for.
  /// [includeBeta] Whether to include beta languages in the search.
  /// Default is false.
  ///
  /// Returns Language matching the given language code.
  static Language fromLanguageCode(final String code,
          {final bool includeBeta = false}) =>
      ALL.firstWhere(
        (lang) =>
            lang.languageCode.toLowerCase() == code.toLowerCase() &&
            (includeBeta || !lang.isBetaLanguage),
        orElse: () => throw ArgumentError('Unsupported language code: $code'),
      );

  /// Get the list of source languages.
  ///
  /// [includeBeta] Whether to include beta languages in the returned list.
  /// Default is false.
  ///
  /// Returns List of Languages that can be used as source languages.
  static getSourceLanguages({final bool includeBeta = false}) => ALL
      .where((lang) =>
          lang.isTranslationSourceLanguage &&
          (includeBeta || !lang.isBetaLanguage))
      .toList();

  /// Get the list of target languages.
  ///
  /// [includeBeta] Whether to include beta languages in the returned list.
  /// Default is false.
  ///
  /// Returns List of Languages that can be used as target languages.
  static getTargetLanguages({final bool includeBeta = false}) => ALL
      .where((lang) =>
          lang.isTranslationTargetLanguage &&
          (includeBeta || !lang.isBetaLanguage))
      .toList();

  // ====== LANGUAGES ======

  static final Language AR = Language(
    languageCode: 'AR',
    name: 'Arabic',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language BG = Language(
    languageCode: 'BG',
    name: 'Bulgarian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language CS = Language(
    languageCode: 'CS',
    name: 'Czech',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language DA = Language(
    languageCode: 'DA',
    name: 'Danish',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language DE = Language(
    languageCode: 'DE',
    name: 'German',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isWriteLanguage: true,
  );

  static final Language EL = Language(
    languageCode: 'EL',
    name: 'Greek',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language EN = Language(
    languageCode: 'EN',
    name: 'English',
    isTranslationSourceLanguage: true,
  );

  static final Language EN_GB = Language(
    languageCode: 'EN-GB',
    name: 'English (British)',
    isTranslationTargetLanguage: true,
    isWriteLanguage: true,
  );

  static final Language EN_US = Language(
    languageCode: 'EN-US',
    name: 'English (American)',
    isTranslationTargetLanguage: true,
    isWriteLanguage: true,
  );

  static final Language ES = Language(
    languageCode: 'ES',
    name: 'Spanish',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isWriteLanguage: true,
  );

  static final Language ES_419 = Language(
    languageCode: 'ES-419',
    name: 'Spanish (Latin American)',
    isTranslationTargetLanguage: true,
  );

  static final Language ET = Language(
    languageCode: 'ET',
    name: 'Estonian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language FI = Language(
    languageCode: 'FI',
    name: 'Finnish',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language FR = Language(
    languageCode: 'FR',
    name: 'French',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isWriteLanguage: true,
  );

  static final Language HE = Language(
    languageCode: 'HE',
    name: 'Hebrew',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language HU = Language(
    languageCode: 'HU',
    name: 'Hungarian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language ID = Language(
    languageCode: 'ID',
    name: 'Indonesian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language IT = Language(
    languageCode: 'IT',
    name: 'Italian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isWriteLanguage: true,
  );

  static final Language JA = Language(
    languageCode: 'JA',
    name: 'Japanese',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language KO = Language(
    languageCode: 'KO',
    name: 'Korean',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language LT = Language(
    languageCode: 'LT',
    name: 'Lithuanian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language LV = Language(
    languageCode: 'LV',
    name: 'Latvian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language NB = Language(
    languageCode: 'NB',
    name: 'Norwegian Bokmål',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language NL = Language(
    languageCode: 'NL',
    name: 'Dutch',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language PL = Language(
    languageCode: 'PL',
    name: 'Polish',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language PT = Language(
    languageCode: 'PT',
    name: 'Portuguese',
    isTranslationSourceLanguage: true,
  );

  static final Language PT_BR = Language(
    languageCode: 'PT-BR',
    name: 'Portuguese (Brazilian)',
    isTranslationTargetLanguage: true,
    isWriteLanguage: true,
  );

  static final Language PT_PT = Language(
    languageCode: 'PT-PT',
    name: 'Portuguese (all Portuguese variants excluding Brazilian Portuguese)',
    isTranslationTargetLanguage: true,
    isWriteLanguage: true,
  );

  static final Language RO = Language(
    languageCode: 'RO',
    name: 'Romanian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language RU = Language(
    languageCode: 'RU',
    name: 'Russian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language SK = Language(
    languageCode: 'SK',
    name: 'Slovak',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language SL = Language(
    languageCode: 'SL',
    name: 'Slovenian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language SV = Language(
    languageCode: 'SV',
    name: 'Swedish',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language TH = Language(
    languageCode: 'TH',
    name: 'Thai',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language TR = Language(
    languageCode: 'TR',
    name: 'Turkish',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language UK = Language(
    languageCode: 'UK',
    name: 'Ukrainian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language VI = Language(
    languageCode: 'VI',
    name: 'Vietnamese',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language ZH = Language(
    languageCode: 'ZH',
    name: 'Chinese (Simplified)',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
  );

  static final Language ZH_HANS = Language(
    languageCode: 'ZH-HANS',
    name: 'Chinese (Simplified)',
    isTranslationTargetLanguage: true,
  );

  static final Language ZH_HANT = Language(
    languageCode: 'ZH-HANT',
    name: 'Chinese (Traditional)',
    isTranslationTargetLanguage: true,
  );

  // ====== BETA LANGUAGES ======

  static final Language ACE = Language(
    languageCode: 'ACE',
    name: 'Acehnese',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language AF = Language(
    languageCode: 'AF',
    name: 'Afrikaans',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language AN = Language(
    languageCode: 'AN',
    name: 'Aragonese',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language AS = Language(
    languageCode: 'AS',
    name: 'Assamese',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language AY = Language(
    languageCode: 'AY',
    name: 'Aymara',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language AZ = Language(
    languageCode: 'AZ',
    name: 'Azerbaijani',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language BA = Language(
    languageCode: 'BA',
    name: 'Bashkir',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language BE = Language(
    languageCode: 'BE',
    name: 'Belarusian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language BHO = Language(
    languageCode: 'BHO',
    name: 'Bhojpuri',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language BN = Language(
    languageCode: 'BN',
    name: 'Bengali',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language BR = Language(
    languageCode: 'BR',
    name: 'Breton',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language BS = Language(
    languageCode: 'BS',
    name: 'Bosnian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language CA = Language(
    languageCode: 'CA',
    name: 'Catalan',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language CEB = Language(
    languageCode: 'CEB',
    name: 'Cebuano',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language CKB = Language(
    languageCode: 'CKB',
    name: 'Kurdish (Sorani)',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language CY = Language(
    languageCode: 'CY',
    name: 'Welsh',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language EO = Language(
    languageCode: 'EO',
    name: 'Esperanto',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language EU = Language(
    languageCode: 'EU',
    name: 'Basque',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language FA = Language(
    languageCode: 'FA',
    name: 'Persian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language GA = Language(
    languageCode: 'GA',
    name: 'Irish',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language GL = Language(
    languageCode: 'GL',
    name: 'Galician',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language GN = Language(
    languageCode: 'GN',
    name: 'Guarani',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language GOM = Language(
    languageCode: 'GOM',
    name: 'Konkani',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language GU = Language(
    languageCode: 'GU',
    name: 'Gujarati',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language HA = Language(
    languageCode: 'HA',
    name: 'Hausa',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language HI = Language(
    languageCode: 'HI',
    name: 'Hindi',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language HR = Language(
    languageCode: 'HR',
    name: 'Croatian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language HT = Language(
    languageCode: 'HT',
    name: 'Haitian Creole',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language HY = Language(
    languageCode: 'HY',
    name: 'Armenian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language IG = Language(
    languageCode: 'IG',
    name: 'Igbo',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language IS = Language(
    languageCode: 'IS',
    name: 'Icelandic',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language JV = Language(
    languageCode: 'JV',
    name: 'Javanese',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language KA = Language(
    languageCode: 'KA',
    name: 'Georgian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language KK = Language(
    languageCode: 'KK',
    name: 'Kazakh',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language KMR = Language(
    languageCode: 'KMR',
    name: 'Kurdish (Kurmanji)',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language KY = Language(
    languageCode: 'KY',
    name: 'Kyrgyz',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language LA = Language(
    languageCode: 'LA',
    name: 'Latin',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language LB = Language(
    languageCode: 'LB',
    name: 'Luxembourgish',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language LMO = Language(
    languageCode: 'LMO',
    name: 'Lombard',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language LN = Language(
    languageCode: 'LN',
    name: 'Lingala',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language MAI = Language(
    languageCode: 'MAI',
    name: 'Maithili',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language MG = Language(
    languageCode: 'MG',
    name: 'Malagasy',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language MI = Language(
    languageCode: 'MI',
    name: 'Maori',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language MK = Language(
    languageCode: 'MK',
    name: 'Macedonian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language ML = Language(
    languageCode: 'ML',
    name: 'Malayalam',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language MN = Language(
    languageCode: 'MN',
    name: 'Mongolian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language MR = Language(
    languageCode: 'MR',
    name: 'Marathi',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language MS = Language(
    languageCode: 'MS',
    name: 'Malay',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language MT = Language(
    languageCode: 'MT',
    name: 'Maltese',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language MY = Language(
    languageCode: 'MY',
    name: 'Burmese',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language NE = Language(
    languageCode: 'NE',
    name: 'Nepali',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language OC = Language(
    languageCode: 'OC',
    name: 'Occitan',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language OM = Language(
    languageCode: 'OM',
    name: 'Oromo',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language PA = Language(
    languageCode: 'PA',
    name: 'Punjabi',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language PAG = Language(
    languageCode: 'PAG',
    name: 'Pangasinan',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language PAM = Language(
    languageCode: 'PAM',
    name: 'Pampanga',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language PRS = Language(
    languageCode: 'PRS',
    name: 'Dari',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language PS = Language(
    languageCode: 'PS',
    name: 'Pashto',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language QU = Language(
    languageCode: 'QU',
    name: 'Quechua',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language SA = Language(
    languageCode: 'SA',
    name: 'Sanskrit',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language SCN = Language(
    languageCode: 'SCN',
    name: 'Sicilian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language SQ = Language(
    languageCode: 'SQ',
    name: 'Albanian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language SR = Language(
    languageCode: 'SR',
    name: 'Serbian',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language ST = Language(
    languageCode: 'ST',
    name: 'Sesotho',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language SU = Language(
    languageCode: 'SU',
    name: 'Sundanese',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language SW = Language(
    languageCode: 'SW',
    name: 'Swahili',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language TA = Language(
    languageCode: 'TA',
    name: 'Tamil',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language TE = Language(
    languageCode: 'TE',
    name: 'Telugu',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language TG = Language(
    languageCode: 'TG',
    name: 'Tajik',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language TK = Language(
    languageCode: 'TK',
    name: 'Turkmen',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language TL = Language(
    languageCode: 'TL',
    name: 'Tagalog',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language TN = Language(
    languageCode: 'TN',
    name: 'Tswana',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language TS = Language(
    languageCode: 'TS',
    name: 'Tsonga',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language TT = Language(
    languageCode: 'TT',
    name: 'Tatar',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language UR = Language(
    languageCode: 'UR',
    name: 'Urdu',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language UZ = Language(
    languageCode: 'UZ',
    name: 'Uzbek',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language WO = Language(
    languageCode: 'WO',
    name: 'Wolof',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language XH = Language(
    languageCode: 'XH',
    name: 'Xhosa',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language YI = Language(
    languageCode: 'YI',
    name: 'Yiddish',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language YUE = Language(
    languageCode: 'YUE',
    name: 'Cantonese',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final Language ZU = Language(
    languageCode: 'ZU',
    name: 'Zulu',
    isTranslationSourceLanguage: true,
    isTranslationTargetLanguage: true,
    isBetaLanguage: true,
  );

  static final List<Language> ALL = [
    AR,
    BG,
    CS,
    DA,
    DE,
    EL,
    EN,
    EN_GB,
    EN_US,
    ES,
    ES_419,
    ET,
    FI,
    FR,
    HE,
    HU,
    ID,
    IT,
    JA,
    KO,
    LT,
    LV,
    NB,
    NL,
    PL,
    PT,
    PT_BR,
    PT_PT,
    RO,
    RU,
    SK,
    SL,
    SV,
    TH,
    TR,
    UK,
    VI,
    ZH,
    ZH_HANS,
    ZH_HANT,
    // Beta languages
    ACE,
    AF,
    AN,
    AS,
    AY,
    AZ,
    BA,
    BE,
    BHO,
    BN,
    BR,
    BS,
    CA,
    CEB,
    CKB,
    CY,
    EO,
    EU,
    FA,
    GA,
    GL,
    GN,
    GOM,
    GU,
    HA,
    HI,
    HR,
    HT,
    HY,
    IG,
    IS,
    JV,
    KA,
    KK,
    KMR,
    KY,
    LA,
    LB,
    LMO,
    LN,
    MAI,
    MG,
    MI,
    MK,
    ML,
    MN,
    MR,
    MS,
    MT,
    MY,
    NE,
    OC,
    OM,
    PA,
    PAG,
    PAM,
    PRS,
    PS,
    QU,
    SA,
    SCN,
    SQ,
    SR,
    ST,
    SU,
    SW,
    TA,
    TE,
    TG,
    TK,
    TL,
    TN,
    TS,
    TT,
    UR,
    UZ,
    WO,
    XH,
    YI,
    YUE,
    ZU,
  ];
}
