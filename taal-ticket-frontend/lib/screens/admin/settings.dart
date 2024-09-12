
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({required Key key, required this.title}) : super(key: key);
  final String title;
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsList(
        sections: [
          SettingsSection(
            // titlePadding: EdgeInsets.all(20),
            title: const Text('Genaral'),
            tiles: [
              SettingsTile(
                title: const Text('Language'),
                // subtitle: 'English',
                leading: const Icon(Icons.language),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                title: const Text('Use System Theme'),
                leading: const Icon(Icons.phone_android),
                initialValue: null,
                // switchValue: isSwitched,
                onToggle: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
            ],
          ),
          SettingsSection(
            // titlePadding: EdgeInsets.all(20),
            title: const Text('Security'),
            tiles: [
              SettingsTile(
                title: const Text('Security'),
                // subtitle: 'Fingerprint',
                leading: const Icon(Icons.lock),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                title: const Text('Use fingerprint'),
                leading: const Icon(Icons.fingerprint),
                // switchValue: true,
                onToggle: (value) {},
                initialValue: null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}