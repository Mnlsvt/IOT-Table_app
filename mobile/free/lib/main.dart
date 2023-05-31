import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Map<int, Map<int, Alignment>> storeTablePositions = {};

  @override
  void initState() {
    super.initState();
    final List<int> storeIds = [1, 2, 3];
    final List<int> tableIds = [1, 2, 3];
    final gridSize = sqrt(tableIds.length).ceil();
    final cellSize = 2 / gridSize;
    for (final storeId in storeIds) {
      final positions = [
        for (var y = 0; y < gridSize; y++)
          for (var x = 0; x < gridSize; x++)
            Alignment(-1 + cellSize * (x + 0.5), -1 + cellSize * (y + 0.5))
      ]..shuffle();
      storeTablePositions[storeId] = {
        for (var i = 0; i < tableIds.length; i++) tableIds[i]: positions[i],
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StorePage(storeTablePositions: storeTablePositions),
    );
  }
}

class StorePage extends StatelessWidget {
  final List<int> storeIds = [1, 2, 3];
  final Map<int, Map<int, Alignment>> storeTablePositions;

  StorePage({required this.storeTablePositions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Stores', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
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
                  builder: (context) => TablePage(
                    storeId: storeId,
                    tablePositions: storeTablePositions[storeId]!,
                  ),
                ),
              );
            },
            child: Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: Text(
                'Store $storeId',
                style: TextStyle(fontSize: 20, color: Colors.white),
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
  final Map<int, Alignment> tablePositions;

  TablePage({
    required this.storeId,
    required this.tablePositions,
  });

  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  List<int> tableIds = [1, 2, 3];
  Map<int, String> boxColors = {};
  Map<int, Alignment> boxPositions = {};

  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    boxPositions = widget.tablePositions;
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Store ${widget.storeId}',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: tableIds.map((tableId) {
              final boxColor = boxColors[tableId] ?? 'red';
              return Align(
                alignment: boxPositions[tableId]!,
                child: GestureDetector(
                  onTap: () {
                    fetchData();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: boxColor == 'red' ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$tableId',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
