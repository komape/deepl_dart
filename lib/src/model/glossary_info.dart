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

  @override
  operator ==(Object other) {
    if (other is! GlossaryInfo) return false;
    return glossaryId == other.glossaryId &&
        name == other.name &&
        ready == other.ready &&
        sourceLang == other.sourceLang &&
        targetLang == other.targetLang &&
        creationTime == other.creationTime &&
        entryCount == other.entryCount;
  }

  @override
  String toString() =>
      'GlossaryInfo[glossaryId: $glossaryId, name: $name, ready: $ready, sourceLang: $sourceLang, targetLang: $targetLang, creationTime: $creationTime, entryCount: $entryCount]';

  @override
  int get hashCode =>
      glossaryId.hashCode +
      name.hashCode +
      ready.hashCode +
      sourceLang.hashCode +
      targetLang.hashCode +
      creationTime.hashCode +
      entryCount.hashCode;
}
