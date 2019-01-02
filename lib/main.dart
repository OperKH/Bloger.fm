import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/radiostations_provider.dart';
import 'providers/prefs_singleton.dart';
import './pages/player.dart';

void main() async {
  PrefsSingleton.prefs = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(BlogerFmApp());
}

class BlogerFmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color greyColor = Colors.grey[850];
    return RadiostationsProvider(
      child: MaterialApp(
        title: 'Bloger.FM',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color(0xFF00B0F0),
          accentColor: Color(0xFFFCF103),
          primaryTextTheme: TextTheme(
            title: TextStyle(color: greyColor),
          ),
          primaryIconTheme: IconThemeData(
            color: greyColor,
          ),
        ),
        home: PlayerPage(),
      ),
    );
  }
}
