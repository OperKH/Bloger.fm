import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';

import '../models/radiostation.dart';
import '../constants/radiostations.dart';
import '../providers/prefs_singleton.dart';

const SELECTED_RADIOSTATION_NAME = 'SELECTED_RADIOSTATION_NAME';

final AudioPlayer _audioPlayer = AudioPlayer();

class RadiostationsBloc {
  RadiostationsBloc() {
    init();
  }

  // Regular variables
  final SharedPreferences _prefs = PrefsSingleton.prefs;
  final Connectivity _connectivity = Connectivity();
  final Dio dio = Dio();

  // Reactive variables
  final _radiostation = BehaviorSubject<Radiostation>();
  final _radiostationBitrate = BehaviorSubject<int>();
  final _radioStatus = BehaviorSubject<RadioStatus>();
  final _radioTitle = BehaviorSubject<String>();

  // Streams
  Observable<Radiostation> get radiostation => _radiostation.stream;
  Observable<int> get radiostationBitrate => _radiostationBitrate.stream;
  Observable<RadioStatus> get radioStatus => _radioStatus.stream;
  Observable<String> get radioTitle => _radioTitle.stream;

  // Sinks
  Function(Radiostation) get _setRadiostation => _radiostation.sink.add;
  Function(int) get _setRadiostationBitrate => _radiostationBitrate.sink.add;
  Function(RadioStatus) get _setRadioStatus => _radioStatus.sink.add;
  Function(String) get _setRadioTitle => _radioTitle.sink.add;

  // Logic Functions
  void selectRadiostationByName(String name) {
    final Radiostation radiostation = radiostations.firstWhere(
      (Radiostation station) => station.name == name,
      orElse: () => radiostations.first,
    );
    // deselect bitrate before dropdown get new bitrates list
    _setRadiostationBitrate(null);
    // select new station
    _setRadiostation(radiostation);
  }

  void selectBitrate(int bitrate) {
    _setRadiostationBitrate(bitrate);
  }

  Future<void> play() async {
    if (_radioStatus.value != RadioStatus.isPlaying) {
      _setRadioStatus(null);
    }
    final String url = _getRadiostationUrl();
    await _audioPlayer.play('$radioServer$url');
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> togglePlay() async {
    _radioStatus.value == RadioStatus.isPlaying ? await stop() : await play();
  }

  // Private Logic Functions
  void _radiostationChangeHandler(Radiostation radiostation) {
    _setRadioTitle('');
    _selectOptimizedRadistationBitrate();
    _prefs.setString(SELECTED_RADIOSTATION_NAME, radiostation.name);
  }

  Future<void> _radiostationBitrateChangeHandler(int bitrate) async {
    await stop();
    await play();
  }

  Future<void> _selectOptimizedRadistationBitrate() async {
    final ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();
    final List<RadioUrl> urls = _radiostation.value.urls;
    final int bitrate = connectivityResult == ConnectivityResult.mobile
        ? _getMinMaxBitrate(urls, true)
        : _getMinMaxBitrate(urls, false);
    _setRadiostationBitrate(bitrate);
  }

  int _getMinMaxBitrate(List<RadioUrl> urls, bool isMin) {
    if (urls.length == 1) return urls[0].bitrate;
    return urls.map((RadioUrl url) => url.bitrate).reduce(isMin ? min : max);
  }

  String _getRadiostationUrl() {
    final Radiostation radiostation = _radiostation.value;
    final int bitrate = _radiostationBitrate.value;
    final String url = radiostation.urls
        .firstWhere((RadioUrl radioUrl) => radioUrl.bitrate == bitrate,
            orElse: () => radiostation.urls[0])
        .url;
    return url;
  }

  Future<void> _onPlayerStateChanged(AudioPlayerState state) async {
    print(state);
    switch (state) {
      case AudioPlayerState.PLAYING:
        _setRadioStatus(RadioStatus.isPreparePlaying);
        break;
      case AudioPlayerState.PAUSED:
        _setRadioStatus(RadioStatus.isPaused);
        break;
      case AudioPlayerState.STOPPED:
        _setRadioStatus(RadioStatus.isStoped);
        _setRadioTitle('');
        break;
      case AudioPlayerState.COMPLETED:
        _setRadioStatus(null);
        await play();
        break;
      default:
        _setRadioStatus(null);
    }
  }

  void _onPositionChanged(Duration position) {
    if (_radioStatus.value == RadioStatus.isPreparePlaying &&
        position.inMicroseconds > 0) {
      _setRadioStatus(RadioStatus.isPlaying);
    }
  }

  Future<void> _updateRadioTitle() async {
    if (_radioStatus.value != RadioStatus.isPlaying &&
        _radioStatus.value != RadioStatus.isPreparePlaying) {
      Future.delayed(Duration(seconds: 1), _updateRadioTitle);
      return;
    }
    final String url = _getRadiostationUrl();
    Response response;
    try {
      response = await dio.get('$radioServer/json.xsl');
      if (response == null || response.data == null) {
        Future.delayed(Duration(seconds: 1), _updateRadioTitle);
      }
    } catch (e) {
      Future.delayed(Duration(seconds: 1), _updateRadioTitle);
    }
    final String json = parseJSONP(response.data);
    final serverStatus = await compute(jsonDecode, json);
    final radiostationStatus = serverStatus[url];
    final String title =
        radiostationStatus == null ? '' : radiostationStatus['title'];
    final String currentUrl = _getRadiostationUrl();
    if (url == currentUrl &&
        title != _radioTitle.value &&
        (_radioStatus.value == RadioStatus.isPlaying ||
            _radioStatus.value == RadioStatus.isPreparePlaying)) {
      _setRadioTitle(title);
      print(title);
    }
    Future.delayed(Duration(seconds: 6), _updateRadioTitle);
  }

  String parseJSONP(String jsonp) {
    return jsonp.substring(jsonp.indexOf('(') + 1, jsonp.lastIndexOf(')'));
  }

  void init() {
    final String name = _prefs.getString(SELECTED_RADIOSTATION_NAME);
    selectRadiostationByName(name);
    _updateRadioTitle();
    // Listeners
    radiostation.listen(_radiostationChangeHandler);
    radiostationBitrate.listen(_radiostationBitrateChangeHandler);
    _audioPlayer.audioPlayerStateChangeHandler = _onPlayerStateChanged;
    _audioPlayer.positionHandler = _onPositionChanged;
  }

  Future<void> dispose() async {
    // cleanup
    await Future.wait([
      _audioPlayer.release(),
      _radiostation.close(),
      _radiostationBitrate.close(),
      _radioStatus.close(),
      _radioTitle.close(),
    ]);
  }
}
