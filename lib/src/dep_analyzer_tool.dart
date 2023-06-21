import 'dart:io';

import 'package:dep_analyzer/src/dep_analyzer.dart';
import 'package:dep_analyzer/src/dep_analyzer_from_csv.dart';
import 'package:dep_analyzer/src/repositories/dep_data_processor.dart';

class DepAnalyzerTool {
  Future<void> analyze({
    required File file,
    required Set<DepDataProcessor> depDataProcessors,
  }) async {
    final DepAnalyzer analyzer = CsvDepAnalyzer(file);
    final analysisResults = analyzer.analysisResults;
    for (final processor in depDataProcessors) {
      await processor.process(analysisResults);
    }
  }
}
