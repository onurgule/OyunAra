import 'package:OyunAra/home_design_course.dart';
import 'package:OyunAra/fitness_app_home_screen.dart';
import 'package:OyunAra/hotel_home_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';

class HomeList {
  HomeList({
    this.title,
    this.navigateScreen,
    this.imagePath = '',
    this.url,
  });
  String title;
  Widget navigateScreen;
  String imagePath;
  String url;


  List<HomeList> homeList(){
    List<HomeList> liked;
    final LocalStorage storage = new LocalStorage('oyunara');
   var items = storage.getItem('likes');
      if (items != null) {
        liked = List<HomeList>.from(
          (items as List).map(
            (item) => HomeList(
              navigateScreen: HotelHomeScreen(),
              title: item['title'],
              imagePath: item['image'],
              url: item['url'],
            ),
          ),
        );
      }
    return liked;
  }
}
