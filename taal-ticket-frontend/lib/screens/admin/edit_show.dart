import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:rive_animation/communicators/ticket.dart';
import 'package:rive_animation/communicators/venue.dart';
import 'dart:convert';

import 'package:rive_animation/screens/admin/admin_screen.dart';

class EditShowPage extends StatefulWidget {
  final String id;
  final String showName;
  final String description;
  final String image;
  final List<Venue> venues;
  final List<Ticket> tickets;
  final List<String> artists;

  EditShowPage({
    super.key,
    required this.id,
    required this.showName,
    required this.description,
    required this.image,
    required this.venues,
    required this.tickets,
    required this.artists,
  });

  @override
  _EditShowPageState createState() => _EditShowPageState();
}

class _EditShowPageState extends State<EditShowPage> {
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.showName;
    _descriptionController.text = widget.description;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateShow() async {
    if (_formKey.currentState!.validate()) {
      // Process the data
      setState(() {
        _nameController.text = _nameController.text;
        _descriptionController.text = _descriptionController.text;
      });

      List<Map<String, String>> venues = widget.venues.map((venue) {
        return {
          "location": venue.location,
          "starttime": venue.starttime,
          "endtime": venue.endtime,
        };
      }).toList();

      List<Map<String, dynamic>> tickets = widget.tickets.map((ticket) {
        return {
          "packageName": ticket.packageName,
          "price": ticket.price,
        };
      }).toList();

      final updatedData = {
        "name": _nameController.text,
        "description": _descriptionController.text,
        "image": widget.image,
        "venues": venues,
        "tickets": tickets,
        "artists": widget.artists,
      };

      String host = dotenv.get('HOST', fallback: 'localhost');
      String port = dotenv.get('PORT', fallback: '9090');
      final url = Uri.parse('http://$host:$port/shows/update/${widget.id}');
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        // Show success dialog and navigate back
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Show updated successfully'),
              actions: [
                TextButton(
                  onPressed: () { // Close the dialog
                    Navigator.pop(context, true); // Navigate back
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to update show'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false); // Close the dialog
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
    List<Map<String, String>> _venues = widget.venues.map((venue) {
      return {
        "location": venue.location,
        "starttime": venue.starttime,
        "endtime": venue.endtime,
      };
    }).toList();

    List<Map<String, dynamic>> _tickets = widget.tickets.map((ticket) {
      return {
        "packageName": ticket.packageName,
        "price": ticket.price,
      };
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
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
                  ],
                );
              }).toList(),
              // Artists
              Text('Artists', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ...widget.artists.map((artist) {
                return TextFormField(
                  initialValue: artist,
                  decoration: InputDecoration(labelText: 'Artist'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter artist name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    int index = widget.artists.indexOf(artist);
                    widget.artists[index] = value;
                  },
                );
              }).toList(),
              SizedBox(height: 16.0),
              // Tickets
              Text('Tickets', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ..._tickets.map((ticket) {
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
                  ],
                );
              }).toList(),
              // Save Button
              ElevatedButton(
                onPressed: _updateShow,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
