import 'package:OyunAra/screens/home_screen.dart';
import 'package:OyunAra/screens/main2.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:localstorage/localstorage.dart';

//import 'package:intro_slider_example/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IntroScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class IntroScreen extends StatefulWidget {
  IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "Oyun Bul",
        description:
            "Arkadaşlarınla veya yalnız oynayabileceğin oyunları bulabilirsin.",
        pathImage: "images/valorant.png",
        backgroundColor: Color(0xfff5a623),
      ),
    );
    slides.add(
      new Slide(
        title: "Tam Senlik",
        description:
            "Oyunları isteğine göre filtreleyip tam senlik oyunları bulabilirsin.",
        pathImage: "images/archero.png",
        backgroundColor: Color(0xff203152),
      ),
    );
    slides.add(
      new Slide(
        title: "Kaç Kişisiniz?",
        description:
            "Tam 5 kişi oyun oynarken bir arkadaşınızın işi çıkıp 4 kişiye düştüğünüzde oyunsuz kalmayın!",
        pathImage: "images/lol.png",
        backgroundColor: Color(0xff9932CC),
      ),
    );
  }

  void onDonePress() {
    final LocalStorage storage = new LocalStorage('oyunara_first');
    storage.setItem('launched', '1');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyAppHome()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LocalStorage storage = new LocalStorage('oyunara_first');
    var elem = Column();
    storage.ready
        .then((_) => elem = actionFor(storage.getItem('launched'), context));
    return actionFor(storage.getItem('launched'), context);
  }

  actionFor(var launched, BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      nameNextBtn: 'İLERİ',
      namePrevBtn: 'GERİ',
      nameDoneBtn: 'TAMAM',
      nameSkipBtn: 'GEÇ',
    );
  }
}
