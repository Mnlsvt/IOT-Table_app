import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? selectedStoreId;
  int? selectedTableId;
  String boxColor = 'red';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<int>(
              value: selectedStoreId,
              items: [
                DropdownMenuItem(
                  value: 1,
                  child: Text('Store 1'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('Store 2'),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text('Store 3'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedStoreId = value;
                  selectedTableId = null;
                  boxColor = 'red';
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButton<int>(
              value: selectedTableId,
              items: [
                DropdownMenuItem(
                  value: 1,
                  child: Text('Table 1'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('Table 2'),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text('Table 3'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedTableId = value;
                  if (selectedStoreId != null && selectedTableId != null) {
                    fetchData(selectedStoreId!, selectedTableId!);
                  }
                });
              },
            ),
            SizedBox(height: 16),
            Container(
              width: 100,
              height: 100,
              color: boxColor == 'red' ? Colors.red : Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  void fetchData(int storeId, int tableId) async {
    try {
      final response = await Dio().get(
        'http://mnlsvtserver.ddns.net:4000/api/sensor-data/$storeId/$tableId',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          boxColor = data['isFree'] == 'yes' ? 'green' : 'red';
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
