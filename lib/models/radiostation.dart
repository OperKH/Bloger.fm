import 'package:flutter/material.dart';

class Radiostation {
  final String name;
  final List<RadioUrl> urls;
  final String background;
  final double backgroundOpacity;

  const Radiostation({
    @required this.name,
    @required this.urls,
    this.background = 'assets/images/bg.jpg',
    this.backgroundOpacity = 1.0,
  });
}

class RadioUrl {
  final int bitrate;
  final String url;

  const RadioUrl(this.bitrate, this.url);
}

enum RadioStatus { isPreparePlaying, isPlaying, isPaused, isStoped }
