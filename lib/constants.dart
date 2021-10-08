import 'package:flutter/material.dart';


const kColorWhite = Colors.white;
const kPrimaryColor = Color(0xFFFF5715);
const kDialogErrorColor = Color(0xFFF44336);
const kDialogSuccessColor = Color(0xFF4caf50);

final String infoUrl = 'https://api.yelp.com/v3/businesses/';

final kOutLineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
);

final kTopOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(10),
    topLeft: Radius.circular(10),
  ),
);

final kHeaderTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.black,
);

final kCustomAppBarDecoration = BoxDecoration(
  color: Colors.blueAccent,
  borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(30),
      bottomRight: Radius.circular(30)
  ),
);

final kCustomProgressIndicator = Container(
  height: 100,
  width: 100,
  // decoration: BoxDecoration(
  //   borderRadius: BorderRadius.circular(10),
  //   color: Colors.blueGrey,
  // ),
  child: Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF5715)),
    ),
  ),
);