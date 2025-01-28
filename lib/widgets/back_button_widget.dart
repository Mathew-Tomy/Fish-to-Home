
import 'package:fishtohome/colors/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackWidget extends StatefulWidget {

  final String title;

  const BackWidget({ required this.title});

  @override
  _BackWidgetState createState() => _BackWidgetState();
}

class _BackWidgetState extends State<BackWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20,
          top: 12
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            child: Icon(
              Icons.arrow_back,
              color: CustomColor.accentColor,
              size: 22,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          SizedBox(width: 10,),
          Text(
            widget.title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CustomColor.greyColor
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
