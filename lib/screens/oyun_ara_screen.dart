import 'dart:convert';

import 'package:OyunAra/model/game.dart';
import 'package:OyunAra/model/popular_filter_list.dart';
import 'package:OyunAra/models/tabIcon_data.dart';

import 'package:flutter/material.dart';
import '../model/game.dart';
import '../theme/app_theme_oyun_ara.dart';
// import 'my_diary_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:OyunAra/services/url_generate.dart';

class FitnessAppHomeScreen extends StatefulWidget {
  List<PopularFilterListData> online, type, platform;
  RangeValues players;
  FitnessAppHomeScreen(this.online, this.type, this.platform, this.players);
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState(
      this.online, this.type, this.platform, this.players);
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
  List<PopularFilterListData> online, type, platform;
  RangeValues players;
  List<Game> games = new List<Game>();
  List<Widget> cardList;

  _FitnessAppHomeScreenState(
      this.online, this.type, this.platform, this.players) {}
  AnimationController animationController;

  Future<String> fetchGames() async {
    var response =
        await http.get(UrlGenerate().getGames(online, type, platform, players));
    if (response.statusCode == 200) {
      print("200 döndü");

      this.setState(() {
        final data = jsonDecode(response.body);
        print(data.toString());
        for (Map i in data) {
          games.add(Game.fromJson(i));
        }
      });

      print(games[0].title);
      return "games";
    } else {
      throw Exception('Oyun Bulunamadı.');
    }
  }

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: FintnessAppTheme.background,
  );

  @override
  void initState() {
    this.fetchGames();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sonuçlar'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
                      child: AspectRatio(
              aspectRatio: 0.7,
              child: Stack(
                alignment: Alignment.center,
                children: _getMatchCard(games),
              ),
            ),
          ),
          Expanded(
            flex: 1,
                      child: AspectRatio(
              aspectRatio: 2.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 100,
                  ),
                  Icon(
                    Icons.file_download,
                    color: Colors.black,
                    size: 100,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

/*
  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0 || index == 2) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                // setState(() {
                //   tabBody = MyDiaryScreen(
                //       animationController: animationController,
                //       games: this.allGames);
                // });
              });
            } else if (index == 1 || index == 3) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                // setState(() {
                //   tabBody =
                //       TrainingScreen(animationController: animationController);
                // });
              });
            }
          },
        ),
      ],
    );
  }
*/
  List<Widget> _getMatchCard(List<Game> data) {
    List<Game> cards = new List();
    print(data.length);
    cards = data;
    List<Widget> cardList = new List();
    for (int x = 0; x < data.length; x++) {
      cardList.add(Positioned(
          top: 30,
          child: Draggable(
            axis: Axis.horizontal,
            onDragEnd: (drag) {
              if (drag.offset.direction > 1) {
                print("left");

                saveData(cards[x].title);
              } else {
                print("right" + x.toString());

                _launchURL(cards[x].url);
              }
              _removeCard(x);
            },
            childWhenDragging: Container(),
            feedback: Cards(context: context, cards: cards, x: x),
            child: Cards(context: context, cards: cards, x: x),
          )));
    }
    return cardList;
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _removeCard(int index) {
    setState(() {
      games.removeAt(index);
    });
  }

  Future<bool> saveData(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString("title", name);
  }

  Future<String> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("name").isEmpty ? "hata" : prefs.getString("name");
  }
}

class Cards extends StatelessWidget {
  const Cards({
    Key key,
    @required this.context,
    @required this.cards,
    @required this.x,
  }) : super(key: key);

  final BuildContext context;
  final List<Game> cards;
  final int x;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        height: MediaQuery.of(context).size.width * 1,
        child: Expanded(
          child: Column(
            children: <Widget>[
              Spacer(),
              Image.network(
                cards[x].url,
                width: 280,
                height: 400,
                fit: BoxFit.fill,
              ),
              Spacer(),
              Text(
                cards[x].title,
                style: TextStyle(fontSize: 30),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
