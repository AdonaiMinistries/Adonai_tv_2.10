class Paging {
  String next;
  String previous;
  String first;
  String last;

  Paging(
      {required this.next,
      required this.previous,
      required this.first,
      required this.last});

  factory Paging.fromJson(Map<String, dynamic> json) {
    return Paging(
      next: json['next'],
      previous: json['previous'],
      first: json['first'],
      last: json['last'],
    );
  }
}

class Size {
  int width;
  int height;
  String link;
  String linkWithPlayButton;

  Size(
      {required this.width,
      required this.height,
      required this.link,
      required this.linkWithPlayButton});

  factory Size.fromJson(Map<String, dynamic> json) {
    return Size(
      width: json['width'],
      height: json['height'],
      link: json['link'],
      linkWithPlayButton: json['link_with_play_button'],
    );
  }
}

class Pictures {
  String uri;
  bool active;
  String type;
  String baseLink;
  List<Size> sizes;
  String resourceKey;
  bool defaultPicture;

  Pictures({
    required this.uri,
    required this.active,
    required this.type,
    required this.baseLink,
    required this.sizes,
    required this.resourceKey,
    required this.defaultPicture,
  });

  factory Pictures.fromJson(Map<String, dynamic> json) {
    var list = json['sizes'] as List;
    List<Size> sizesList = list.map((i) => Size.fromJson(i)).toList();
    return Pictures(
      uri: json['uri'],
      active: json['active'],
      type: json['type'],
      baseLink: json['base_link'],
      sizes: sizesList,
      resourceKey: json['resource_key'],
      defaultPicture: json['default_picture'],
    );
  }
}

class Data {
  String uri;
  String name;
  Pictures pictures;

  Data({required this.uri, required this.name, required this.pictures});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      uri: json['uri'],
      name: json['name'],
      pictures: Pictures.fromJson(json['pictures']),
    );
  }
}

class VimeoVideoData {
  Paging paging;
  List<Data> data;

  VimeoVideoData({required this.paging, required this.data});

  factory VimeoVideoData.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Data> dataList = list.map((i) => Data.fromJson(i)).toList();
    return VimeoVideoData(
      paging: Paging.fromJson(json['paging']),
      data: dataList,
    );
  }
}

class VideoConfigData {
  String uri;

  VideoConfigData({required this.uri});

  factory VideoConfigData.fromJson(Map<String, dynamic> json) {
    return VideoConfigData(
        uri: json['request']['files']['hls']['cdns']['akfire_interconnect_quic']
            ['avc_url']);
  }
}
