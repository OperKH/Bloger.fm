import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/radiostation.dart';
import '../models/info_link.dart';
import '../constants/radiostations.dart';
import '../providers/radiostations_provider.dart';

const String facebookUrl = 'https://facebook.com/bloger.fm';
const String facebookAndroid = 'fb://page/885939701490818?referrer=app_link';
const String facebookIOS = 'fb://page/?id=885939701490818';
const String twitterUrl = 'https://twitter.com/BlogerFm';
const String twitterIOS = 'twitter://user?screen_name=BlogerFm';
const String gPlusUrl = 'https://plus.google.com/+BlogerFM';
const String gPlusIOS = 'gplus://plus.google.com/+BlogerFM';
const String soundCloudUrl = 'https://soundcloud.com/blogerfm';
const String soundCloudIntent = 'soundcloud://users:182622974';

const List<InfoLink> infoLinks = const [
  InfoLink('Про нас', 'http://bloger.fm/o-nas.html', Icons.person),
  InfoLink('Програми', 'http://bloger.fm/programmy.html', Icons.schedule),
  InfoLink('(067) 21-21-000', 'tel://+380672121000', Icons.phone),
  InfoLink(
      'info@bloger.fm', 'mailto:info@bloger.fm', FontAwesomeIcons.envelope),
  InfoLink('bloger.fm', 'skype:bloger.fm?chat', FontAwesomeIcons.skype),
  InfoLink(
      '04213 Київ, вул. Прирічна, 27-е',
      'https://google.com/maps/@50.5239043,30.5191951,17z/data=!4m5!3m4!1s0x40d4d230eb53e497:0x82c45390281964f1!8m2!3d50.5239043!4d30.5213838',
      Icons.location_on),
];

class PlayerPage extends StatelessWidget {
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text('Bloger.FM radio'),
              automaticallyImplyLeading: false,
            ),
            _buildRadiostationsList(context),
            SizedBox(height: 16.0),
            _buildInfoLinks(context),
          ],
        ),
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

  Widget _buildInfoLinks(BuildContext context) {
    return Column(
      children: infoLinks.map((InfoLink infoLink) {
        return ListTile(
          dense: true,
          leading: Icon(infoLink.icon),
          title: Text(infoLink.text),
          onTap: () async {
            try {
              await launch(infoLink.url);
            } catch (e) {}
            Navigator.of(context).pop();
          },
        );
      }).toList(),
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
            ? Padding(
                padding: EdgeInsets.all(16.0),
                child: _buildProgressIndicator(context, 112.0, 12.0))
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

  Widget _buildProgressIndicator(
      BuildContext context, double size, double strokeWidth) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _buildStopBtn(BuildContext context) {
    final radiostationsBloc = RadiostationsProvider.of(context);
    return IconButton(
      iconSize: 48.0,
      icon: Icon(
        FontAwesomeIcons.stopCircle,
        color: Theme.of(context).primaryColor,
      ),
      onPressed: () {
        radiostationsBloc.stop();
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
            final intentLink = Theme.of(context).platform == TargetPlatform.iOS
                ? facebookIOS
                : facebookAndroid;
            try {
              await launch(intentLink);
              return;
            } catch (e) {}
            try {
              await launch(facebookUrl);
            } catch (e) {}
          },
        ),
        IconButton(
          icon: Icon(
            FontAwesomeIcons.twitterSquare,
            color: Color(0xFF1DA1F2),
          ),
          onPressed: () async {
            if (Theme.of(context).platform == TargetPlatform.iOS) {
              try {
                await launch(twitterIOS);
                return;
              } catch (e) {}
            }
            try {
              await launch(twitterUrl);
            } catch (e) {}
          },
        ),
        IconButton(
          icon: Icon(
            FontAwesomeIcons.googlePlusSquare,
            color: Color(0xFFDB4437),
          ),
          onPressed: () async {
            if (Theme.of(context).platform == TargetPlatform.iOS) {
              try {
                await launch(gPlusIOS);
                return;
              } catch (e) {}
            }
            try {
              await launch(gPlusUrl);
            } catch (e) {}
          },
        ),
        IconButton(
          alignment: Alignment.centerLeft,
          icon: Icon(
            FontAwesomeIcons.soundcloud,
            color: Color(0xFFFF5500),
          ),
          onPressed: () async {
            try {
              await launch(soundCloudIntent);
              return;
            } catch (e) {}
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildStopBtn(context),
                    SizedBox(height: 8.0),
                    _buildPlayBtn(context),
                  ],
                ),
              ),
            ),
            _buildSocialButtons(context),
          ],
        ),
      ),
    );
  }
}
