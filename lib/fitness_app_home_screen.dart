import 'dart:convert';

import 'package:OyunAra/model/game.dart';
import 'package:OyunAra/model/popular_filter_list.dart';
import 'package:OyunAra/models/tabIcon_data.dart';
import 'package:OyunAra/training_screen.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'fintness_app_theme.dart';
import 'my_diary_screen.dart';
import 'package:http/http.dart' as http;

class FitnessAppHomeScreen extends StatefulWidget {
      List<PopularFilterListData> online , type , platform;
      RangeValues players;
  FitnessAppHomeScreen(this.online,this.type,this.platform,this.players);
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState(this.online,this.type,this.platform,this.players);
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
      List<PopularFilterListData> online , type , platform;
      RangeValues players;
      List<Game> allGames;
      Future<http.Response> getGames() async {
        //https://oyunara.tk/api/getGames.php?platform=1&online=1&player=5&type=5
        var url = "https://oyunara.tk/api/getGames.php?";
        url+="platform=";
        platform.forEach((element) {
          url+=(element.isSelected)?element.value.toString()+",":'';
        });
        url=(url.endsWith(','))?url.substring(0,url.lastIndexOf(',')):url;
        
        url+="&online=";
        online.forEach((element) {
          url+=(element.isSelected)?'1'+",":'0';
        });
        url=(url.endsWith(','))?url.substring(0,url.lastIndexOf(',')):url;

        url+="&playermin="+players.start.toInt().toString()+"&playermax="+players.end.toInt().toString();
        url=(url.endsWith(','))?url.substring(0,url.lastIndexOf(',')):url;

         url+="&type=";
        type.forEach((element) {
          url+=(element.isSelected)?element.value.toString()+",":'';
        });
        url=(url.endsWith(','))?url.substring(0,url.lastIndexOf(',')):url;
        print(url);
        List<Game> games;
        games = await fetchGames();
        print(games); //BURADA DEVAMMMM YENİ SAYFADA YANİ BURADA LİSTELENECEK. SONRA ONA BASILDIĞINDA TEKLİ SAYFA, ORADAN İNDİRİLİR:
        return http.get(url).then((value) => value);
}
      _FitnessAppHomeScreenState(this.online,this.type,this.platform,this.players){
          print(getGames());
      }
  AnimationController animationController;
Future<List<Game>> fetchGames() async {
  final response = await http.get('https://oyunara.tk/api/getGames.php?platform=0,2,3,1,4,5&online=1&playermin=3&playermax=6&type=1,7');

    List<Game> games = new List<Game>();
  if (response.statusCode == 200) {
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
      print(data);
        for(Map i in data){
          games.add(Game.fromJson(i));
        }
    allGames = games;
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
    tabBody = MyDiaryScreen(animationController: animationController, games: this.allGames,);
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
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

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
                setState(() {
                  tabBody =
                      MyDiaryScreen(animationController: animationController, games: this.allGames);
                });
              });
            } else if (index == 1 || index == 3) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      TrainingScreen(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
