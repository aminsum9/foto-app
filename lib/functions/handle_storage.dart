import 'package:shared_preferences/shared_preferences.dart';

Future<bool> saveDataStorage(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setString(key, value);
}

Future<String> getDataStorage(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key).toString();
}

Future<String> deleteAllStorage() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
  return '';
}
