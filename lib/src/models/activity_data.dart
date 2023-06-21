class ActivityData {
  Duration _computedWorkTime = Duration.zero;
  final Set<DateTime> _computedWorkDays = <DateTime>{};

  final String _id;
  final String _categoryId;

  ActivityData({required String name, required String categoryId})
      : _id = name,
        _categoryId = categoryId;

  void compute({required DateTime date, required Duration timeSpent}) {
    _computedWorkDays.add(date);
    _computedWorkTime += timeSpent;
  }

  Map<String, Object> toJson() {
    return {
      'id': _id,
      'computedWorkTime': _computedWorkTime,
      'amountOfDaysWorkedOn': _computedWorkDays.length,
      'computedWorkTimeRatioRelativeToPeriod': 0.0,
      'computedWorkTimeRatioRelativeToCategory': 0.0,
    };
  }

  Duration get computedWorkTime => _computedWorkTime;
  String get name => _id;
  String get category => _categoryId;
}
