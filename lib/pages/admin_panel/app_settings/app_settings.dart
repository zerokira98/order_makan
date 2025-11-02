import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  var capitalizeFuture = SharedPreferences.getInstance().then(
    (value) => value.getBool('capitalize'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Settings'),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: capitalizeFuture,
              builder: (context, asyncSnapshot) {
                return SwitchListTile(
                  value: asyncSnapshot.data ?? false,
                  onChanged: (value) {
                    SharedPreferences.getInstance().then(
                      (value) async {
                        await value.setBool(
                            'capitalize', !(asyncSnapshot.data ?? false));
                        setState(() {
                          capitalizeFuture =
                              SharedPreferences.getInstance().then(
                            (value) => value.getBool('capitalize'),
                          );
                        });
                      },
                    );
                  },
                  title: Text('Use Capitalize Title Menu'),
                );
              })
          // Chip(label: '',),
        ],
      ),
    );
  }
}
