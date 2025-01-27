import 'dart:io';
import 'package:glitzy/screens/dashboard_screen.dart';
import 'package:glitzy/screens/list/cart_list_screen.dart';
import 'package:glitzy/screens/list/orders_list_screen.dart';
import 'package:glitzy/screens/list/wishlist_products_screen.dart';
import 'package:glitzy/screens/login_screen.dart';
import 'package:glitzy/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:glitzy/.env.dart';

Future<void> main() async {
  HttpOverrides.global = new MyHttpOverrides();
  Stripe.publishableKey = stripePublishableKey;

  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FishToHome',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Splashscreen(),
      routes: {
        "/loginscreen":(context) => Loginscreen(),
        "/dashboard":(context) => Dashboard(),
        '/cart': (context) => Cart(),
        '/wishlist': (context) => Wishlist(),
        '/order': (context) => Ordrslist(),
      },
    );
  }
}


