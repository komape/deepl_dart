import 'package:json_annotation/json_annotation.dart';

part 'glossary_info.g.dart';

@JsonSerializable(createToJson: false)
class GlossaryInfo {
  final String glossaryId;
  final String name;
  final bool ready;
  final String sourceLang;
  final String targetLang;
  final String creationTime;
  final int entryCount;

  GlossaryInfo({
    required this.glossaryId,
    required this.name,
    required this.ready,
    required this.sourceLang,
    required this.targetLang,
    required this.creationTime,
    required this.entryCount,
  });

  factory GlossaryInfo.fromJson(Map<String, dynamic> json) =>
      _$GlossaryInfoFromJson(json);
}
