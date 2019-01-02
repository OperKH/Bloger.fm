import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/radiostation.dart';
import '../constants/radiostations.dart';
import '../providers/prefs_singleton.dart';

const SELECTED_RADIOSTATION_NAME = 'SELECTED_RADIOSTATION_NAME';

class RadiostationsBloc {
  RadiostationsBloc() {
    loadState();
    // Listeners
    radiostation.listen(_radiostationChangeHandler);
  }

  // Regular variables
  final SharedPreferences prefs = PrefsSingleton.prefs;

  // Reactive variables
  final _radiostation = BehaviorSubject<Radiostation>();
  final _radiostationBitrate = BehaviorSubject<int>();

  // Streams
  Observable<Radiostation> get radiostation => _radiostation.stream;
  Observable<int> get radiostationBitrate => _radiostationBitrate.stream;

  // Sinks
  Function(Radiostation) get _setRadiostation => _radiostation.sink.add;
  Function(int) get _setRadiostationBitrate => _radiostationBitrate.sink.add;

  // Logic Functions
  void selectRadiostationByName(String name) {
    final Radiostation radiostation = radiostations.firstWhere(
      (Radiostation station) => station.name == name,
      orElse: () => radiostations.first,
    );
    _setRadiostation(radiostation);
  }

  void play() {
    final url = _getRadiostationUrl();
  }

  void pause() {}

  // Private Logic Functions
  void _radiostationChangeHandler(Radiostation radiostation) {
    prefs.setString(SELECTED_RADIOSTATION_NAME, radiostation.name);
    _selectRadistationBitrate();
    play();
  }

  void _selectRadistationBitrate() {
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

  void loadState() async {
    final name = prefs.getString(SELECTED_RADIOSTATION_NAME);
    selectRadiostationByName(name);
  }

  void dispose() {
    // cleanup
    _radiostation.close();
    _radiostationBitrate.close();
  }
}
