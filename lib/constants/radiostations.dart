import '../models/radiostation.dart';

const List<Radiostation> radiostations = const [
  Radiostation(
    name: 'Studio',
    urls: const [
      RadioUrl(64, 'http://radio.bloger.fm:8002/blogerfm-64'),
      RadioUrl(128, 'http://radio.bloger.fm:8002/blogerfm-128'),
      RadioUrl(256, 'http://radio.bloger.fm:8002/blogerfm-256'),
    ],
  ),
  Radiostation(
    name: 'Classic',
    urls: const [RadioUrl(192, 'http://radio.bloger.fm:8002/classic-bfm')],
    background: 'assets/images/bg-classic.jpg',
    backgroundOpacity: 0.4,
  ),
  Radiostation(
    name: 'Drive',
    urls: const [RadioUrl(320, 'http://radio.bloger.fm:8002/drive-bfm')],
    background: 'assets/images/bg-drive.jpg',
    backgroundOpacity: 0.4,
  ),
  Radiostation(
    name: 'Jazz',
    urls: const [RadioUrl(192, 'http://radio.bloger.fm:8002/jazz-bfm')],
    background: 'assets/images/bg-jazz.jpg',
    backgroundOpacity: 0.7,
  ),
  Radiostation(
    name: 'Rock',
    urls: const [RadioUrl(192, 'http://radio.bloger.fm:8002/rock-bfm')],
    background: 'assets/images/bg-rock.jpg',
  ),
  Radiostation(
    name: 'Street',
    urls: const [RadioUrl(192, 'http://radio.bloger.fm:8002/street-bfm')],
    background: 'assets/images/bg-street.jpg',
    backgroundOpacity: 0.5,
  ),
];
