import 'package:collection/collection.dart';
import 'package:deepl_dart/src/model/errors.dart';

/// Stores the entries of a glossary.
class GlossaryEntries {
  Map<String, String> _entries = {};

  /// Retrieve the contained entries.
  Map<String, String> get entries => _entries;

  /// Construct a [GlossaryEntries] object containing optionally the specified
  /// entries as a map.
  ///
  /// [entries] map containing fields storing entries, for example:
  /// `{'Hello': 'Hallo'}`.
  ///
  /// Returns [GlossaryEntries] object containing parsed entries.
  ///
  /// Throws [DeepLError] if given entries contain invalid characters.
  GlossaryEntries({Map<String, String>? entries}) {
    if (entries != null) {
      _entries = entries;
    }
  }

  /// Construct a [GlossaryEntries] object containing the tab-separated values
  /// (TSV) string.
  ///
  /// [tsv] [String] containing TSV to parse. Each line should contain a source
  /// and target term separated by a tab. Empty lines are ignored.
  ///
  /// Returns [GlossaryEntries] object containing parsed entries.
  ///
  /// Throws [DeepLError] if given entries contain invalid characters.
  static GlossaryEntries constructFromTsv(String tsv) {
    GlossaryEntries glossary = GlossaryEntries();
    for (String entry in tsv.split(RegExp('\r\n|\n|\r'))) {
      if (entry.isEmpty) continue;
      List<String> parts = entry.split('\t');
      if (parts.length < 2) {
        throw DeepLError(message: "Missing tab character in entry '$entry'");
      } else if (parts.length > 2) {
        throw DeepLError(message: "Duplicate tab character in entry '$entry'");
      }
      glossary.add(parts[0], parts[1]);
    }
    return glossary;
  }

  /// Add the specified source-target entry.
  ///
  /// [source] term of the glossary entry.
  ///
  /// [target] term of the glossary entry.
  ///
  /// [overwrite] if false, throw an error if the source entry already exists.
  void add(String source, String target, {bool overwrite = false}) {
    if (!overwrite && _entries.containsKey(source)) {
      throw DeepLError(message: "Duplicate source term '$source'");
    }
    _entries[source] = target;
  }

  /// Converts glossary entries to a tab-separated values (TSV) string.
  ///
  /// Returns [String] containing entries in TSV format.
  ///
  /// Throws [DeepLError] if any glossary entries are invalid.
  String toTsv() => _entries.entries.map((e) {
        validateGlossaryTerm(e.key);
        validateGlossaryTerm(e.value);
        return '${e.key}\t${e.value}';
      }).join('\n');

  @override
  operator ==(Object other) {
    if (other is! GlossaryEntries) return false;
    return MapEquality().equals(_entries, other._entries);
  }

  @override
  int get hashCode => _entries.hashCode;

  @override
  String toString() => 'GlossaryEntries[entries: ${_entries.toString()}]';

  /// Checks if the given glossary term contains any disallowed characters.
  ///
  /// Takes glossary [term] term to check for validity.
  ///
  /// Throws [DeepLError] if the term is not valid or a disallowed character is
  /// found.
  static void validateGlossaryTerm(String term) {
    assert(term.isNotEmpty, "'$term' is not a valid term.");
    for (int i = 0; i < term.codeUnits.length; i++) {
      int codeUnit = term.codeUnits[i];
      if ((0 <= codeUnit && codeUnit <= 31) || // C0 control units
              (127 <= codeUnit && codeUnit <= 159) || // C1 control units
              codeUnit == 0x2028 ||
              codeUnit == 0x2029 // unicode newlines
          ) {
        throw DeepLError(
            message:
                "Term '$term' contains invalid character: '${term.substring(i, i + 1)}' ($codeUnit)");
      }
    }
  }
}
