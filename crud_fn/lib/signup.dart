// main.dart

import 'dart:convert';

import 'package:crud_fn/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpForm(),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List<String> userList = [];

  void _signUp() async {
    final String username = _usernameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final response = await http.post(
      Uri.parse(signup),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'email': email,
        'password': password
      }),
      // body: {'username': username, 'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      print('Signup successful');
      _fetchUsers(); // Fetch updated user list after signing up
    } else {
      print('Signup failed: ${response.reasonPhrase}');
    }
  }

  void _fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(users));

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody != null && responseBody is List) {
          setState(() {
            // userList = responseBody;
            userList =
                List<String>.from(responseBody.map((item) => item.toString()));
          });
        } else {
          print('Invalid response format: $responseBody');
        }
      } else {
        print('Failed to fetch users: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error fetching users: $error');
    }
  }
  // bool isLoading = false;

  // Future<void> _fetchUsers() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     final response = await http.get(Uri.parse(users));

  //     if (response.statusCode == 200) {
  //       final dynamic responseBody = json.decode(response.body);

  //       if (responseBody != null && responseBody is List<dynamic>) {
  //         setState(() {
  //           userList = responseBody.cast<String>().toList();
  //           isLoading = false;
  //         });
  //       } else {
  //         print('Invalid response format: $responseBody');
  //         // Show error to user
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text('Invalid response format'),
  //         ));
  //       }
  //     } else {
  //       print('Failed to fetch users: ${response.reasonPhrase}');
  //       // Show error to user
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Failed to fetch users: ${response.reasonPhrase}'),
  //       ));
  //     }
  //   } catch (error) {
  //     print('Error fetching users: $error');
  //     // Show error to user
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Error fetching users: $error'),
  //     ));
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _signUp,
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  if (userList.isNotEmpty) {
                    return ListTile(
                      title: Text(userList[index].toString()),
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
