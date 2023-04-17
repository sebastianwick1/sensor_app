import 'package:flutter/material.dart';
import 'package:sensor_app/services/api_service.dart';
import 'package:sensor_app/models/data_point.dart';
import 'package:sensor_app/widgets/line_chart_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Live Data Line Chart')),
        body: LiveDataChart(apiUrl: 'put the API link here'),
      ),
    );
  }
}

class LiveDataChart extends StatefulWidget {
  final String apiUrl;

  LiveDataChart({required this.apiUrl});

  @override
  _LiveDataChartState createState() => _LiveDataChartState();
}

class _LiveDataChartState extends State<LiveDataChart> {
  late Future<List<DataPoint>> futureDataPoints;

  @override
  void initState() {
    super.initState();
    futureDataPoints = ApiService(apiUrl: widget.apiUrl).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<DataPoint>>(
        future: futureDataPoints,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: LineChartWidget(dataPoints: snapshot.data!),
            );
          } else {
            return Text('No data available');
          }
        },
      ),
    );
  }
}
