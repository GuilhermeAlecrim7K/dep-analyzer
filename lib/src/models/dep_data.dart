import 'dart:convert';

import 'package:dep_analyzer/src/models/category_data.dart';

class DepData {
  Duration _totalComputedWorkTime = Duration.zero;
  Duration _expectedComputedWorkTime = Duration.zero;
  DateTime? _firstComputedDate;
  DateTime? _lastComputedDate;
  final Set<DateTime> _computedWorkDays = <DateTime>{};
  final Map<String, CategoryData> _categories = {};

  void compute({
    required DateTime date,
    required String categoryName,
    required String activityId,
    String? description,
    required Duration timeSpent,
  }) {
    _firstComputedDate ??= date;
    _lastComputedDate = date;
    if (categoryName.toUpperCase() == 'PAUSA' ||
        activityId.toUpperCase() == 'PAUSA') {
      return;
    }
    if (!_computedWorkDays.contains(date)) {
      _computedWorkDays.add(date);
      _expectedComputedWorkTime += const Duration(hours: 8);
    }
    _totalComputedWorkTime += timeSpent;
    _categories[categoryName] ??= CategoryData(name: categoryName);
    _categories[categoryName]!.compute(
      date: date,
      activityId: activityId,
      timeSpent: timeSpent,
    );
  }

  Map<String, Object> toJson() {
    final result = {
      'totalComputedWorkTime': _totalComputedWorkTime,
      'expectedComputedWorkTime': _expectedComputedWorkTime,
      'amountOfWorkingDaysInThePeriod': _computedWorkDays.length,
      'categories': [
        for (final category in _categories.values) category.toJson()
      ],
    };

    for (final categoryJson
        in result['categories']! as List<Map<String, Object>>) {
      categoryJson['computedWorkTimeRatio'] =
          (categoryJson['computedWorkTime']! as Duration).inSeconds /
              _totalComputedWorkTime.inSeconds;
      categoryJson['correctedWorkTimeBasedOnRatio'] = Duration(
        seconds: ((categoryJson['computedWorkTimeRatio']! as double) *
                _expectedComputedWorkTime.inSeconds)
            .round(),
      ).toString();
      for (final activityJson
          in categoryJson['activities']! as List<Map<String, Object>>) {
        activityJson['computedWorkTimeRatioRelativeToPeriod'] =
            (activityJson['computedWorkTime']! as Duration).inSeconds /
                _totalComputedWorkTime.inSeconds;
        activityJson['computedWorkTimeRatioRelativeToCategory'] =
            (activityJson['computedWorkTime']! as Duration).inSeconds /
                (categoryJson['computedWorkTime']! as Duration).inSeconds;
      }
    }
    return result;
  }

  String toJsonString({bool pretty = false}) {
    return JsonEncoder.withIndent(
      pretty ? ' ' : null,
      (nonEncodable) {
        if (nonEncodable is DepData) return nonEncodable.toJson();
        if (nonEncodable is Duration) return nonEncodable.toString();
        throw UnimplementedError(
            'Non-encodable class found when converting map to json. '
            '$nonEncodable');
      },
    ).convert(this);
  }

  Iterable<CategoryData> get categories => _categories.values;
  DateTime? get firstComputedDate => _firstComputedDate;
  DateTime? get lastComputedDate => _lastComputedDate;
  String? get computedPeriodYM {
    String? result;
    if (_firstComputedDate != null) {
      result = '${_firstComputedDate!.year}-'
          '${_firstComputedDate!.month.toString().padLeft(2, '0')}';
    }
    if (_lastComputedDate != null &&
        _lastComputedDate!.month != _firstComputedDate!.month) {
      result = '${result}_${_lastComputedDate!.year}-'
          '${_lastComputedDate!.month.toString().padLeft(2, '0')}';
    }
    return result;
  }
}
