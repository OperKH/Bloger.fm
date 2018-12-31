import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerPage extends StatelessWidget {
  Widget _buildDrawer() {
    return Drawer();
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
      drawer: _buildDrawer(),
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
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.twitterSquare,
                    color: Color(0xFF1DA1F2),
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.googlePlusSquare,
                    color: Color(0xFFDB4437),
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.soundcloud,
                    color: Color(0xFFFF5500),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
