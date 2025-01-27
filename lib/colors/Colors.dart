import 'dart:ui';

import 'package:flutter/cupertino.dart';

class CustomColor {
  static const Color primaryColor = Color(0xFF1051AB);
  static const Color secondaryColor = Color(0xFFE8AF77);
  static Color accentColor = Color(0xFF2C3066);
  static Color yellowLightColor = Color(0xFFFDF5E6);
  static Color electricVioletColor = Color(0xFF7836FC);
  static Color redColor = Color(0xFFD90404);
  static Color greyColor = Color(0xFF707070);
  static Color greenColor = Color(0xFF03A60F);
  static Color greenLightColor = Color(0xFFE5F6E7);
  static Color blueColor = Color(0xFF307AFF);

  static var primaryButtonGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        accentColor.withOpacity(0.8),
        accentColor,
      ]
  );

  static var secondaryButtonGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        primaryColor.withOpacity(0.8),
        primaryColor,
      ]
  );
}
