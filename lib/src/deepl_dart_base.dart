import 'dart:convert';

import 'package:deepl_dart/src/errors.dart';
import 'package:deepl_dart/src/parsing.dart';
import 'package:deepl_dart/src/types.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/retry.dart';

/// Stores the count and limit for one usage type.
abstract class UsageDetail {
  /// The amount used of this usage type.
  final int count;

  /// The maximum allowable amount for this usage type.
  final int limit;

  UsageDetail({required this.count, required this.limit});

  /// Returns true if the amount used has already reached or passed the
  /// allowable amount.
  bool limitReached();
}

/// Information about the API usage: how much has been translated in this
/// billing period, and the maximum allowable amount.
///
/// Depending on the account type, different usage types are included: the
/// character, document and teamDocument fields provide details about each
/// corresponding usage type, allowing each usage type to be checked
/// individually. The anyLimitReached() function checks if any usage type is
/// exceeded.
abstract class Usage {
  /// Usage details for characters, for example due to the translateText()
  /// function.
  final UsageDetail? character;

  /// Usage details for documents.
  final UsageDetail? document;

  /// Usage details for documents shared among your team.
  final UsageDetail? teamDocument;

  Usage({this.character, this.document, this.teamDocument});

  /// Returns true if any usage type limit has been reached or passed,
  /// otherwise false.
  bool anyLimitReached();

  /// Converts the usage details to a human-readable string.
  @override
  String toString();
}

/// Changes the upper- and lower-casing of the given language code to match ISO
/// 639-1 with an optional regional code from ISO 3166-1. For example, input
/// 'EN-US' returns 'en-US'.
///
/// Takes [langCode] containing language code to standardize.
///
/// Returns standardized language code.
String standardizeLanguageCode(String langCode) {
  assert(langCode.isNotEmpty, 'langCode must be a non-empty string');
  List<String> parts = langCode.split('-');
  return parts.length < 2 || parts[1].isEmpty
      ? parts[0].toLowerCase()
      : '${parts[0].toLowerCase()}-${parts[1].toUpperCase()}';
}

/// Removes the regional variant from a language, for example inputs 'en' and
/// 'en-US' both return 'en'.
///
/// Takes [langCode] containing language code to convert.
///
/// Returns language code with regional variant removed.
String nonRegionalLanguageCode(String langCode) {
  assert(langCode.isNotEmpty, 'langCode must be a non-empty string');
  return langCode.split('-')[0].toLowerCase();
}

/// Holds the result of a text translation request.
class TextResult {
  /// [String] containing the translated text.
  final String text;

  /// [String] code of the detected source language.
  final String detectedSourceLang;

  TextResult({required this.text, required this.detectedSourceLang});
}

/// Validates and prepares URLSearchParams for arguments common to text and
/// document translation.
Map<String, String> _buildURLSearchParams({
  String? sourceLang,
  required String targetLang,
  String? formality,
  String? glossaryId,
}) {
  assert(targetLang != 'en',
      "targetLang='en' is deprecated, please use 'en-GB' or 'en-US' instead.");
  assert(targetLang != 'pt',
      "targetLang='pt' is deprecated, please use 'pt-PT' or 'pt-BR' instead.");
  targetLang = standardizeLanguageCode(targetLang);
  if (sourceLang != null) {
    sourceLang = standardizeLanguageCode(sourceLang);
  }
  if (glossaryId != null && sourceLang == null) {
    throw DeepLError(message: 'sourceLang is required if using a glossary');
  }
  Map<String, String> urlSearchParams = {
    'target_lang': targetLang,
  };
  if (sourceLang != null) {
    urlSearchParams['source_lang'] = sourceLang;
  }
  if (formality != null && formality != 'default') {
    urlSearchParams['formality'] = formality.toLowerCase();
  }
  if (glossaryId != null) {
    urlSearchParams['glossary_id'] = glossaryId;
  }
  return urlSearchParams;
}

/// Validates and appends text options to HTTP request parameters.
///
/// Takes [data] parameters for HTTP request.
///
/// Takes [options] for translate text request.
///
/// Note the formality and glossaryId options are handled separately, because
/// these options overlap with the translateDocument function.
void _validateAndAppendTextOptions(
    Map<String, String> data, TranslateTextOptions? options) {
  if (options == null) return;
  if (options.splitSentences != null) {
    options.splitSentences = options.splitSentences!.toLowerCase();
    if (options.splitSentences == 'on' || options.splitSentences == 'default') {
      data['split_sentences'] = '1';
    } else if (options.splitSentences == 'off') {
      data['split_sentences'] = '0';
    } else {
      data['split_sentences'] = options.splitSentences!;
    }
  }
  if (options.preserveFormatting ?? false) {
    data['preserve_formatting'] = '1';
  }
  if (options.tagHandling != null) {
    data['tag_handling'] = options.tagHandling!;
  }
  if (options.outlineDetection != null && !options.outlineDetection!) {
    data['outline_detection'] = '0';
  }
  if (options.nonSplittingTags != null) {
    data['non_splitting_tags'] = options.nonSplittingTags!;
  }
  if (options.splittingTags != null) {
    data['splitting_tags'] = options.splittingTags!;
  }
  if (options.ignoreTags != null) {
    data['ignore_tags'] = options.ignoreTags!;
  }
}

/// Builds an URI to send a request to.
Uri _buildUri(String serverUrl, String path, List<String> texts,
    Map<String, String> urlSearchParams) {
  String textsString = texts.map((text) => 'text=$text').join('&');
  String paramsString =
      urlSearchParams.entries.map((e) => '${e.key}=${e.value}').join('&');
  return Uri.parse('$serverUrl$path?$textsString&$paramsString');
}

