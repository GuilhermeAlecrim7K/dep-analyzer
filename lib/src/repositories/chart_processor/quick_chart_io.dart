import 'dart:convert';

import 'package:http/http.dart' as http;

mixin QuickChartIO {
  final Map<String, Object> _baseRequestBody = {
    "version": "2",
    "backgroundColor": "#fff",
    "width": "640",
    "height": "480",
    "devicePixelRatio": 1.0,
  };
  Future<List<int>> buildChart({required Map<String, Object> chartData}) async {
    final requestBody = <String, Object>{}
      ..addEntries(_baseRequestBody.entries);
    requestBody['chart'] = chartData;
    final response = await http.post(
      Uri.https('quickchart.io', '/chart'),
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
      encoding: utf8,
    );
    if (response.statusCode != 200) {
      throw http.ClientException(
        'Request error! ${response.reasonPhrase}',
        response.request?.url,
      );
    } else {
      return response.bodyBytes;
    }
  }
}
