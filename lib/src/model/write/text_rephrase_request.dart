import 'dart:convert';

import 'package:deepl_dart/src/model/write/tone.dart';
import 'package:deepl_dart/src/model/write/writing_style.dart';
import 'package:json_annotation/json_annotation.dart';

part 'text_rephrase_request.g.dart';

@JsonSerializable(
  includeIfNull: false,
  createFactory: false,
)
class TextRephraseRequest {
  final List<String> text;
  final String? targetLang;
  final WritingStyle? writingStyle;
  final Tone? tone;

  TextRephraseRequest({
    required this.text,
    this.targetLang,
    this.writingStyle,
    this.tone,
  });

  String toJson() => jsonEncode(_$TextRephraseRequestToJson(this));
}
