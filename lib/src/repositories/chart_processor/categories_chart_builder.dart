import 'package:dep_analyzer/src/models/category_data.dart';
import 'package:dep_analyzer/src/repositories/chart_processor/quick_chart_io.dart';

class CategoriesChartBuilder with QuickChartIO {
  final Iterable<CategoryData> _categories;
  CategoriesChartBuilder(Iterable<CategoryData> categories)
      : _categories = categories.toList(growable: false)
          ..sort((a, b) => a.name.compareTo(b.name));

  Future<List<int>> generatePolarAreaChart() {
    final chartData = <String, Object>{
      "type": "polarArea",
      "data": {
        "labels": _categories.map((category) => category.name).toList(),
        "datasets": [
          {
            "label": "Tempo investido por categoria de trabalho em horas",
            "data": _categories
                .map((category) => category.computedWorkTime.inHours)
                .toList(),
            "backgroundColor": [
              'rgb(255, 99, 132)',
              'rgb(75, 192, 192)',
              'rgb(255, 205, 86)',
              'rgb(201, 203, 207)',
            ],
          }
        ]
      }
    };
    return buildChart(chartData: chartData);
  }
}
