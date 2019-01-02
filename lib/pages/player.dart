import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/radiostation.dart';
import '../constants/radiostations.dart';
import '../providers/radiostations_provider.dart';
import '../widgets/platform/platform_progress_indicator.dart';

const String facebookUrl = 'https://facebook.com/bloger.fm';
const String twitterUrl = 'https://twitter.com/BlogerFm';
const String gPlusUrl = 'https://plus.google.com/+BlogerFM';
const String soundCloudUrl = 'https://soundcloud.com/blogerfm';

class PlayerPage extends StatelessWidget {
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Bloger.FM radio'),
            automaticallyImplyLeading: false,
          ),
          _buildRadiostationsList(context),
        ],
      ),
    );
  }

  Widget _buildRadiostationsList(BuildContext context) {
    final radiostationsBloc = RadiostationsProvider.of(context);
    return StreamBuilder<Radiostation>(
      stream: radiostationsBloc.radiostation,
      builder: (BuildContext context, AsyncSnapshot<Radiostation> snapshot) {
        final Radiostation selectedRadiostation = snapshot.data;
        return Column(
            children: radiostations.map((Radiostation radiostation) {
          return ListTile(
            leading: Icon(Icons.radio),
            title: Text(radiostation.name),
            selected: radiostation.name == selectedRadiostation?.name,
            onTap: () {
              if (radiostation.name != selectedRadiostation.name) {
                radiostationsBloc.selectRadiostationByName(radiostation.name);
              }
              Navigator.of(context).pop();
            },
          );
        }).toList());
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final radiostationsBloc = RadiostationsProvider.of(context);
    return AppBar(
        title: StreamBuilder<Radiostation>(
      stream: radiostationsBloc.radiostation,
      builder: (BuildContext context, AsyncSnapshot<Radiostation> snapshot) {
        final Radiostation radiostation = snapshot.data;
        return radiostation == null
            ? Text('Bloger.FM')
            : Text('Bloger.FM - ${radiostation.name}');
      },
    ));
  }

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      image: AssetImage('assets/images/bg.jpg'),
    );
  }

  Widget _buildBitratesRow(BuildContext context) {
    final radiostationsBloc = RadiostationsProvider.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
      child: StreamBuilder<Radiostation>(
        stream: radiostationsBloc.radiostation,
        builder: (BuildContext context, AsyncSnapshot<Radiostation> snapshot) {
          final Radiostation radiostation = snapshot.data;
          return StreamBuilder<int>(
            stream: radiostationsBloc.radiostationBitrate,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              final int selectedBitrate = snapshot.data;
              return radiostation == null || selectedBitrate == null
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Bitrate:  '),
                        DropdownButton(
                            value: selectedBitrate,
                            onChanged: (int bitrate) {
                              if (selectedBitrate == bitrate) return;
                              radiostationsBloc.selectBitrate(bitrate);
                            },
                            items: radiostation.urls.map((RadioUrl radioUrl) {
                              return DropdownMenuItem(
                                value: radioUrl.bitrate,
                                child: Text(
                                  radioUrl.bitrate.toString(),
                                ),
                              );
                            }).toList())
                      ],
                    );
            },
          );
        },
      ),
    );
  }

  Widget _buildPlayBtn(BuildContext context) {
    final radiostationsBloc = RadiostationsProvider.of(context);

    return StreamBuilder<RadioStatus>(
      stream: radiostationsBloc.radioStatus,
      builder: (BuildContext context, AsyncSnapshot<RadioStatus> snapshot) {
        final RadioStatus radioStatus = snapshot.data;
        return radioStatus == null
            ? PlatformProgressIndicator(size: 112.0, strokeWidth: 12.0)
            : IconButton(
                iconSize: 128.0,
                icon: Icon(
                  radioStatus == RadioStatus.isPlaying
                      ? FontAwesomeIcons.pauseCircle
                      : FontAwesomeIcons.playCircle,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  radiostationsBloc.togglePlay();
                },
              );
      },
    );
  }

  Widget _buildSocialButtons(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(
            FontAwesomeIcons.facebookSquare,
            color: Color(0xFF365899),
          ),
          onPressed: () async {
            try {
              await launch(facebookUrl);
            } catch (e) {
              print(e);
            }
          },
        ),
        IconButton(
          icon: Icon(
            FontAwesomeIcons.twitterSquare,
            color: Color(0xFF1DA1F2),
          ),
          onPressed: () async {
            try {
              await launch(twitterUrl);
            } catch (e) {
              print(e);
            }
          },
        ),
        IconButton(
          icon: Icon(
            FontAwesomeIcons.googlePlusSquare,
            color: Color(0xFFDB4437),
          ),
          onPressed: () async {
            try {
              await launch(gPlusUrl);
            } catch (e) {
              print(e);
            }
          },
        ),
        IconButton(
          icon: Icon(
            FontAwesomeIcons.soundcloud,
            color: Color(0xFFFF5500),
          ),
          onPressed: () async {
            try {
              await launch(soundCloudUrl);
            } catch (e) {
              print(e);
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: Container(
        decoration: BoxDecoration(image: _buildBackgroundImage()),
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Image(
                width: 64.0,
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
            _buildBitratesRow(context),
            Expanded(
              child: Center(child: _buildPlayBtn(context)),
            ),
            _buildSocialButtons(context),
          ],
        ),
      ),
    );
  }
}
