import 'package:flutter/material.dart';
import 'package:rive_animation/screens/main/notifications.dart';
import 'package:rive_animation/screens/main/settings.dart';
import 'package:rive_animation/screens/main/shows_list.dart';
import 'package:rive_animation/screens/main/tickets_screen.dart';
import 'package:rive_animation/screens/onboding/onboding_screen.dart';
import 'package:rive_animation/user_session.dart';

void main() => runApp(const MainScreen());

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainScreenApp(),
    );
  }
}

class MainScreenApp extends StatefulWidget {
  const MainScreenApp({super.key});

  @override
  State<MainScreenApp> createState() => _MainScreenAppState();
}

class _MainScreenAppState extends State<MainScreenApp> {
  int _selectedIndex = 0;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = UserSession().userId;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      const ListCardsScreen(),
      const TicketScreen(),
      const NotificationsPage(),
      SettingsScreen(key: const Key("settings"), title: "Settings", userId: userId ?? ''),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            _onItemTapped(0);
          },
          icon: const Icon(
            Icons.home,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Taal Ticket',
          style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w100,
              fontFamily: 'Poppins',
              color: Colors.white),
        ),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            onPressed: () {
              UserSession().clearSession();

              // Navigate to the login screen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => OnboardingScreen()),
                    (Route<dynamic> route) =>
                false, // Remove all routes from the stack
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Shows',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'My Tickets',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Settings',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
