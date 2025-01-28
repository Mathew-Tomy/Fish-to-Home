import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fishtohome/restAPI/API.dart';

class ApiService {
  // Fetch the public key for Stripe
  static Future<String?> fetchPublicKey() async {
    try {
      // Get the customer ID from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? customerId = prefs.getString('customer_id');

      if (customerId == null || customerId.isEmpty) {
        throw Exception('Customer ID is not available.');
      }

      // Construct the API URL
      String url = '${ApiUrl.paymentAccount}/$customerId';

      // Make the GET request
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == true) {
          // Extract the first payment account entry
          final paymentAccount = responseData['payment_account'][0];
          return paymentAccount['public_key']; // Return the Stripe public key
        } else {
          throw Exception(
              "Error fetching Stripe public key: ${responseData['message']}");
        }
      } else {
        throw Exception(
            "Failed to fetch Stripe public key. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in fetchPublicKey: $e");
      return null; // Return null if an error occurs
    }
  }
}
