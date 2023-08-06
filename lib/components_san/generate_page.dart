import 'package:flutter/material.dart';

class Settings {
  final String title;
  final String subtitle;
  final IconData icon;
  dynamic value;

  Settings({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
  });
}

class GeneratorPage extends StatefulWidget {
  @override
  _GeneratorPageState createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  List<Settings> _settingsList = [
    Settings(
      title: 'Dark Mode',
      subtitle: 'Enable dark mode',
      icon: Icons.dark_mode,
      value: false,
    ),
    Settings(
      title: 'Notifications',
      subtitle: 'Receive notifications',
      icon: Icons.notifications,
      value: true,
    ),
    Settings(
      title: 'Task Reminders',
      subtitle: 'Enable reminders for tasks',
      icon: Icons.alarm,
      value: true,
    ),
    Settings(
      title: 'Offline Mode',
      subtitle: 'Use the app in offline mode',
      icon: Icons.offline_bolt,
      value: false,
    ),
    Settings(
      title: 'Email Notifications',
      subtitle: 'Receive task updates via email',
      icon: Icons.email,
      value: false,
    ),
    Settings(
      title: 'Vibrate on Notification',
      subtitle: 'Vibrate device on new notifications',
      icon: Icons.vibration,
      value: true,
    ),
    Settings(
      title: 'Show Completed Tasks',
      subtitle: 'Display completed tasks in the list',
      icon: Icons.check_circle,
      value: true,
    ),
    // Add more settings here...
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView.builder(
        itemCount: _settingsList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(_settingsList[index].icon),
            title: Text(_settingsList[index].title),
            subtitle: Text(_settingsList[index].subtitle),
            trailing: _buildSettingWidget(index),
          );
        },
      ),
    );
  }

  Widget _buildSettingWidget(int index) {
    final setting = _settingsList[index];
    if (setting.value is bool) {
      return Switch(
        value: setting.value as bool,
        onChanged: (newValue) {
          setState(() {
            setting.value = newValue;
          });
        },
      );
    } else if (setting.value is int) {
      return Expanded(
        child: Slider(
          value: setting.value.toDouble(),
          min: 10,
          max: 30,
          divisions: 20,
          onChanged: (newValue) {
            setState(() {
              setting.value = newValue.toInt();
            });
          },
        ),
      );
    } else if (setting.value is String) {
      return Expanded(
        child: DropdownButton<String>(
          value: setting.value as String,
          onChanged: (newValue) {
            setState(() {
              setting.value = newValue;
            });
          },
          items: <String>['en', 'es', 'fr', 'de'] // Language codes
              .map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
        ),
      );
    } else {
      return Text('Unsupported setting type');
    }
  }
}
