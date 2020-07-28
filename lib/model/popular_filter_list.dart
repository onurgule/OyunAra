import 'dart:convert';


class PopularFilterListData {
  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
    this.value = 0,
    this.opt
  }){
    switch(this.opt){
      case "p":
      break;
      case "pr":
      break;
      case "t":
      break;
    }
  }
  String titleTxt;
  bool isSelected;
  int value;
  String opt;


  static List<PopularFilterListData> popularFList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: 'Aksiyon',
      isSelected: false,
      value: 1
    ),
    PopularFilterListData(
      titleTxt: 'Macera',
      isSelected: false,
      value: 2
    ),
    PopularFilterListData(
      titleTxt: 'Spor',
      isSelected: false,
      value: 3
    ),
    PopularFilterListData(
      titleTxt: 'Yarış',
      isSelected: false,
      value: 4
    ),
    PopularFilterListData(
      titleTxt: 'FPS',
      isSelected: false,
      value: 5
    ),
    PopularFilterListData(
      titleTxt: 'Strateji',
      isSelected: false,
      value: 6
    ),
    PopularFilterListData(
      titleTxt: 'MOBA',
      isSelected: true,
      value: 7
    ),
    PopularFilterListData(
      titleTxt: 'RPG',
      isSelected: false,
      value: 8
    ),
    PopularFilterListData(
      titleTxt: 'MMO',
      isSelected: false,
      value: 9
    ),
    PopularFilterListData(
      titleTxt: 'Dövüş',
      isSelected: false,
      value: 10
    ),
    PopularFilterListData(
      titleTxt: 'Korku',
      isSelected: false,
      value: 11
    ),
    PopularFilterListData(
      titleTxt: 'Simülasyon',
      isSelected: false,
      value: 12
    ),
  ];

  static List<PopularFilterListData> accomodationList = [
    PopularFilterListData(
      titleTxt: 'Hepsi',
      isSelected: false,
      value: 0
    ),
    PopularFilterListData(
      titleTxt: 'Android',
      isSelected: true,
      value: 2
    ),
    PopularFilterListData(
      titleTxt: 'iOS',
      isSelected: false,
      value: 3
    ),
    PopularFilterListData(
      titleTxt: 'PC',
      isSelected: false,
      value: 1
    ),
    PopularFilterListData(
      titleTxt: 'XBOX',
      isSelected: false,
      value: 4
    ),
    PopularFilterListData(
      titleTxt: 'Playstation',
      isSelected: false,
      value: 5
    ),
  ];
  static List<PopularFilterListData> online = [
    PopularFilterListData(
      titleTxt: 'Online',
      isSelected: false,
    ),
  ];
}
