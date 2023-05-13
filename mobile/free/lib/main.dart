import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StorePage(),
    );
  }
}

class StorePage extends StatelessWidget {
  final List<int> storeIds = [1, 2, 3];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stores'),
      ),
      body: ListView.builder(
        itemCount: storeIds.length,
        itemBuilder: (context, index) {
          final storeId = storeIds[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TablePage(storeId: storeId),
                ),
              );
            },
            child: Container(
              height: 100,
              margin: const EdgeInsets.only(
                  left: 30, right: 30, bottom: 20, top: 30),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                border: Border(
                  bottom: BorderSide(color: Colors.black),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'Store $storeId',
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TablePage extends StatefulWidget {
  final int storeId;

  TablePage({required this.storeId});

  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  List<int> tableIds = [1, 2, 3];
  Map<int, String> boxColors = {};

  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      fetchData();
    });
  }

  void cancelTimer() {
    timer?.cancel();
  }

  void fetchData() async {
    try {
      for (final tableId in tableIds) {
        final response = await Dio().get(
          'http://mnlsvtserver.ddns.net:4000/api/sensor-data/${widget.storeId}/$tableId',
        );

        if (response.statusCode == 200) {
          final data = response.data;
          setState(() {
            boxColors[tableId] = data['isFree'] == 'yes' ? 'green' : 'red';
          });
        } else {
          print('Error: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tables - Store ${widget.storeId}'),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        padding: EdgeInsets.all(16),
        children: tableIds.map((tableId) {
          final boxColor = boxColors[tableId] ?? 'red';
          return GestureDetector(
            onTap: () {
              fetchData();
            },
            child: Stack(
              // Wrap the Container with a Stack
              children: [
                Container(
                  color: boxColor == 'red' ? Colors.red : Colors.green,
                ),
                Center(
                  child: Text(
                    'Table $tableId',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
