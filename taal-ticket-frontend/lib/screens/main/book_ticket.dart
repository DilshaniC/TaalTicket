import 'package:flutter/material.dart';
import 'package:rive_animation/screens/main/payment_page.dart';

import '../../communicators/ticket.dart';
import '../../communicators/venue.dart';

class BookingFormPage extends StatefulWidget {
  final String id;
  final String showName;
  final String description;
  final String image;
  final List<Venue> venues;
  final List<Ticket> tickets;
  final List<String> artists;

  BookingFormPage({
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
  _BookingFormPageState createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  late Venue selectedVenue;
  late Ticket selectedTicket;
  int ticketCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Tickets for ${widget.showName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.image),
            const SizedBox(height: 16.0),
            Text(
              widget.showName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(widget.description),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<Venue>(
              decoration: InputDecoration(labelText: 'Select Venue'),
              items: widget.venues.map((venue) {
                return DropdownMenuItem<Venue>(
                  value: venue,
                  child: Text(venue.location),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedVenue = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<Ticket>(
              decoration: InputDecoration(labelText: 'Select Package'),
              items: widget.tickets.map((ticket) {
                return DropdownMenuItem<Ticket>(
                  value: ticket,
                  child: Text(
                      '${ticket.packageName} - Rs.${ticket.price.toStringAsFixed(2)}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTicket = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Number of Tickets'),
              keyboardType: TextInputType.number,
              initialValue: '1',
              onChanged: (value) {
                setState(() {
                  ticketCount = int.parse(value);
                });
              },
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement booking functionality here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentPage(
                            id: widget.id,
                            showName: widget.showName,
                            selectedVenue: selectedVenue,
                            selectedTicket: selectedTicket,
                            ticketCount: ticketCount, )
                    ),
                  );
                },
                child: const Text('Book Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
