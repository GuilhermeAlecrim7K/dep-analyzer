import 'dart:async';

import 'package:dep_analyzer/src/file_maker.dart';
import 'package:dep_analyzer/src/models/dep_data.dart';
import 'package:dep_analyzer/src/repositories/chart_processor/activities_chart_builder.dart';
import 'package:dep_analyzer/src/repositories/chart_processor/categories_chart_builder.dart';
import 'package:dep_analyzer/src/repositories/dep_data_processor.dart';

class ChartDepDataProcessor with FileMaker implements DepDataProcessor {
  ChartDepDataProcessor({required this.outputDirectory});

  final String outputDirectory;

  @override
  Future<void> process(DepData depData) async {
    final activitiesBarChartPng = makeFile(
      directory: outputDirectory,
      name: '${depData.computedPeriodYM}-activities-bar-chart',
      extension: 'png',
    );
    final categoriesPolarAreaChartPng = makeFile(
      directory: outputDirectory,
      name: '${depData.computedPeriodYM}-categories-polar-area-chart',
      extension: 'png',
    );
    final activitiesChartBuilder = ActivitiesChartBuilder(
      [for (final category in depData.categories) ...category.activities],
    );
    final categoriesChartBuilder = CategoriesChartBuilder(depData.categories);
    final errors = <Exception>[];
    try {
      activitiesBarChartPng
          .writeAsBytesSync(await activitiesChartBuilder.generateBarChart());
    } on Exception catch (e) {
      errors.add(Exception('Error generating Activities Chart: $e'));
    }
    try {
      categoriesPolarAreaChartPng.writeAsBytesSync(
        await categoriesChartBuilder.generatePolarAreaChart(),
      );
    } on Exception catch (e) {
      errors.add(Exception('Error generating Categories Chart: $e'));
    }

    if (errors.isNotEmpty) {
      throw Exception(
        errors.fold(
          '',
          (previousValue, element) => '$previousValue\n$element',
        ),
      );
    }
  }
}
