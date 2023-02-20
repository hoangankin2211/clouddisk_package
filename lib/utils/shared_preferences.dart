import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static SharedPreferences? sharedPreferences;
  static Future initSharedPreferencesInstance() async {
    sharedPreferences ??= await SharedPreferences.getInstance();
  }
}
