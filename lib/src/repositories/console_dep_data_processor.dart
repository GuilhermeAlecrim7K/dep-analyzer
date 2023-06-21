import 'dart:io';
import 'package:dep_analyzer/src/models/dep_data.dart';
import 'package:dep_analyzer/src/repositories/dep_data_processor.dart';

class ConsoleDepDataProcessor implements DepDataProcessor {
  @override
  Future<void> process(DepData depData) async {
    for (final category in depData.categories) {
      stdout.writeln(
        '${category.name};${category.computedWorkTime}',
      );
    }
  }
}
