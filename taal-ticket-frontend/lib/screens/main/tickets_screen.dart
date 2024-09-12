import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:rive_animation/user_session.dart';
import 'components/ticket_view.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  List<dynamic> tickets = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  Future<void> _fetchTickets() async {
    try {
      final userId = UserSession().userId;
      if (userId == null) {
        throw Exception('User ID is null');
      }

      final response = await http.get(
        Uri.parse('http://localhost:9090/tickets/viewTicketOf/$userId'),
      );

      if (response.statusCode >= 200 || response.statusCode < 300) {
        final List<dynamic> ticketList = jsonDecode(response.body);

        for (var ticket in ticketList) {
          final showId = ticket['showId'];
          final showResponse = await http.get(
            Uri.parse('http://localhost:9090/shows/viewOne/$showId'),
          );

          if (response.statusCode >= 200 || response.statusCode < 300) {
            final showDetails = jsonDecode(showResponse.body);
            ticket['showDetails'] = showDetails;
          }
        }

        setState(() {
          tickets = ticketList;
        });
      } else {
        throw Exception('Failed to load tickets');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _previousTicket() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      }
    });
  }

  void _nextTicket() {
    setState(() {
      if (currentIndex < tickets.length - 1) {
        currentIndex++;
      }
    });
  }

  Future<void> _cancelTicket(String ticketId) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:9090/tickets/update/$ticketId/cancelled'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode >= 200 || response.statusCode < 300) {
        _showMessage('Ticket cancelled successfully');
      } else {
        _showMessage('Failed to cancel ticket');
      }
    } catch (e) {
      _showMessage('Error: $e');
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
                if (message.contains('successfully')) {
                  _fetchTickets(); // Refresh the tickets after successful cancellation
                }
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Next in Line",
            style: TextStyle(fontFamily: "Poppins", fontSize: 20),
          ),
        ),
        body: tickets.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: _previousTicket,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: DynamicTicketWidget(
                                    ticketBgColor: const Color(0xffcaf0f8),
                                    ticketBorderColor: const Color(0xff00b4d8),
                                    ticketInfoWidget: Column(
                                      children: [
                                        Transform.rotate(
                                          angle: pi / 4,
                                          child: const Icon(
                                            Icons.queue_music_sharp,
                                            size: 45,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Text(
                                          tickets[currentIndex]['showDetails']
                                                  ['name'] ??
                                              'Unknown Show',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w800,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        Text(
                                          tickets[currentIndex]['ticketCount'] >
                                                  0
                                              ? (tickets[currentIndex]
                                                          ['ticketCount'])
                                                      .toString() +
                                                  (tickets[currentIndex]
                                                              ['ticketCount'] >
                                                          1
                                                      ? ' People'
                                                      : ' Person')
                                              : 'Unknown',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4.0,
                                        ),
                                        Text(
                                          tickets[currentIndex]['showDetails']
                                                  ['description'] ??
                                              'No Description',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                            horizontal: 12.0,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color: const Color(0xff0077b6),
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Start Time",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      tickets[currentIndex]
                                                              ['starttime'] ??
                                                          'Unknown',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    const Text(
                                                      "Location",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      tickets[currentIndex]
                                                              ['location'] ??
                                                          'Unknown',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    const Text(
                                                      "Price",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "Rs. ${tickets[currentIndex]['price'] > 0 ? (tickets[currentIndex]['price']).toString() : '0'}" +
                                                          (tickets[currentIndex]
                                                                      ['status'] ==
                                                                  'cancelled'
                                                              ? ' (Refunded)'
                                                              : ''),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                ElevatedButton(
                                  onPressed: tickets[currentIndex]
                                                  ['starttime'] !=
                                              null &&
                                          DateTime.parse(tickets[currentIndex]
                                                  ['starttime'])
                                              .isAfter(DateTime.now()
                                                  .add(Duration(days: 21)))
                                      ? () => _cancelTicket(
                                          tickets[currentIndex]['_id'])
                                      : null,
                                  child: const Text('Cancel Ticket'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: tickets[currentIndex]
                                                    ['starttime'] !=
                                                null &&
                                            DateTime.parse(tickets[currentIndex]
                                                    ['starttime'])
                                                .isAfter(DateTime.now()
                                                    .add(Duration(days: 21)))
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: _nextTicket,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
