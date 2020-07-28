import 'package:shared_preferences/shared_preferences.dart';

class LikedHelper {
  Future<String> getJson(String _key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _json = prefs.getString('$_key') ?? "start";
    return _json;
  }

  setJson(String _key, String _json) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('$_key', _json);
  }

  getAllData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    final prefsMap = Map<String, dynamic>();
    for (String key in keys) {
      prefsMap[key] = prefs.get(key);
    }
  }
}
