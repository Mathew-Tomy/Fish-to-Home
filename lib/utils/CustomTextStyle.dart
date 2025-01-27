import 'package:flutter/material.dart';

// class CustomTextStyle {
//   static var textFormFieldRegular = TextStyle(
//       fontSize: 16,
//       fontFamily: "Helvetica",
//       color: Colors.black,
//       fontWeight: FontWeight.w400);

//   static var textFormFieldLight =
//       textFormFieldRegular.copyWith(fontWeight: FontWeight.w200);

//   static var textFormFieldMedium =
//       textFormFieldRegular.copyWith(fontWeight: FontWeight.w500);

//   static var textFormFieldSemiBold =
//       textFormFieldRegular.copyWith(fontWeight: FontWeight.w600);

//   static var textFormFieldBold =
//       textFormFieldRegular.copyWith(fontWeight: FontWeight.w700);

//   static var textFormFieldBlack =
//       textFormFieldRegular.copyWith(fontWeight: FontWeight.w900);
// }
 class CustomTextStyle {
  static TextStyle textFormFieldSemiBold({
  Color color = Colors.black,
  double fontSize = 14,
  }) {
  return TextStyle(
  fontWeight: FontWeight.w600, // Adjust the font weight as needed
  color: color,
  fontSize: fontSize,
  );
  }
  }