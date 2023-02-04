/* 
{
   "config":{
      "token":"f146ca9760ce7e79c962f5acff471b19",
      "stream":{
         "link":"",
         "nextStream":""
      }
   }
}
*/

class AppConfig {
  final String token;
  final String link;
  final String nextStream;

  AppConfig(
      {required this.token, required this.link, required this.nextStream});

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    var config = json['config'];
    return AppConfig(
        token: config['token'],
        link: config['stream']['link'],
        nextStream: config['stream']['nextStream']);
  }
}
