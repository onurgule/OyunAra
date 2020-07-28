import 'package:OyunAra/model/game.dart';
import 'package:OyunAra/theme/app_theme.dart';
import 'package:OyunAra/bottom_navigation/bottom_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/homelist.dart';
import 'package:OyunAra/models/tabIcon_data.dart';
import '../models/tabIcon_data.dart';
import 'filters_screen.dart';
import 'package:OyunAra/model/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:OyunAra/services/url_generate.dart';
import 'dart:convert';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  List<CategoryModel> categories = new List<CategoryModel>();
  List<Game> games = new List<Game>();
  List<Color> colorList = [
    Colors.yellow,
    Colors.pink,
    Colors.red,
    Colors.orange,
    Colors.lime,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.teal,
    Colors.cyan,
    Colors.indigo,
    Colors.purple,
    Colors.blueGrey,
    Colors.brown,
    Colors.black
  ];
  HomeList hl = new HomeList();
  List<HomeList> homeList = new List<HomeList>();
  AnimationController animationController;
  bool multiple = true;

  // MyDiaryScreen tabBody;

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    this.fetchGames();

    fetchAllGames();
    super.initState();
  }

  Future<String> fetchGames() async {
    var response = await http.get(UrlGenerate().getAllCategories());
    if (response.statusCode == 200) {
      print("200 döndü");

      this.setState(() {
        final data = jsonDecode(response.body);
        print(data.toString());
        for (Map i in data) {
          categories.add(CategoryModel.fromJson(i));
        }
      });

      print(categories[0].name);
      return "categories";
    } else {
      throw Exception('Kategori Bulunamadı.');
    }
  }
   Future<String> fetchAllGames() async {
    var response = await http.get(UrlGenerate().getAllGames());
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

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    homeList = hl.homeList();
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  appBar(),
                  buildExpanded(),
                  bottomBar(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
  
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Expanded buildExpanded() {

    final Animation<double> animation =
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval((1 / (games.length+1)), 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                );
    return Expanded(
      child: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return (homeList != null)
                ? GridView(
                    padding: const EdgeInsets.only(top: 0, left: 12, right: 12),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: List<Widget>.generate(
                      homeList.length,
                      (int index) {
                        final int count = homeList.length;
                        final Animation<double> animation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animationController,
                            curve: Interval((1 / count) * index, 1.0,
                                curve: Curves.fastOutSlowIn),
                          ),
                        );
                        animationController.forward();
                        return HomeListView(
                          animation: animation,
                          animationController: animationController,
                          listData: homeList[index],
                          callBack: () {
                            Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    homeList[index].navigateScreen,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: multiple ? 2 : 1,
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 12.0,
                      childAspectRatio: 1.5,
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.50,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 20.0,
                                top: 20,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Tüm Kategoriler',
                                  style: GoogleFonts.lato(
                                    textStyle:
                                        Theme.of(context).textTheme.display1,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            )),
                        Expanded(
                          flex: 4,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 15,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                    colorRandom(),
                                    colorRandom()
                                  ])),
                                  width:
                                      MediaQuery.of(context).size.width * 0.60,
                                  alignment: Alignment.center,
                                  child: Text(
                                    categories[index].name.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 20.0,
                                top: 20,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'En Çok Oynananlar',
                                  style: GoogleFonts.lato(
                                    textStyle:
                                        Theme.of(context).textTheme.display1,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 9,
                            child: ListView.builder(

                            scrollDirection: Axis.horizontal,
                            itemCount: games.length,
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 15,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: RaisedButton(
                                  onPressed: () =>   _launchURL(games[index].link),
                                  child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(games[index].url),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.60,
                                  alignment: Alignment.center,
                                  child: Text(
                                    games[index].title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                                )
                                  
                              );
                            },
                          ),
                          )
                      ],
                    ),
                    alignment: Alignment.center,
                  );
          }
        },
      ),
    );
  }

  Widget appBar() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Oyun Bul',
                  style: GoogleFonts.alegreya(
                    textStyle: TextStyle(
                      color: Colors.blue[900],
                      letterSpacing: .5,
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
              color: Colors.white,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(AppBar().preferredSize.height),
                  child: Icon(
                    multiple ? Icons.dashboard : Icons.view_agenda,
                    color: AppTheme.dark_grey,
                  ),
                  onTap: () {
                    setState(() {
                      multiple = !multiple;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomBar() {
    return BottomBarView(
      tabIconsList: tabIconsList,
      addClick: () {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FiltersScreen()),
        );
      },
      changeIndex: (int index) {
        if (index == 0 || index == 2) {
          animationController.reverse().then<dynamic>((data) {
            if (!mounted) {
              return;
            }
            // setState(() {
            //   tabBody =
            //       MyDiaryScreen(animationController: animationController,);
            // });
          });
        } else if (index == 1 || index == 3) {
          animationController.reverse().then<dynamic>((data) {
            if (!mounted) {
              return;
            }
            // setState(() {
            //   tabBody =
            //       TrainingScreen(animationController: animationController) as MyDiaryScreen;
            // });
          });
        }
      },
    );
  }

  Color colorRandom() {
    Random random = new Random();
    return colorList[random.nextInt(colorList.length)];
  }
}

class HomeListView extends StatelessWidget {
  const HomeListView(
      {Key key,
      this.listData,
      this.callBack,
      this.animationController,
      this.animation})
      : super(key: key);

  final HomeList listData;
  final VoidCallback callBack;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Image.asset(
                      listData.imagePath,
                      fit: BoxFit.cover,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.grey.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        onTap: () {
                          callBack();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
