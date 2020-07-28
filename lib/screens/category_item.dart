import 'dart:convert';

import 'package:OyunAra/model/category_select.dart';
import 'package:OyunAra/services/url_generate.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryDetail extends StatefulWidget {
  int tid;
  String categoryName;
  CategoryDetail({Key key, @required this.tid, @required this.categoryName})
      : super(key: key);

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  List<CategorySelectModel> categories = new List<CategorySelectModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.categoryName),
      ),
      body: PageView.builder(
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            categories[index].uRL,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Future<String> fetchGames() async {
    var response =
        await http.get(UrlGenerate().getCategoryItems(this.widget.tid));
    if (response.statusCode == 200) {
      print("200 döndü");

      this.setState(() {
        final data = jsonDecode(response.body);
        print(data.toString());
        for (Map i in data) {
          categories.add(CategorySelectModel.fromJson(i));
        }
      });
      return "succes";
    } else {
      throw Exception('kategori Bulunamadı.');
    }
  }

  @override
  Future<void> initState() {
    this.fetchGames();
  }
}
