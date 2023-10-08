/* 
APP config received from server.
{
  "config": {
    "token": "f146ca9760ce7e79c962f5acff471b19",
    "needUpdate": false,
    "stream": {
      "link": "https://tv.adonaichurch.in/hls/stream.m3u8",
      "link-old": "https://hls.media.adonaichurch.in/hls/test.m3u8",
      "nextStream": "10/08/2023 08:30:00 AM"
    },
    "version": {
      "minimum": 13,
      "maximum": 13
    }
  }
}
*/

import 'package:adonai_tv/constants.dart' as CONSTANTS;

class AppConfig {
  final String token;
  final String link;
  final String nextStream;
  final num minVersion;
  final num maxVersion;

  AppConfig(
      {required this.token,
      required this.link,
      required this.nextStream,
      required this.minVersion,
      required this.maxVersion});

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    var config = json['config'];
    var minVer = CONSTANTS.appVersion;
    var maxVer = CONSTANTS.appVersion;
    if (config.containsKey("version")) {
      minVer = config['version']['minimum'];
      maxVer = config['version']['maximum'];
    }
    return AppConfig(
        token: config['token'],
        link: config['stream']['link'],
        nextStream: config['stream']['nextStream'],
        minVersion: minVer,
        maxVersion: maxVer);
  }
}
