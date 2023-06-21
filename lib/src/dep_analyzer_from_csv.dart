import 'dart:io';

import 'package:dep_analyzer/src/datetime_parser_extension.dart';
import 'package:dep_analyzer/src/dep_analyzer.dart';
import 'package:dep_analyzer/src/duration_parser_extension.dart';
import 'package:dep_analyzer/src/exceptions.dart';
import 'package:dep_analyzer/src/models/dep_data.dart';

class CsvDepAnalyzer implements DepAnalyzer {
  static const _dateIndex = 0;
  static const _categoryIndex = 1;
  static const _idIndex = 2;
  // static const _descriptionIndex = 3;
  static const _timeSpentIndex = 4;

  late final List<String> _depRecords;
  final DepData _depData = DepData();

  CsvDepAnalyzer(File csvFile) {
    if (!csvFile.path.endsWith('.csv')) {
      throw InvalidFileExtensionException();
    }
    try {
      _depRecords = csvFile.readAsLinesSync();
    } on FileSystemException catch (e) {
      if (e.message.contains(RegExp(r"Failed.+encoding\s'utf-8'"))) {
        throw InvalidFileEncodingException();
      }
    }
    if (_depRecords.isEmpty) {
      throw EmptyFileException();
    }
    _analyzeRecords();
  }

  void _analyzeRecords() {
    for (final record in _depRecords) {
      final values = record.split(';');
      _validateRecordValues(values);
      _depData.compute(
        date: DateTimeParser.parseCsvSetDate(values[_dateIndex]),
        categoryName: values[_categoryIndex],
        activityId: values[_idIndex],
        timeSpent: DurationParser.parse(values[_timeSpentIndex]),
      );
    }
  }

  void _validateRecordValues(List<String> values) {
    const expectedNumberOfRows = 5;
    int currentRow() =>
        _depRecords
            .indexOf(values.reduce((value, element) => value + element)) +
        1;
    if (values.length != expectedNumberOfRows) {
      throw InvalidFileFormatException(
        'Number of values above expected($expectedNumberOfRows) at row ${currentRow()}',
      );
    }
    try {
      DateTimeParser.parseCsvSetDate(values[_dateIndex]);
    } on FormatException catch (e) {
      throw FormatException('${e.message} at row ${currentRow()}');
    }
    try {
      DurationParser.parse(values[_timeSpentIndex]);
    } on FormatException catch (e) {
      throw FormatException('${e.message} at row ${currentRow()}');
    }
  }

  @override
  DepData get analysisResults => _depData;
}
