import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddNewEventPage extends StatefulWidget {
  const AddNewEventPage({super.key});

  @override
  _AddNewEventPageState createState() => _AddNewEventPageState();
}

class _AddNewEventPageState extends State<AddNewEventPage> {
  final _formKey = GlobalKey<FormState>();

  // Initial data
  String _name = '';
  String _description = '';
  List<Map<String, String>> _venues = [];
  List<String> _artists = [];
  List<Map<String, dynamic>> _tickets = [];
  String? _base64Image;
  final ImagePicker _picker = ImagePicker();

  // Text editing controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
  }

  void _addVenue() {
    setState(() {
      _venues.add({
        "location": "",
        "starttime": DateTime.now().toIso8601String(),
        "endtime": DateTime.now().toIso8601String(),
      });
    });
  }

  void _addArtist() {
    setState(() {
      _artists.add("");
    });
  }

  void _addTicket() {
    setState(() {
      _tickets.add({
        "packageName": "",
        "price": 0,
      });
    });
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      // Process the data
      setState(() {
        _name = _nameController.text;
        _description = _descriptionController.text;
      });

      // Prepare the data to be sent
      final Map<String, dynamic> eventData = {
        "name": _name,
        "description": _description,
        "venues": _venues,
        "artists": _artists,
        "tickets": _tickets,
        "image": _base64Image,
      };

      // Send the data to the backend
      String host = dotenv.get('HOST', fallback: 'localhost');
      String port = dotenv.get('PORT', fallback: '9090');
      final url = Uri.parse('http://$host:$port/shows/addNew');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(eventData),
      );

      if (response.statusCode >= 200 || response.statusCode  < 300) {
        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Event created successfully'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

        // Reset the form fields
        _nameController.clear();
        _descriptionController.clear();
        setState(() {
          _venues.clear();
          _artists.clear();
          _tickets.clear();
          _base64Image = null;
        });
      } else {
        // Show failure dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Failure'),
              content: Text('Failed to create event'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Event Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              // Event Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Event Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              // Venues
              Text('Venues', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ..._venues.map((venue) {
                int index = _venues.indexOf(venue);
                return Column(
                  children: [
                    TextFormField(
                      initialValue: venue['location'],
                      decoration: InputDecoration(labelText: 'Location'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter location';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        venue['location'] = value;
                      },
                    ),
                    TextFormField(
                      initialValue: DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.parse(venue['starttime']!)),
                      decoration: InputDecoration(labelText: 'Start Time'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter start time';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        venue['starttime'] = value;
                      },
                    ),
                    TextFormField(
                      initialValue: DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.parse(venue['endtime']!)),
                      decoration: InputDecoration(labelText: 'End Time'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter end time';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        venue['endtime'] = value;
                      },
                    ),
                    SizedBox(height: 16.0),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _venues.removeAt(index);
                        });
                      },
                    ),
                  ],
                );
              }).toList(),
              ElevatedButton(
                onPressed: _addVenue,
                child: Text('Add Venue'),
              ),
              SizedBox(height: 16.0),
              // Artists
              Text('Artists', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ..._artists.map((artist) {
                int index = _artists.indexOf(artist);
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: artist,
                        decoration: InputDecoration(labelText: 'Artist'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter artist name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _artists[index] = value;
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _artists.removeAt(index);
                        });
                      },
                    ),
                  ],
                );
              }).toList(),
              ElevatedButton(
                onPressed: _addArtist,
                child: Text('Add Artist'),
              ),
              SizedBox(height: 16.0),
              // Tickets
              Text('Tickets', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ..._tickets.map((ticket) {
                int index = _tickets.indexOf(ticket);
                return Column(
                  children: [
                    TextFormField(
                      initialValue: ticket['packageName'],
                      decoration: InputDecoration(labelText: 'Package Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter package name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        ticket['packageName'] = value;
                      },
                    ),
                    TextFormField(
                      initialValue: ticket['price'].toString(),
                      decoration: InputDecoration(labelText: 'Price'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        ticket['price'] = int.parse(value);
                      },
                    ),
                    SizedBox(height: 16.0),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _tickets.removeAt(index);
                        });
                      },
                    ),
                  ],
                );
              }).toList(),
              ElevatedButton(
                onPressed: _addTicket,
                child: Text('Add Ticket'),
              ),
              SizedBox(height: 16.0),
              // Image Picker
              Text('Event Image', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              _base64Image != null
                  ? kIsWeb
                  ? Image.network('data:image/jpeg;base64,$_base64Image')
                  : Image.memory(base64Decode(_base64Image!))
                  : Text('No image selected.'),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Upload Image'),
              ),
              SizedBox(height: 16.0),
              // Save Button
              ElevatedButton(
                onPressed: _saveEvent,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
