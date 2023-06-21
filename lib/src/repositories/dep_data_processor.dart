import 'package:dep_analyzer/src/models/dep_data.dart';

abstract class DepDataProcessor {
  Future<void> process(DepData depData);
}
