import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayer/audioplayer.dart';

import '../models/radiostation.dart';
import '../constants/radiostations.dart';
import '../providers/prefs_singleton.dart';

const SELECTED_RADIOSTATION_NAME = 'SELECTED_RADIOSTATION_NAME';

class RadiostationsBloc {
  RadiostationsBloc() {
    loadState();
    // Listeners
    radiostation.listen(_radiostationChangeHandler);
    radiostationBitrate.listen(_radiostationBitrateChangeHandler);
    _audioPlayerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen(_onPlayerStateChanged);
  }

  // Regular variables
  final SharedPreferences _prefs = PrefsSingleton.prefs;
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription<AudioPlayerState> _audioPlayerStateSubscription;

  // Reactive variables
  final _radiostation = BehaviorSubject<Radiostation>();
  final _radiostationBitrate = BehaviorSubject<int>();
  final _radioStatus = BehaviorSubject<RadioStatus>();

  // Streams
  Observable<Radiostation> get radiostation => _radiostation.stream;
  Observable<int> get radiostationBitrate => _radiostationBitrate.stream;
  Observable<RadioStatus> get radioStatus => _radioStatus.stream;

  // Sinks
  Function(Radiostation) get _setRadiostation => _radiostation.sink.add;
  Function(int) get _setRadiostationBitrate => _radiostationBitrate.sink.add;
  Function(RadioStatus) get _setRadioStatus => _radioStatus.sink.add;

  // Logic Functions
  void selectRadiostationByName(String name) {
    final Radiostation radiostation = radiostations.firstWhere(
      (Radiostation station) => station.name == name,
      orElse: () => radiostations.first,
    );
    _setRadiostation(radiostation);
  }

  void selectBitrate(int bitrate) {
    _setRadiostationBitrate(bitrate);
  }

  Future<void> play() async {
    if (_radioStatus.value != RadioStatus.isPlaying) {
      _setRadioStatus(null);
    }
    final url = _getRadiostationUrl();
    await _audioPlayer.play(url);
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> togglePlay() async {
    _radioStatus.value == RadioStatus.isPlaying ? await pause() : await play();
  }

  // Private Logic Functions
  void _radiostationChangeHandler(Radiostation radiostation) {
    _prefs.setString(SELECTED_RADIOSTATION_NAME, radiostation.name);
    _selectOptimizedRadistationBitrate();
  }

  Future<void> _radiostationBitrateChangeHandler(int bitrate) async {
    await stop();
    await play();
  }

  void _selectOptimizedRadistationBitrate() {
    _setRadiostationBitrate(_radiostation.value.urls[0].bitrate);
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
        _setRadioStatus(RadioStatus.isPlaying);
        break;
      case AudioPlayerState.PAUSED:
        _setRadioStatus(RadioStatus.isPaused);
        break;
      case AudioPlayerState.STOPPED:
        _setRadioStatus(RadioStatus.isStoped);
        break;
      case AudioPlayerState.COMPLETED:
        _setRadioStatus(null);
        await play();
        break;
      default:
        _setRadioStatus(null);
    }
  }

  void loadState() async {
    final name = _prefs.getString(SELECTED_RADIOSTATION_NAME);
    selectRadiostationByName(name);
  }

  void dispose() {
    // cleanup
    _radiostation.close();
    _radiostationBitrate.close();
    _radioStatus.close();
    _audioPlayerStateSubscription.cancel();
  }
}
