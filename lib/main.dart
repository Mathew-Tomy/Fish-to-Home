import 'dart:io';
import 'package:fishtohome/screens/dashboard_screen.dart';
import 'package:fishtohome/screens/list/cart_list_screen.dart';
import 'package:fishtohome/screens/list/orders_list_screen.dart';
import 'package:fishtohome/screens/list/wishlist_products_screen.dart';
import 'package:fishtohome/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fishtohome/services/api_service.dart';
import 'package:fishtohome/.env.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  try {
    // Fetch the Stripe public key dynamically
    String? publicKey = await ApiService.fetchPublicKey();
    if (publicKey != null) {
      print("Stripe Public Key: $publicKey");
      Stripe.publishableKey = publicKey;
    } else {
      print("Failed to fetch the public key. Using a fallback key.");
      Stripe.publishableKey = stripePublishableKey; // Replace with your fallback key if needed
    }
  } catch (e) {
    print("Error initializing the app: $e");
  }

  // Check if the user is logged in
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Run the app with the appropriate starting screen
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FishToHome',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Load the dashboard directly so users can browse products
      home: Dashboard(),
      routes: {
        "/loginscreen": (context) => Loginscreen(),
        "/dashboard": (context) => Dashboard(),
        '/cart': (context) => Cart(),
        '/wishlist': (context) => Wishlist(),
        '/order': (context) => Ordrslist(),
      },
    );
  }
}
