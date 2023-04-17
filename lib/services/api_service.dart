import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sensor_app/models/data_point.dart';

class ApiService {
  final String apiUrl;

  ApiService({required this.apiUrl});

  Future<List<DataPoint>> fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => DataPoint.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
