import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../communicators/ticket.dart';
import '../../communicators/venue.dart';
import '../../communicators/show.dart';
import 'book_ticket.dart';

class ShowDetailsPage extends StatelessWidget {
  final Show show;

  const ShowDetailsPage({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(show.showName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(show.image),
            const SizedBox(height: 16.0),
            Text(
              show.showName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(show.description),
            const SizedBox(height: 16.0),
            const Text(
              "Artists:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ...show.artists.map((artist) => Text(artist)).toList(),
            const SizedBox(height: 16.0),
            const Text(
              "Packages:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ...show.tickets
                .map((ticket) => Text(
                '${ticket.packageName} - Rs.${ticket.price.toStringAsFixed(2)}'))
                .toList(),
            const SizedBox(height: 16.0),
            const Text(
              "Venues:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ...show.venues.map((venue) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Location: ${venue.location}'),
                Text(
                    'Start Time: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(venue.starttime))}'),
                Text(
                    'End Time: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(venue.endtime))}'),
                const SizedBox(height: 8.0),
              ],
            )),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingFormPage(
                        id: show.id,
                        showName: show.showName,
                        description: show.description,
                        image: show.image,
                        venues: show.venues,
                        tickets: show.tickets,
                        artists: show.artists,
                      ),
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
