import 'dart:convert';
import 'dart:io';

import 'package:deepl_dart/src/errors.dart';
import 'package:deepl_dart/src/model/text_result.dart';
import 'package:deepl_dart/src/model/translate_text_options.dart';
import 'package:deepl_dart/src/parsing.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/retry.dart';

/// Wrapper for the DeepL API for language translation. Create an instance of
/// Translator to use the DeepL API.
class Translator {
  late String _serverUrl;
  late Map<String, String> _headers;
  late http.Client httpClient;

  /// Construct a Translator object wrapping the DeepL API using your
  /// authentication key.
  ///
  /// This does not connect to the API, and returns immediately.
  ///
  /// Takes [authKey] as specified in your account.
  ///
  /// Takes [serverUrl] as base URL of DeepL API, can be overridden for example
  /// for testing purposes. By default, the correct DeepL API URL is selected
  /// based on the user account type (free or paid).
  ///
  /// Takes HTTP [headers] attached to every HTTP request. By default, no extra
  /// headers are used. Note that during Translator initialization headers for
  /// Authorization and User-Agent are added, unless they are overridden in this
  /// option.
  ///
  ///
  /// Takes [maxRetries] for the maximum number of failed attempts that
  /// Translator will retry, per request. By default, 5 retries are made.
  /// Note: only errors due to transient conditions are retried.
  Translator({
    required String authKey,
    String? serverUrl,
    Map<String, String>? headers,
    int maxRetries = 5,
  }) {
    if (authKey.isEmpty) {
      throw DeepLError(message: 'authKey must be a non-empty string');
    }
    if (serverUrl != null) {
      _serverUrl = serverUrl;
    } else if (_isFreeAccountAuthKey(authKey)) {
      _serverUrl = 'https://api-free.deepl.com';
    } else {
      _serverUrl = 'https://api.deepl.com';
    }
    _headers = {
      'Authorization': 'DeepL-Auth-Key $authKey',
      'User-Agent': 'deepl-dart/0.1.0',
      ...(headers ?? {}),
    };
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
  Future<TextResult> translateTextSingular(
    String text,
    String targetLang, {
    String? sourceLang,
    TranslateTextOptions? options,
  }) async {
    assert(text.isNotEmpty, 'text parameter must be a non-empty string');
    List<TextResult> textResults = await translateTextList([text], targetLang,
        sourceLang: sourceLang, options: options);
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
  Future<List<TextResult>> translateTextList(
    List<String> texts,
    String targetLang, {
    String? sourceLang,
    TranslateTextOptions? options,
  }) async {
    assert(texts.isNotEmpty, 'texts parameter must not be a non-empty list');
    assert(texts.length <= 50,
        'texts parameter can contain 50 elements at maximum');
    assert(texts.every((t) => t.isNotEmpty),
        'texts parameter must not be an array of non-empty strings');
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

  /// Returns true if the specified DeepL Authentication Key is associated with a free account,
  /// otherwise false.
  ///
  /// Takes an [authKey] to check and returns [True] if the key is associated with
  /// a free account, otherwise [False].
  bool _isFreeAccountAuthKey(String authKey) => authKey.endsWith(':fx');

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
    targetLang = _standardizeLanguageCode(targetLang);
    if (sourceLang != null) {
      sourceLang = _standardizeLanguageCode(sourceLang);
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

  /// Changes the upper- and lower-casing of the given language code to match ISO
  /// 639-1 with an optional regional code from ISO 3166-1. For example, input
  /// 'EN-US' returns 'en-US'.
  ///
  /// Takes [langCode] containing language code to standardize.
  ///
  /// Returns standardized language code.
  String _standardizeLanguageCode(String langCode) {
    assert(langCode.isNotEmpty, 'langCode must be a non-empty string');
    List<String> parts = langCode.split('-');
    return parts.length < 2 || parts[1].isEmpty
        ? parts[0].toLowerCase()
        : '${parts[0].toLowerCase()}-${parts[1].toUpperCase()}';
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
      if (options.splitSentences == 'on' ||
          options.splitSentences == 'default') {
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
}
