import 'package:dep_analyzer/src/file_maker.dart';

import 'package:dep_analyzer/src/models/dep_data.dart';
import 'package:dep_analyzer/src/repositories/dep_data_processor.dart';

class JsonDepDataProcessor with FileMaker implements DepDataProcessor {
  final bool pretty;
  final String outputDirectory;

  JsonDepDataProcessor({required this.pretty, required this.outputDirectory});

  @override
  Future<void> process(DepData depData) async {
    final file = makeFile(
      directory: outputDirectory,
      name: '${depData.computedPeriodYM}_dep-analysis',
      extension: 'json',
    );
    await file.writeAsString(depData.toJsonString(pretty: pretty));
  }
}
