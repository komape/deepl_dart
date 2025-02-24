import 'dart:convert';
import 'dart:math';

import 'package:deepl_dart/src/model/errors.dart';
import 'package:deepl_dart/src/model/translate/document_handle.dart';
import 'package:deepl_dart/src/model/translate/document_status.dart';
import 'package:deepl_dart/src/model/translate/document_translate_options.dart';
import 'package:deepl_dart/src/model/translate/document_translation_status.dart';
import 'package:deepl_dart/src/model/glossaries/glossary_entries.dart';
import 'package:deepl_dart/src/model/glossaries/glossary_info.dart';
import 'package:deepl_dart/src/model/glossaries/glossary_info_list_api_response.dart';
import 'package:deepl_dart/src/model/glossaries/glossary_language_pair.dart';
import 'package:deepl_dart/src/model/glossaries/glossary_language_pair_list_api_reponse.dart';
import 'package:deepl_dart/src/model/languages/language.dart';
import 'package:deepl_dart/src/model/translate/text_result.dart';
import 'package:deepl_dart/src/model/translate/text_result_response.dart';
import 'package:deepl_dart/src/model/translate/text_translation_request.dart';
import 'package:deepl_dart/src/model/translate/translate_text_options.dart';
import 'package:deepl_dart/src/model/usage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:universal_io/io.dart';

/// Wrapper for the DeepL API for language translation. Create an instance of
/// Translator to use the DeepL API.
@Deprecated(
    "Use the DeepL class instead. See changelog for detailed guidance. This class will be removed in the next major release.")
