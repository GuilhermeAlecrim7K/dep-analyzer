import 'package:dep_analyzer/src/file_maker.dart';

import 'package:dep_analyzer/src/models/dep_data.dart';
import 'package:dep_analyzer/src/repositories/dep_data_processor.dart';

class TxtFileDepDataProcessor with FileMaker implements DepDataProcessor {
  final String outputDirectory;
  TxtFileDepDataProcessor({required this.outputDirectory});

  @override
  Future<void> process(DepData depData) async {
    // final file = makeFile(
    //   directory: outputDirectory,
    //   name: '${depData.computedPeriodYM}_dep-analysis',
    //   extension: 'txt',
    // );
    throw UnimplementedError(
        'Must implement more details on DEP before using this function '
        'TODO: Full card name, Jira link');
  }
}
