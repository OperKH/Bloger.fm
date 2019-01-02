import 'package:flutter/material.dart';

class Radiostation {
  final String name;
  final List<RadioUrl> urls;

  const Radiostation({
    @required this.name,
    @required this.urls,
  });
}

class RadioUrl {
  final int bitrate;
  final String url;

  const RadioUrl(this.bitrate, this.url);
}
