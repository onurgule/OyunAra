import 'dart:convert';

import 'package:http/http.dart' as http;

class Game {
  final int gid;
  final int value;
  final String title;
  final String desc;
  final String url;
  final List types;

  Game({this.gid, this.value, this.title, this.desc, this.url, this.types});

  

  factory Game.fromJson(Map<String, dynamic> json) {
    //print(json['gid'] + ".."+json[0]['gid']);
    return Game(
      gid: int.parse(json['GID']),
      value: int.parse(json['GID']),
      title: json['Name'],
      desc: json['Description'],
      url: json['URL'],
      types: new List.filled(1, json['types']),
    );
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
