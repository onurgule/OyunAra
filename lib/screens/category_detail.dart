import 'package:flutter/material.dart';

class CategoryDetail extends StatefulWidget {
  int tid;
  String categoryName;
  CategoryDetail({Key key, @required this.tid, @required this.categoryName})
      : super(key: key);

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("" + this.widget.categoryName),
    );
  }
}
