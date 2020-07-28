import 'package:OyunAra/model/popular_filter_list.dart';
import 'package:flutter/material.dart';

class UrlGenerate {
  String getGames(
      List<PopularFilterListData> online,
      List<PopularFilterListData> type,
      List<PopularFilterListData> platform,
      RangeValues players) {
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
    return url;
  }
  String getAllGames() {
    //https://oyunara.tk/api/getGames.php?platform=1&online=1&player=5&type=5
    var url = "https://oyunara.tk/api/getAllGames.php";
    return url;
  }

  String getAllCategories() {
    return "https://oyunara.tk/api/getOptions.php?opt=t";
  }
}
