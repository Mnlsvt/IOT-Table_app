/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color _boxColor = Colors.red;
  String _responseText = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Box Controller'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: _boxColor,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(_responseText),
          ],
        ),
      ),
    );
  }

  void _updateBoxColor(String status) {
    setState(() {
      _boxColor = status == 'on' ? Colors.green : Colors.red;
    });
  }

  void _updateResponseText(String text) {
    setState(() {
      _responseText = text;
    });
  }

  void _handleRequest() async {
    try {
      final response =
          await Dio().get('http://mnlsvtserver.ddns.net:4000/api/sensor-data');
      if (response.statusCode == 200) {
        _updateBoxColor(response.data['table_value']);
        _updateResponseText(response.data['table_value']);
      } else {
        throw Exception('Failed to receive request from server');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (Timer t) => _handleRequest());
  }
}
*/


import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Store {
  final String name;

  Store(this.name);
}

class Square extends StatefulWidget {
  final int tableId;
  final String id;
  final double initialX;
  final double initialY;
  final double boxWidth;
  final double boxHeight;

  Square({
    required this.tableId,
    required this.id,
    required this.initialX,
    required this.initialY,
    required this.boxWidth,
    required this.boxHeight,
  });

  @override
  _SquareState createState() => _SquareState();
}

class _SquareState extends State<Square> {
  bool isAvailable = false;
  double x = 0;
  double y = 0;

  void checkAvailability() async {
    try {
      Response response = await Dio().get('API_URL_HERE?id=${widget.id}');
      if (response.statusCode == 200) {
        setState(() {
          isAvailable = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    checkAvailability();
    x = widget.initialX;
    y = widget.initialY;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Draggable(
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isAvailable ? Colors.green : Colors.red,
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
        ),
        feedback: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isAvailable ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
        ),
        onDraggableCanceled: (velocity, offset) {
          setState(() {
            // Restrict the movement within the box
            x = offset.dx.clamp(0, widget.boxWidth - 40);
            y = offset.dy.clamp(0, widget.boxHeight - 40);
          });
        },
      ),
    );
  }
}

class TablePage extends StatelessWidget {
  final Store store;

  TablePage(this.store);

  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width - 40;
    double boxHeight = 400;

    return Scaffold(
      appBar: AppBar(
        title: Text(store.name),
      ),
      body: Center(
        child: Container(
          width: boxWidth,
          height: boxHeight,
          color: Colors.grey,
          child: Stack(
            children: [
              Square(
                tableId: 1,
                id: 'square1',
                initialX: 10,
                initialY: 10,
                boxWidth: boxWidth,
                boxHeight: boxHeight,
              ),
              Square(
                tableId: 2,
                id: 'square2',
                initialX: 100,
                initialY: 80,
                boxWidth: boxWidth,
                boxHeight: boxHeight,
              ),
              Square(
                tableId: 3,
                id: 'square3',
                initialX: 200,
                initialY: 180,
                boxWidth: boxWidth,
                boxHeight: boxHeight,
),
Square(
tableId: 4,
id: 'square4',
initialX: 300,
initialY: 250,
boxWidth: boxWidth,
boxHeight: boxHeight,
),
Square(
tableId: 5,
id: 'square5',
initialX: 50,
initialY: 300,
boxWidth: boxWidth,
boxHeight: boxHeight,
),
],
),
),
),
);
}
}

class MenuPage extends StatelessWidget {
final List<Store> stores = [
Store('Store 1'),
Store('Store 2'),
Store('Store 3'),
];

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('Store Menu'),
),
body: ListView.builder(
itemCount: stores.length,
itemBuilder: (context, index) {
return ListTile(
title: Text(stores[index].name),
onTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => TablePage(stores[index]),
),
);
},
);
},
),
);
}
}

void main() {
runApp(MaterialApp(
home: MenuPage(),
));
}
               
