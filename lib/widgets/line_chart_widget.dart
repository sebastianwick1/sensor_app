import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sensor_app/models/data_point.dart';

class LineChartWidget extends StatelessWidget {
  final List<DataPoint> dataPoints;

  LineChartWidget({required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: dataPoints.length.toDouble(),
        minY: dataPoints.map((e) => e.value).reduce((a, b) => a < b ? a : b),
        maxY: dataPoints.map((e) => e.value).reduce((a, b) => a > b ? a : b),
        lineBarsData: [
          LineChartBarData(
            spots: dataPoints
                .asMap()
                .entries
                .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
                .toList(),
            isCurved: true,
            colors: [Colors.blue],
            barWidth: 2,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
