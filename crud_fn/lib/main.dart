import 'dart:convert';
import 'package:crud_fn/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _dataController = TextEditingController();
  List<String> dataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(read));

    if (response.statusCode == 200) {
      setState(() {
        dataList = List<String>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> createData() async {
    final response = await http.post(
      Uri.parse(create),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'data': _dataController.text,
      }),
    );

    if (response.statusCode == 201) {
      fetchData(); // Refresh the data after creating
    } else {
      throw Exception('Failed to create data');
    }
  }

  Future<void> updateData(String id) async {
    final response = await http.put(
      Uri.parse('http://192.168.84.144/api/update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        // Your update data goes here
      }),
    );

    if (response.statusCode == 200) {
      fetchData(); // Refresh the data after updating
    } else {
      throw Exception('Failed to update data');
    }
  }

  Future<void> deleteData(String id) async {
    final response = await http.delete(
      Uri.parse('http://192.168.84.144/api/delete/$id'),
    );

    if (response.statusCode == 200) {
      fetchData(); // Refresh the data after deleting
    } else {
      throw Exception('Failed to delete data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Node CRUD'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _dataController,
              decoration: InputDecoration(labelText: 'Data'),
            ),
          ),
          ElevatedButton(
            onPressed: createData,
            child: Text('Create'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(dataList[index]),
                  onTap: () {
                    // Implement update or delete functionality here
                    // Example:
                    // updateData(dataList[index].id);
                    // deleteData(dataList[index].id);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
