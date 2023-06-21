import 'package:dep_analyzer/src/models/activity_data.dart';

class CategoryData {
  final String _id;

  Duration _computedWorkTime = Duration.zero;
  final Map<String, ActivityData> _activities = <String, ActivityData>{};
  final Set<DateTime> _computedWorkDays = <DateTime>{};

  CategoryData({required String name}) : _id = name;

  void compute({
    required DateTime date,
    required String activityId,
    required Duration timeSpent,
    String? description,
  }) {
    _computedWorkDays.add(date);
    _computedWorkTime += timeSpent;
    _activities[activityId] ??= ActivityData(name: activityId, categoryId: _id);
    _activities[activityId]!.compute(date: date, timeSpent: timeSpent);
  }

  Map<String, Object> toJson() {
    return {
      'id': _id,
      'computedWorkTime': _computedWorkTime,
      'amountOfDaysWorkedOn': _computedWorkDays.length,
      'computedWorkTimeRatio': 0.0,
      'correctedWorkTimeBasedOnRatio': Duration.zero,
      'activities': [
        for (final activity in _activities.values) activity.toJson()
      ]
    };
  }

  Iterable<ActivityData> get activities => _activities.values;
  Duration get computedWorkTime => _computedWorkTime;
  String get name => _id;
}
