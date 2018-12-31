import 'package:flutter/material.dart';
import './pages/player.dart';

void main() => runApp(BlogerFmApp());

class BlogerFmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color greyColor = Colors.grey[850];
    return MaterialApp(
      title: 'Bloger.fm',
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
    );
  }
}