class Translator {
  late String _serverUrl;
  late Map<String, String> _headers;
  late http.Client _httpClient;

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
    assert(authKey.isNotEmpty, 'authKey must be a non-empty string');
    if (serverUrl != null) {
      _serverUrl = serverUrl;
    } else if (isFreeAccountAuthKey(authKey)) {
      _serverUrl = 'https://api-free.deepl.com';
    } else {
      _serverUrl = 'https://api.deepl.com';
    }
    _headers = {
      'Authorization': 'DeepL-Auth-Key $authKey',
      'User-Agent': 'deepl_dart/1.4.0',
      ...(headers ?? {}),
    };
    _httpClient = RetryClient(http.Client(), retries: maxRetries);
  }

  /// Returns true if the specified DeepL Authentication Key is associated with a free account,
  /// otherwise false.
  ///
  /// Takes an [authKey] to check and returns [True] if the key is associated with
  /// a free account, otherwise [False].
  static bool isFreeAccountAuthKey(String authKey) => authKey.endsWith(':fx');

  // ============ USAGE ========================================================

  /// Queries character and document usage during the current billing period.
  ///
  /// Fulfills with [Usage] object on success.
  Future<Usage> getUsage() async {
    Uri uri = _buildUri(_serverUrl, '/v2/usage');
    Response response = await _httpClient.get(uri, headers: _headers);
    await _checkStatusCode(response.statusCode, response.body,
        reasonPhrase: response.reasonPhrase);
    return Usage.fromJson(jsonDecode(response.body));
  }

  // ============ LANGUAGES ====================================================

  /// Queries source languages supported by DeepL API.
  ///
  /// Fulfills with array of [Language] objects containing available source
  /// languages.
  Future<List<Language>> getSourceLanguages() async => _getLanguages('source');

  /// Queries target languages supported by DeepL API.
  ///
  /// Fulfills with array of [Language] objects containing available target
  /// languages.
  Future<List<Language>> getTargetLanguages() async => _getLanguages('target');

  Future<List<Language>> _getLanguages(String type) async {
    Uri uri =
        _buildUri(_serverUrl, '/v2/languages', urlSearchParams: {'type': type});
    Response response = await _httpClient.get(uri, headers: _headers);
    await _checkStatusCode(response.statusCode, response.body,
        reasonPhrase: response.reasonPhrase);
    List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((json) => Language.fromJson(json)).toList();
  }

  // ============ TEXT TRANSLATION =============================================

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
    final TextTranslationRequest ttr = TextTranslationRequest.fromOptions(
        text: texts,
        sourceLang: sourceLang,
        targetLang: targetLang,
        options: options);
    Response translateRes = await _httpClient.post(
        _buildUri(_serverUrl, '/v2/translate'),
        headers: {..._headers}..addAll({'Content-Type': 'application/json'}),
        body: ttr.toJson(),
        encoding: Encoding.getByName('utf8'));
    await _checkStatusCode(translateRes.statusCode, translateRes.body,
        reasonPhrase: translateRes.reasonPhrase);
    List<TextResult> textResults = TextResultResponse.fromJson(
            jsonDecode(utf8.decode(translateRes.bodyBytes)))
        .translations;
    return textResults;
  }

  // ============ DOCUMENT TRANSLATION =========================================

  /// Uploads specified document to DeepL to translate into given target
  /// language, waits for translation to complete, then downloads translated
  /// document to specified output path.
  ///
  /// Takes a [File] as [inputFile] containing file data.
  ///
  /// Takes a [File] as [outputFile] to write translated document content.ß
  /// Existing content in the file will be overwritten.
  ///
  /// Takes [sourceLang] language code of input document, or null to use
  /// auto-detection.
  ///
  /// Takes [targetLang] language code of language to translate into.
  ///
  /// Takes [options] as optional [DocumentTranslateOptions] object containing
  /// additional options controlling translation.
  ///
  /// Fulfills with a [DocumentStatus] object for the completed translation. You
  /// can use the [billedCharacters] property to check how many characters were
  /// billed for the document.
  ///
  /// Throws [Error] if no file exists at the input file path.
  ///
  /// Throws [DocumentTranslationError] if any error occurs during document
  /// upload, translation or download. The [documentHandle] property of the
  /// error may be used to recover the document.
  Future<DocumentStatus> translateDocument(
    File inputFile,
    File outputFile,
    String targetLang, {
    String? sourceLang,
    DocumentTranslateOptions? options,
  }) async {
    // upload document
    DocumentHandle documentHandle = await uploadDocument(inputFile, targetLang,
        sourceLang: sourceLang, options: options);
    // wait for translation to complete
    DocumentTranslationStatus translationStatus =
        await isDocumentTranslationComplete(documentHandle);
    // download document
    await downloadDocument(documentHandle, outputFile);
    // return status
    return translationStatus.status;
  }

  /// Uploads specified document to DeepL to translate into target language, and
  /// returns handle associated with the document.
  ///
  /// Takes a [File] as [inputFile].
  ///
  /// Takes [sourceLang] language code of input document, or null to use
  /// auto-detection.
  ///
  /// Takes [targetLang] language code of language to translate into.
  ///
  /// Takes [options] optional [DocumentTranslateOptions] object containing
  /// additional options controlling translation.
  ///
  /// Fulfills with [DocumentHandle] associated with the in-progress
  /// translation.
  Future<DocumentHandle> uploadDocument(
    File inputFile,
    String targetLang, {
    String? sourceLang,
    DocumentTranslateOptions? options,
  }) async {
    Uri uri = _buildUri(_serverUrl, '/v2/document');
    // build params for validity check
    _buildURLSearchParams(
        targetLang: targetLang,
        sourceLang: sourceLang,
        formality: options?.formality,
        glossaryId: options?.glossaryId);
    http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', inputFile.path,
          filename: options?.filename))
      ..fields['target_lang'] = targetLang;
    if (sourceLang != null) {
      request.fields['source_lang'] = sourceLang;
    }
    if (options?.filename != null) {
      request.fields['filename'] = options!.filename!;
    }
    if (options?.formality != null) {
      request.fields['formality'] = options!.formality!;
    }
    if (options?.glossaryId != null) {
      request.fields['glossary_id'] = options!.glossaryId!;
    }
    _headers.forEach((k, v) {
      request.headers[k] = v;
    });
    http.StreamedResponse response = await _httpClient.send(request);
    String body = await response.stream.bytesToString();
    await _checkStatusCode(response.statusCode, body,
        reasonPhrase: response.reasonPhrase);
    return DocumentHandle.fromJson(jsonDecode(body));
  }

  /// Retrieves the status of the document translation associated with the given
  /// document handle.
  ///
  /// Takes document [handle] associated with document.
  ///
  /// Fulfills with a [DocumentStatus] giving the document translation status.
  Future<DocumentStatus> getDocumentStatus(DocumentHandle handle) async {
    Map<String, String> urlSearchParams = {'document_key': handle.documentKey};
    Uri uri = _buildUri(_serverUrl, '/v2/document/${handle.documentId}',
        urlSearchParams: urlSearchParams);
    Response response = await _httpClient.get(uri, headers: _headers);
    await _checkStatusCode(response.statusCode, response.body,
        reasonPhrase: response.reasonPhrase, inDocumentDownload: true);
    return DocumentStatus.fromJson(jsonDecode(response.body));
  }

  /// Downloads the translated document associated with the given document
  /// handle to the specified output file path or stream.handle.
  ///
  /// Takes document [handle] associated with document.
  ///
  /// Takes [outputFile] to store file data.
  Future<void> downloadDocument(DocumentHandle handle, File outputFile) async {
    Uri uri = _buildUri(_serverUrl, '/v2/document/${handle.documentId}/result',
        urlSearchParams: {'document_key': handle.documentKey});
    Response response = await _httpClient.get(uri, headers: _headers);
    await _checkStatusCode(response.statusCode, response.body,
        reasonPhrase: response.reasonPhrase, inDocumentDownload: true);
    await outputFile.writeAsBytes(response.bodyBytes);
  }

  /// Returns a promise that resolves when the given document translation
  /// completes, or rejects if there was an error communicating with the DeepL
  /// API or the document translation failed.
  ///
  /// Takes [handle] to the document translation.
  ///
  /// Fulfills with input [DocumentHandle] and [DocumentStatus] when the
  /// document translation completes successfully, rejects if translation fails
  /// or a communication error occurs.
  Future<DocumentTranslationStatus> isDocumentTranslationComplete(
      DocumentHandle handle) async {
    DocumentStatus status = await getDocumentStatus(handle);
    while (!status.done && status.ok) {
      double secs = (status.secondsRemaining ?? 0) / 2.0 + 1.0;
      secs = max(1.0, min(secs, 60.0));
      await Future.delayed(Duration(seconds: secs.floor()));
      print(
          'Rechecking document translation status after sleeping for $secs seconds.');
      status = await getDocumentStatus(handle);
    }
    if (!status.ok) {
      throw DeepLError(message: status.errorMessage ?? 'unknown error');
    }
    return DocumentTranslationStatus(handle, status);
  }

  // ============ GLOSSARY MANAGEMENT ==========================================

  /// Queries language pairs supported for glossaries by DeepL API.
  ///
  /// Fulfills with an array of [GlossaryLanguagePair] objects containing
  /// languages supported for glossaries.
  Future<List<GlossaryLanguagePair>> getGlossaryLanguagePairs() async {
    Uri uri = _buildUri(_serverUrl, '/v2/glossary-language-pairs');
    Response response = await _httpClient.get(uri, headers: _headers);
    await _checkStatusCode(response.statusCode, response.body,
        reasonPhrase: response.reasonPhrase);
    return GlossaryLanguagePairListApiResponse.fromJson(
            jsonDecode(response.body))
        .supportedLanguages;
  }

  /// Creates a new glossary on DeepL server with given name, languages, and
  /// entries.
  ///
  /// Takes user-defined [name] to assign to the glossary.
  ///
  /// Takes [sourceLang] language code of the glossary source terms.
  ///
  /// Takes [targetLang] language code of the glossary target terms.
  ///
  /// Takes [entries] as the source- & target-term pairs to add to the glossary.
  ///
  /// Fulfills with a [GlossaryInfo] containing details about the created
  /// glossary.
  Future<GlossaryInfo> createGlossary(
      {required String name,
      required String sourceLang,
      required String targetLang,
      required GlossaryEntries entries}) async {
    assert(name.isNotEmpty, 'glossary name must be a non-empty string');
    assert(entries.entries.isNotEmpty, 'glossary entries must not be empty');
    String tsvContent = entries.toTsv();
    return _createGlossaryInternally(
        name: name,
        sourceLang: sourceLang,
        targetLang: targetLang,
        entriesFormat: 'tsv',
        entries: tsvContent);
  }

  /// Creates a new glossary on DeepL server with given name, languages, and CSV
  /// data.
  ///
  /// Takes user-defined [name] to assign to the glossary.
  ///
  /// Takes [sourceLang] language code of the glossary source terms.
  ///
  /// Takes [targetLang] language code of the glossary target terms.
  ///
  /// Takes [csvFile] containing the source- & target-term pairs as CSV to add
  /// to the glossary.
  ///
  /// Fulfills with a [GlossaryInfo] containing details about the created
  /// glossary.
  Future<GlossaryInfo> createGlossaryWithCsvFile(
      {required String name,
      required String sourceLang,
      required String targetLang,
      required File csvFile}) async {
    assert(name.isNotEmpty, 'glossary name must be a non-empty string');
    assert(await csvFile.exists(), 'csv file must exist');
    String csvContent = await csvFile.readAsString();
    assert(csvContent.isNotEmpty, 'csv file must be non empty');
    return _createGlossaryInternally(
        name: name,
        sourceLang: sourceLang,
        targetLang: targetLang,
        entriesFormat: 'csv',
        entries: csvContent);
  }

  Future<GlossaryInfo> _createGlossaryInternally(
      {required String name,
      required String sourceLang,
      required String targetLang,
      required String entriesFormat,
      required String entries}) async {
    sourceLang = _nonRegionalLanguageCode(sourceLang);
    targetLang = _nonRegionalLanguageCode(targetLang);
    Map<String, String> data = {
      'name': name,
      'source_lang': sourceLang,
      'target_lang': targetLang,
      'entries_format': entriesFormat,
      'entries': entries
    };
    Uri uri = _buildUri(_serverUrl, '/v2/glossaries');
    Response response = await _httpClient.post(uri,
        headers: _headers,
        body: data,
        encoding: Encoding.getByName('application/x-www-form-urlencoded'));
    await _checkStatusCode(response.statusCode, response.body,
        reasonPhrase: response.reasonPhrase, usingGlossary: true);
    return GlossaryInfo.fromJson(jsonDecode(response.body));
  }

  /// Gets information about an existing glossary.
  ///
  /// Takes [glossaryId] of the glossary.
  ///
  /// Fulfills with a [GlossaryInfo] containing details about the glossary.
  Future<GlossaryInfo> getGlossary(String glossaryId) async {
    assert(glossaryId.isNotEmpty, 'glossaryId must be a non-empty string');
    Uri uri = _buildUri(_serverUrl, '/v2/glossaries/$glossaryId');
    Response response = await _httpClient.get(uri, headers: _headers);
    await _checkStatusCode(response.statusCode, response.body,
        reasonPhrase: response.reasonPhrase, usingGlossary: true);
    return GlossaryInfo.fromJson(jsonDecode(response.body));
  }

  /// Gets information about all existing glossaries.
  ///
  /// Fulfills with an array of [GlossaryInfo] containing details about all
  /// existing glossaries.
  Future<List<GlossaryInfo>> listGlossaries() async {
    Uri uri = _buildUri(_serverUrl, '/v2/glossaries');
    Response response = await _httpClient.get(uri, headers: _headers);
    await _checkStatusCode(response.statusCode, response.body,
        reasonPhrase: response.reasonPhrase, usingGlossary: true);
    return GlossaryInfoListApiResponse.fromJson(jsonDecode(response.body))
        .glossaries;
  }

  /// Retrieves the entries stored with the glossary with the given glossary ID
  /// or GlossaryInfo.
  ///
  /// Takes [glossaryId] or [glossaryInfo] of glossary to retrieve entries of.
  ///
  /// Fulfills with [GlossaryEntries] holding the glossary entries.
  Future<GlossaryEntries> getGlossaryEntries(
      {String? glossaryId, GlossaryInfo? glossaryInfo}) async {
    assert(
        (glossaryId != null && glossaryInfo == null) ||
            (glossaryId == null && glossaryInfo != null),
        'glossaryId and glossaryInfo are both not null or both null. only one is allowed');
    glossaryId = glossaryId ?? glossaryInfo!.glossaryId;
    assert(glossaryId.isNotEmpty, 'glossaryId must be a non-empty string');
    Uri uri = _buildUri(_serverUrl, '/v2/glossaries/$glossaryId/entries');
    Response response = await _httpClient.get(uri, headers: _headers);
    await _checkStatusCode(response.statusCode, response.body,
        reasonPhrase: response.reasonPhrase, usingGlossary: true);
    return GlossaryEntries.constructFromTsv(response.body);
  }

  /// Deletes the glossary with the given glossary ID or GlossaryInfo.
  /// @param glossary Glossary ID or GlossaryInfo of glossary to be deleted.
  /// @return Fulfills with undefined when the glossary is deleted.
  Future<void> deleteGlossary(
      {String? glossaryId, GlossaryInfo? glossaryInfo}) async {
    assert(
        (glossaryId != null && glossaryInfo == null) ||
            (glossaryId == null && glossaryInfo != null),
        'glossaryId and glossaryInfo are both not null or both null. only one is allowed');
    glossaryId = glossaryId ?? glossaryInfo!.glossaryId;
    assert(glossaryId.isNotEmpty, 'glossaryId must be a non-empty string');
    Uri uri = _buildUri(_serverUrl, '/v2/glossaries/$glossaryId');
    Response response = await _httpClient.delete(uri, headers: _headers);
    await _checkStatusCode(response.statusCode, response.body,
        reasonPhrase: response.reasonPhrase, usingGlossary: true);
  }

  // ============ PRIVATE ======================================================

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

  /// Removes the regional variant from a language, for example inputs 'en' and
  /// 'en-US' both return 'en'.
  ///
  /// Takes [langCode] string containing language code to convert.
  ///
  /// Returns language code with regional variant removed.
  String _nonRegionalLanguageCode(String langCode) {
    assert(langCode.isNotEmpty, 'langCode must be a non-empty string');
    return langCode.split('-')[0].toLowerCase();
  }

  /// Builds an URI to send a request to.
  Uri _buildUri(String serverUrl, String path,
      {Map<String, String>? urlSearchParams}) {
    StringBuffer sb = StringBuffer(serverUrl);
    sb.write(path);
    sb.write('?');
    if (urlSearchParams != null) {
      String paramsString =
          urlSearchParams.entries.map((e) => '${e.key}=${e.value}').join('&');
      sb.write(paramsString);
    }
    return Uri.parse(sb.toString());
  }

  /// Checks the HTTP status code, and in case of failure, throws an exception with diagnostic information.
  Future<void> _checkStatusCode(
    int statusCode,
    String content, {
    String? reasonPhrase = 'Unknown',
    bool usingGlossary = false,
    bool inDocumentDownload = false,
  }) async {
    if (200 <= statusCode && statusCode < 400) return;
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
      message = ', $content';
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
        if (inDocumentDownload) {
          throw DocumentNotReadyError(message: 'Document not ready$message');
        } else {
          throw DeepLError(message: 'Service unavailable$message');
        }
      default:
        {
          throw DeepLError(
            message:
                'Unexpected status code: $statusCode $reasonPhrase$message, content: $content',
          );
        }
    }
  }
}
