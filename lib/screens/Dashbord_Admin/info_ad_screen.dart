import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_challenge_app/constants.dart';

class InfoAd extends StatelessWidget {
  const InfoAd({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFFF5715),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                backgroundColor: kColorWhite,
                radius: 90,
                child: Text(''),
                backgroundImage: AssetImage('assets/images/logo.png'),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: kColorWhite,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Text(
                'If you also want to promote your business in this program, you can do this in two ways.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 5,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: kColorWhite,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Row(
                children:[
                  Icon(Icons.alternate_email_rounded),
                  SizedBox(width: 10,),
                  Text(
                    'Fitz@tbonestitch.com',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
