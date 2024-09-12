import 'package:flutter/material.dart';
import 'package:rive_animation/screens/admin/add_new_show.dart';
import 'package:rive_animation/screens/admin/admin_shows_list.dart';
import 'package:rive_animation/screens/admin/notifications.dart';
import 'package:rive_animation/screens/admin/settings.dart';
import 'package:rive_animation/screens/main/shows_list.dart';
import 'package:rive_animation/screens/main/tickets_screen.dart';
import 'package:rive_animation/screens/onboding/onboding_screen.dart';
import 'package:rive_animation/user_session.dart';

/// Flutter code sample for [BottomNavigationBar].

void main() => runApp(const AdminScreen());

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AdminScreenApp(),
    );
  }
}

class AdminScreenApp extends StatefulWidget {
  const AdminScreenApp({super.key});

  @override
  State<AdminScreenApp> createState() => _MainScreenAppState();
}

class _MainScreenAppState extends State<AdminScreenApp> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    AdminListCardsScreen(),
    AddNewEventPage(),
    NotificationsPage(),
    SettingsScreen(key: Key("settings"), title: "Settings"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            _onItemTapped(0);
          },
          icon: const Icon(Icons.home, color: Colors.white,),
        ),
        title: const Text(
          'Taal Ticket - Admin',
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
            icon: const Icon(Icons.more_vert, color: Colors.white,),
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
            icon: Icon(Icons.add),
            label: 'Add show',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Refunds',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
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
