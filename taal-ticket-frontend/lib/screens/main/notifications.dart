import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked_notification_cards/stacked_notification_cards.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationsPage> {
  final List<NotificationCard> _listOfNotification = [
    NotificationCard(
      date: DateTime.now(),
      leading: const Icon(
        Icons.library_music,
        size: 48,
      ),
      title: 'Nadagama',
      subtitle: 'Only 3 more days remaining for the magical musical experience.',
    ),
    NotificationCard(
      date: DateTime.now().subtract(
        const Duration(minutes: 4),
      ),
      leading: const Icon(
        Icons.music_note,
        size: 48,
      ),
      title: 'Kuweni - The Musical',
      subtitle: 'Your payment has received. See your tickets in the My Tickets section.',
    ),
    NotificationCard(
      date: DateTime.now().subtract(
        const Duration(minutes: 10),
      ),
      leading: const Icon(
        Icons.account_circle,
        size: 48,
      ),
      title: 'Taal Ticket',
      subtitle: 'You account is now verified. You can vew your account status in settings.',
    ),
    NotificationCard(
      date: DateTime.now().subtract(
        const Duration(minutes: 30),
      ),
      leading: const Icon(
        Icons.library_music,
        size: 48,
      ),
      title: 'Nadagama',
      subtitle: 'You have successfully reserved your ticket. Download bill from My Tickets section.',
    ),
    NotificationCard(
      date: DateTime.now().subtract(
        const Duration(minutes: 44),
      ),
      leading: const Icon(
        Icons.library_music,
        size: 48,
      ),
      title: 'Nadagama',
      subtitle: 'Be the first to reserve the premium package. Get your tickets now!',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            StackedNotificationCards(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 2.0,
                )
              ],
              notificationCardTitle: 'Message',
              notificationCards: [..._listOfNotification],
              cardColor: const Color(0xFFF1F1F1),
              padding: 16,
              actionTitle: const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              showLessAction: const Icon(Icons.expand_less),
              clearAllNotificationsAction: const Icon(Icons.delete_forever),
              clearAllStacked: const Text('Clear All'),
              cardClearButton: const Text('clear'),
              cardViewButton: const Text('view'),
              onTapClearAll: () {
                setState(() {
                  _listOfNotification.clear();
                });
              },
              onTapClearCallback: (index) {
                if (kDebugMode) {
                  print(index);
                }
                setState(() {
                  _listOfNotification.removeAt(index);
                });
              },
              onTapViewCallback: (index) {
                if (kDebugMode) {
                  print(index);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
