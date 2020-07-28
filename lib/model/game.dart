import 'dart:convert';

import 'package:http/http.dart' as http;

class Game {
  final int gid;
  final int value;
  final String title;
  final String desc;
  final String url;
  final String link;
  final List types;

  Game({this.gid, this.value, this.title, this.desc, this.url, this.link, this.types});

  

  factory Game.fromJson(Map<String, dynamic> json) {
    //print(json['gid'] + ".."+json[0]['gid']);
    return Game(
      gid: int.parse(json['GID']),
      value: int.parse(json['GID']),
      title: json['Name'],
      desc: json['Description'],
      url: json['URL'],
      link: json['Link'],
      types: new List.filled(1, json['Type']),
    );
  }
   Map<String, dynamic> toJson() {
    return {
      'gid': gid,
      'title': title,
      'desc' : desc,
      'url'  : url,
      'types': jsonEncode((types).toList()),
      'link' : link
    };
  }
  @override
  String toString() => '''
gid: $gid
value: $value
title: $title
desc: $desc
url: $url
types: $types
''';
}
