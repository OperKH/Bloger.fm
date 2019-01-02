import 'package:flutter/material.dart';
import '../blocs/radiostations.dart';

class RadiostationsProvider extends InheritedWidget {
  RadiostationsProvider({Key key, Widget child})
      : super(key: key, child: child);

  final RadiostationsBloc radiostationsBloc = RadiostationsBloc();

  @override
  bool updateShouldNotify(RadiostationsProvider oldWidget) =>
      (oldWidget.radiostationsBloc != radiostationsBloc);

  static RadiostationsBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(RadiostationsProvider)
            as RadiostationsProvider)
        .radiostationsBloc;
  }
}
