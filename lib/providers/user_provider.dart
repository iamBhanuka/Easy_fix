import 'package:shared_preferences/shared_preferences.dart';

class UserProvider {
  static const PHONE_NUMBER = "phone_number";

  static void savePhoneNumber(String phoneNubmer) {
    SharedPreferences.getInstance().then((pref) {
      pref.setString(PHONE_NUMBER, phoneNubmer);
    });
  }

  static void saveDetails() {}

  static void saveType() {}

  static Future<bool> deleteNumber() {
    return SharedPreferences.getInstance().then((pref) {
      return pref.remove(PHONE_NUMBER);
    });
  }

  static Future<String> getPhoneNumber() {
    return SharedPreferences.getInstance().then((pref) {
      return pref.getString(PHONE_NUMBER);
    });
  }
}
