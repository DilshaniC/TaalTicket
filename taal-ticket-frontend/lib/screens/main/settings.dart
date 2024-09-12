import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class UpdateUserDto {
  final String firstname;
  final String lastname;
  final String email;
  final DateTime birthdate;

  UpdateUserDto({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.birthdate,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'birthdate': birthdate.toIso8601String(),
    };
  }
}

class User {
  final String firstname;
  final String lastname;
  final String email;
  final DateTime birthdate;

  User({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.birthdate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      birthdate: DateTime.parse(json['birthdate']),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final String title;
  final String userId;

  const SettingsScreen({required Key key, required this.title, required this.userId}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late TextEditingController _emailController;
  late TextEditingController _birthdateController;

  bool _isLoading = true;
  bool _isSaving = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
    _emailController = TextEditingController();
    _birthdateController = TextEditingController();
    _fetchUserData();
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:9090/viewUser/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        final user = User.fromJson(jsonDecode(response.body));
        setState(() {
          _user = user;
          _isLoading = false;
          _firstnameController.text = user.firstname;
          _lastnameController.text = user.lastname;
          _emailController.text = user.email;
          _birthdateController.text = DateFormat('yyyy-MM-dd').format(user.birthdate);
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUserData() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final updatedUser = UpdateUserDto(
        firstname: _firstnameController.text,
        lastname: _lastnameController.text,
        email: _emailController.text,
        birthdate: DateTime.parse(_birthdateController.text),
      );

      final response = await http.put(
        Uri.parse('http://localhost:9090/update/${widget.userId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedUser.toJson()),
      );

      if (response.statusCode == 200) {
        _showMessage('Profile updated successfully');
      } else {
        throw Exception('Failed to update user data');
      }
    } catch (e) {
      print('Error: $e');
      _showMessage('Error updating profile');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Info'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _firstnameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastnameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _birthdateController,
              decoration: InputDecoration(labelText: 'Birthdate (YYYY-MM-DD)'),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 20),
            _isSaving
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _saveUserData,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
