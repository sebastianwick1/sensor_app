import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SensorPlotApp(),
    );
  }
}

class SensorPlotApp extends StatefulWidget {
  @override
  _SensorPlotAppState createState() => _SensorPlotAppState();
}

class _SensorPlotAppState extends State<SensorPlotApp> {
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  List<List<double>> _accelerometerValues = [];
  List<List<double>> _gyroscopeValues = [];
  List<List<double>> _magnetometerValues = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues.add(<double>[event.x, event.y, event.z]);
        if (_accelerometerValues.length > 10) {
          _accelerometerValues.removeAt(0);
        }
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues.add(<double>[event.x, event.y, event.z]);
        if (_gyroscopeValues.length > 10) {
          _gyroscopeValues.removeAt(0);
        }
      });
    }));
    _streamSubscriptions
        .add(magnetometerEvents.listen((MagnetometerEvent event) {
      setState(() {
        _magnetometerValues.add(<double>[event.x, event.y, event.z]);
        if (_magnetometerValues.length > 10) {
          _magnetometerValues.removeAt(0);
        }
      });
    }));

    _startTimers();
  }

  void _startTimers() {
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _accelerometerValues = List.from(_accelerometerValues);
        _gyroscopeValues = List.from(_gyroscopeValues);
        _magnetometerValues = List.from(_magnetometerValues);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bridge Health App'),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          }),
        ],
      ),
      endDrawer: _buildProfileDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildSensorDataCard(
              title: 'Accelerometer',
              values: _accelerometerValues,
              color: Colors.red,
            ),
            _buildSensorDataCard(
              title: 'Gyroscope',
              values: _gyroscopeValues,
              color: Colors.green,
            ),
            _buildSensorDataCard(
              title: 'Magnetometer',
              values: _magnetometerValues,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40.0,
                ),
                SizedBox(height: 8.0),
                Text(
                  'John Doe',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 4.0),
                Text(
                  'john.doe@example.com',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text('Sign In'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(Icons.update),
            title: Text('Update Password'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSensorDataCard(
      {String? title, List<List<double>>? values, Color? color}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title!,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: _buildLineChart(_buildSensorDataSpots(values!), color!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(List<List<FlSpot>> spots, Color color) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 10,
        minY: -100,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: spots[0],
            isCurved: false,
            barWidth: 1,
            isStrokeCapRound: true,
            colors: [color.withOpacity(0.6)],
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            spots: spots[1],
            isCurved: false,
            barWidth: 1,
            isStrokeCapRound: true,
            colors: [color.withOpacity(0.8)],
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            spots: spots[2],
            isCurved: false,
            barWidth: 1,
            isStrokeCapRound: true,
            colors: [color],
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  List<List<FlSpot>> _buildSensorDataSpots(List<List<double>> values) {
    List<FlSpot> spotsX = [];
    List<FlSpot> spotsY = [];
    List<FlSpot> spotsZ = [];

    for (int i = 0; i < values.length; i++) {
      spotsX.add(FlSpot(i.toDouble(), values[i][0]));
      spotsY.add(FlSpot(i.toDouble(), values[i][1]));
      spotsZ.add(FlSpot(i.toDouble(), values[i][2]));
    }
    return [spotsX, spotsY, spotsZ];
  }
}
