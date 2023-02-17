import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static SharedPreferences? sharedPreferences;
  static void initSharedPreferencesInstance() async {
    sharedPreferences ??= await SharedPreferences.getInstance();
  }
}
