import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color _boxColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Box Controller'),
        ),
        body: Center(
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
      ),
    );
  }

  void _updateBoxColor(String status) {
    setState(() {
      _boxColor = status == 'on' ? Colors.green : Colors.red;
    });
  }

  void _handleRequest() async {
    final response = await http.get(Uri.parse('http://node-server-url/request'));
    if (response.statusCode == 200) {
      _updateBoxColor(response.body);
    } else {
      throw Exception('Failed to receive request from server');
    }
  }

  @override
  void initState() {
    super.initState();
    _handleRequest();
  }
}
