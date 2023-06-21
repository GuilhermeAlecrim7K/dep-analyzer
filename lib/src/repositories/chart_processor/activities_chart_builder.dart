import 'package:dep_analyzer/src/models/activity_data.dart';
import 'package:dep_analyzer/src/repositories/chart_processor/quick_chart_io.dart';

class ActivitiesChartBuilder with QuickChartIO {
  final Iterable<ActivityData> _top5ActivitiesByWorktime;
  ActivitiesChartBuilder(Iterable<ActivityData> activities)
      : _top5ActivitiesByWorktime = (activities.toList(growable: false)
              ..sort(
                (a, b) => b.computedWorkTime.compareTo(a.computedWorkTime),
              ))
            .getRange(0, activities.length >= 5 ? 5 : activities.length);

  Future<List<int>> generateBarChart() {
    final chartData = <String, Object>{
      "type": "bar",
      "data": {
        "labels":
            _top5ActivitiesByWorktime.map((activity) => activity.name).toList(),
        "datasets": [
          {
            "label": "Tempo investido por atividade em horas",
            "data": _top5ActivitiesByWorktime
                .map((activity) => activity.computedWorkTime.inHours)
                .toList(),
            "backgroundColor": 'rgba(54, 162, 235, 0.8)',
            "borderColor": 'rgba(54, 162, 235)',
            "borderWidth": 2
          }
        ]
      }
    };
    return buildChart(chartData: chartData);
  }
}
