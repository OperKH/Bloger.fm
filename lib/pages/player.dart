import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
            title: Text('Radiostations'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(
              Icons.radio,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            title: Text('Radio Name'),
            selected: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      image: AssetImage('assets/images/bg.jpg'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blogger.fm'),
      ),
      drawer: _buildDrawer(context),
      body: Container(
        decoration: BoxDecoration(image: _buildBackgroundImage()),
        width: double.infinity,
        child: Column(
          children: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  width: 64.0,
                  image: AssetImage('assets/images/logo.png'),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: IconButton(
                  iconSize: 128.0,
                  icon: Icon(
                    FontAwesomeIcons.playCircle,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
            ButtonBar(
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
            ),
          ],
        ),
      ),
    );
  }
}