/// Checks the HTTP status code, and in case of failure, throws an exception with diagnostic information.
Future<void> _checkStatusCode(
  Response response, {
  usingGlossary = false,
}) async {
  int statusCode = response.statusCode;
  if (200 <= statusCode && statusCode < 400) return;
  String content = response.body;
  String message = '';
  try {
    Map<String, dynamic> jsonObj = jsonDecode(content);
    if (jsonObj['message'] != null) {
      message += ', message: ${jsonObj['message']}';
    }
    if (jsonObj['detail'] != null) {
      message += ', detail: ${jsonObj['detail']}';
    }
  } catch (error) {
    // JSON parsing errors are ignored, and we fall back to the raw content
    message = ', ' + content;
  }
  switch (statusCode) {
    case 403:
      throw AuthorizationError(
          message: 'Authorization failure, check auth_key$message');
    case 456:
      throw QuotaExceededError(
        message: 'Quota for this billing period has been exceeded$message',
      );
    case 404:
      if (usingGlossary) {
        throw GlossaryNotFoundError(message: 'Glossary not found$message');
      }
      throw DeepLError(message: 'Not found, check server_url$message');
    case 400:
      throw DeepLError(message: 'Bad request$message');
    case 429:
      throw TooManyRequestsError(
        message:
            'Too many requests, DeepL servers are currently experiencing high load$message',
      );
    case 503:
      throw DeepLError(message: 'Service unavailable$message');
    default:
      {
        throw DeepLError(
          message:
              'Unexpected status code: $statusCode ${response.reasonPhrase}$message, content: $content',
        );
      }
  }
}

/// Wrapper for the DeepL API for language translation. Create an instance of
/// Translator to use the DeepL API.
class Translator {
  late String _serverUrl;
  late Map<String, String> _headers;
  // late int _minTimeout;
  late http.Client httpClient;

  /// Construct a Translator object wrapping the DeepL API using your
  /// authentication key.
  ///
  /// This does not connect to the API, and returns immediately.
  ///
  /// Takes [authKey] as specified in your account and [options] to control
  /// Translator behavior.
  Translator({required String authKey, TranslatorOptions? options}) {
    if (authKey.isEmpty) {
      throw DeepLError(message: 'authKey must be a non-empty string');
    }
    if (options?.serverUrl != null) {
      _serverUrl = options!.serverUrl!;
    } else if (isFreeAccountAuthKey(authKey)) {
      _serverUrl = 'https://api-free.deepl.com';
    } else {
      _serverUrl = 'https://api.deepl.com';
    }
    _headers = {
      'Authorization': 'DeepL-Auth-Key $authKey',
      'User-Agent': 'deepl-dart/1.0.0',
      ...(options?.headers ?? {}),
    };
    // _minTimeout = options?.minTimeout ?? 5000;
    int maxRetries = options?.maxRetries ?? 5;
    httpClient = RetryClient(http.Client(), retries: maxRetries);
  }

  /// Translates specified text string into the target language.
  ///
  /// Takes [text] containing input text to translate.
  ///
  /// [sourceLang] language code of input text language, or null to use
  /// auto-detection.
  ///
  /// [targetLang] language code of language to translate into.
  ///
  /// [options] optional [TranslateTextOptions] object containing additional
  /// options controlling translation.
  ///
  /// Fulfills with a [TextResult] object; use the `TextResult.text` property to
  /// access the translated text.
  Future<TextResult> translateTextSingular({
    required String text,
    String? sourceLang,
    required String targetLang,
    TranslateTextOptions? options,
  }) async {
    List<TextResult> textResults = await translateTextList(
        texts: [text],
        targetLang: targetLang,
        sourceLang: sourceLang,
        options: options);
    return textResults[0];
  }

  /// Translates specified array of text strings into the target language.
  ///
  /// Takes [texts] string or array of strings containing input texts to
  /// translate.
  ///
  /// Takes [sourceLang] code of input text language, or null to use
  /// auto-detection.
  ///
  /// Takes [targetLang] code of language to translate into.
  ///
  /// Takes [options] object containing additional options controlling
  /// translation.
  ///
  /// Fulfills with an array of TextResult objects corresponding to input texts;
  /// use the `TextResult.text` property to access the translated text.
  Future<List<TextResult>> translateTextList({
    required List<String> texts,
    String? sourceLang,
    required String targetLang,
    TranslateTextOptions? options,
  }) async {
    assert(texts.isNotEmpty, 'text parameter must not be a non-empty string');
    Map<String, String> urlSearchParams = _buildURLSearchParams(
      sourceLang: sourceLang,
      targetLang: targetLang,
      formality: options?.formality,
      glossaryId: options?.glossaryId,
    );
    _validateAndAppendTextOptions(urlSearchParams, options);
    Response translateRes = await httpClient.post(
        _buildUri(_serverUrl, '/v2/translate', texts, urlSearchParams),
        headers: _headers);
    await _checkStatusCode(translateRes);
    List<TextResult> textResults = parseTextResultArray(translateRes.body);
    return textResults;
  }
}

/// Returns true if the specified DeepL Authentication Key is associated with a free account,
/// otherwise false.
///
/// Takes an [authKey] to check and returns [True] if the key is associated with
/// a free account, otherwise [False].
bool isFreeAccountAuthKey(String authKey) => authKey.endsWith(':fx');