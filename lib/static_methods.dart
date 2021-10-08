import 'package:restaurant_challenge_app/constants.dart';
import 'package:flutter/material.dart';
import 'constants.dart';


class StaticMethods {
  static void showErrorDialog(
      {@required BuildContext context, @required String text}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            text,
            style: kHeaderTextStyle.copyWith(),
          ),
          content: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Ok'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.green,
              ),
            ),
          ),
        );
      },
    );
  }

  static void simplePopAndPushNavigation(
      {@required BuildContext context, @required String routeName}) {
    Navigator.popAndPushNamed(context, routeName);
  }

  static AlertDialog myAlertDialog(
      Function selectFromCamera, Function selectFromGallery) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Select Image',
                  textDirection: TextDirection.rtl,
                  style: kHeaderTextStyle.copyWith(color: Colors.grey[800]),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 0.5,
            width: double.infinity,
            color: Colors.grey,
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              selectFromCamera();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'From Camera‌',
                    textDirection: TextDirection.rtl,
                    style: kHeaderTextStyle.copyWith(color: Colors.grey[700]),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.camera_alt,
                    color: Colors.grey[700],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              selectFromGallery();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'From Gallery',
                    textDirection: TextDirection.rtl,
                    style: kHeaderTextStyle.copyWith(color: Colors.grey[700]),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.insert_photo,
                    color: Colors.grey[700],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static PreferredSize myAppBar(String text){
    return PreferredSize(
      child: Container(
        decoration: kCustomAppBarDecoration,
        child: SafeArea(
          child: Container(
            decoration: kCustomAppBarDecoration,
            child: Center(
              child: Text(
                text,
                style: kHeaderTextStyle.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      preferredSize: Size(
        double.infinity,
        70,
      ),
    );
  }

  static mySnackBar(String title,Size size, Color color) {
    return SnackBar(
      content: Text(
        title.toString(),
        style: TextStyle(
            color: kColorWhite,
            fontSize: 17,
            fontWeight: FontWeight.bold),
      ),
      backgroundColor: color,
      duration: const Duration(milliseconds: 2500),
      width: size.width * 0.9,
      padding: const EdgeInsets.symmetric(
        horizontal: 14.0,
        vertical: 20.0,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }

}
