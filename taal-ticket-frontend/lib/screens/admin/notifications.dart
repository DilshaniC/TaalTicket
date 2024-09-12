import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<dynamic> _cancelledTickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCancelledTickets();
  }

  Future<void> _fetchCancelledTickets() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:9090/tickets/viewCancelled'),
      );

      if (response.statusCode == 200) {
        final tickets = jsonDecode(response.body);

        for (var ticket in tickets) {
          final showResponse = await http.get(
            Uri.parse(
                'http://localhost:9090/shows/viewOne/${ticket['showId']}'),
          );

          final userResponse = await http.get(
            Uri.parse('http://localhost:9090/viewUser/${ticket['userId']}'),
          );

          if (showResponse.statusCode >= 200 &&
              showResponse.statusCode < 300 &&
              userResponse.statusCode >= 200 &&
              userResponse.statusCode < 300) {
            ticket['show'] = jsonDecode(showResponse.body);
            ticket['user'] = jsonDecode(userResponse.body);
          } else {
            throw Exception('Failed to load show or user data');
          }
        }

        setState(() {
          _cancelledTickets = tickets;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load cancelled tickets');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancelled Tickets'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cancelledTickets.isEmpty
              ? const Center(child: Text('No cancelled tickets found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: _cancelledTickets.length,
                  itemBuilder: (context, index) {
                    final ticket = _cancelledTickets[index];
                    final showName = ticket['show'] != null
                        ? ticket['show']['name']
                        : 'Unknown Show';
                    final userName = ticket['user'] != null
                        ? '${ticket['user']['firstname']} ${ticket['user']['lastname']}'
                        : 'Unknown User';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Show: $showName',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 5.0),
                            Text('User: $userName'),
                            const SizedBox(height: 5.0),
                            Text('Price: Rs. ${ticket['price']}'),
                            const SizedBox(height: 5.0),
                            Text('Start Time: ${ticket['starttime']}'),
                            const SizedBox(height: 5.0),
                            Text('End Time: ${ticket['endtime']}'),
                            const SizedBox(height: 5.0),
                            Text('Status: ${ticket['status']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
