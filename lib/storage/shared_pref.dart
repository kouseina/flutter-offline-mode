import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late SharedPreferences _sharedPrefs;

  factory SharedPref() => _instance;

  static final SharedPref _instance = SharedPref._internal();

  SharedPref._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  void clear() {
    _sharedPrefs.clear();
  }

  String? get token {
    return _sharedPrefs.getString(_keyToken);
  }

  set token(String? value) {
    if (value == null) return;
    _sharedPrefs.setString(_keyToken, value);
  }
}

const String _keyToken = "token";
