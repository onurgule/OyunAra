import 'dart:convert';

import 'package:OyunAra/model/game.dart';
import 'package:OyunAra/model/popular_filter_list.dart';
import 'package:OyunAra/models/tabIcon_data.dart';

import 'package:flutter/material.dart';
import 'bottom_navigation/bottom_bar_view.dart';
import 'theme/app_theme_oyun_ara.dart';
// import 'my_diary_screen.dart';
import 'package:http/http.dart' as http;

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
  List<Game> allGames;
  List<Widget> cardList;
  String getGames() {
    //https://oyunara.tk/api/getGames.php?platform=1&online=1&player=5&type=5
    var url = "https://oyunara.tk/api/getGames.php?";
    url += "platform=";
    platform.forEach((element) {
      url += (element.isSelected) ? element.value.toString() + "," : '';
    });
    url = (url.endsWith(',')) ? url.substring(0, url.lastIndexOf(',')) : url;

    url += "&online=";
    online.forEach((element) {
      url += (element.isSelected) ? '1' + "," : '0';
    });
    url = (url.endsWith(',')) ? url.substring(0, url.lastIndexOf(',')) : url;

    url += "&playermin=" +
        players.start.toInt().toString() +
        "&playermax=" +
        players.end.toInt().toString();
    url = (url.endsWith(',')) ? url.substring(0, url.lastIndexOf(',')) : url;

    url += "&type=";
    type.forEach((element) {
      url += (element.isSelected) ? element.value.toString() + "," : '';
    });
    url = (url.endsWith(',')) ? url.substring(0, url.lastIndexOf(',')) : url;
    print("url geldi");
    return url;
  }

  _FitnessAppHomeScreenState(
      this.online, this.type, this.platform, this.players) {
    fetchGames();
  }
  AnimationController animationController;
  Future<List<Game>> fetchGames() async {
    final response = await http.get(getGames());
    List<Game> games = new List<Game>();
    if (response.statusCode == 200) {
      print("200 döndü");

      // If the server did return a 200 OK response,
      // then parse the JSON.
      /*
     Map<String,dynamic> arr = json.decode(response.body);
     print(json.decode(response.body)[0]);
     print(json.decode(response.body)[1]);
     Game gm;
     int gid, value=0;
     String title, desc, url, types;
       arr.forEach((key, value) {
       switch (key) {
         case 'GID':
          print(value);
           gid = int.parse(value);
           break;
         case 'Name':
           title = value;
           break;
         case 'Description':
           desc = value;
           print(desc);
           break;
         case 'Type':
           types = value;
           print(value);
           gm = new Game(gid: gid, title: title);
           print(value);
           games.add(gm);
       }
       print(games.toString());
     });*/

      final data = jsonDecode(response.body);
      print(data.toString());

      for (Map i in data) {
        games.add(Game.fromJson(i));
      }
      return games;
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
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    // tabBody = MyDiaryScreen(
    //   animationController: animationController,
    //   games: this.allGames,
    // );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FintnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder(
            future: fetchGames(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  List<Game> data = snapshot.data;
                  if (allGames == null) {
                    allGames = data;
                  }
                  return Stack(
                    children: _getMatchCard(allGames),
                  );
                case ConnectionState.waiting:
                  return Text('bekliyor');
              }
            }),
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
              _removeCard(x);
              if (drag.offset.direction > 1) {
                print("left");
              } else {
                print("right");
              }
            },
            childWhenDragging: Container(),
            feedback: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: 280,
                height: 350,
                child: Expanded(
                  child: Column(
                    children: <Widget>[
                      Image.network(
                        cards[x].url,
                        width: 280,
                        height: 300,
                      ),
                      Text(cards[x].title)
                    ],
                  ),
                ),
              ),
            ),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: 280,
                height: 350,
                child: Column(
                  children: <Widget>[
                    Image.network(
                      cards[x].url,
                      width: 280,
                      height: 300,
                    ),
                    Text(cards[x].title)
                  ],
                ),
              ),
            ),
          )));
    }
    return cardList;
  }

  void _removeCard(int index) {
    setState(() {
      allGames.removeAt(index);
    });
  }
}
