import 'package:fishtohome/modals/User_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Userpreferences {
  static const String _tokenKey = 'token';

  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_tokenKey, token);
    print('Token saved successfully'); // Add for verification
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveUser(Address address) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firstname', address.first_name!);
    prefs.setString('lastname', address.last_name!);
    prefs.setString('customer_id', address.customer_id!); // Assuming user.id is of type int
    print('User data saved successfully'); // Add for verification
  }
}


