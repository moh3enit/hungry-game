import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_challenge_app/constants.dart';
import 'package:restaurant_challenge_app/model/info_restaurant.dart';
import 'package:restaurant_challenge_app/model/notifier.dart';

class UserScore extends StatelessWidget {
  static String id = 'UserScore';

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFFF5715),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(color: Color(0xFFFF5715), width: 2),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 1,
                        color: kColorWhite,
                        blurRadius: 20.0,
                        offset: Offset(0, 0))
                  ]),
              child: Center(
                child: Text(
                  "Participating Users",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                      fontSize: 20),
                ),
              ),
            ),
          ),
          Provider.of<Notifier>(context, listen: false).users.length == 0
          ? Expanded(child: Center(child: Text('No user found',style: TextStyle(fontSize: 20,color: kColorWhite),)))
          : ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount:
                Provider.of<Notifier>(context, listen: false).users.length,
            itemBuilder: (context, index) {
              print(Provider.of<Notifier>(context, listen: false).users.length);
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 23,
                              backgroundColor: kColorWhite,
                              child: Text(
                                (index + 1).toString(),
                                style:
                                TextStyle(color: Colors.black87, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: kColorWhite,
                                borderRadius: BorderRadius.circular(50)),
                            padding: EdgeInsets.only(right: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 23,
                                  backgroundImage:
                                      AssetImage('assets/icons/profile.png'),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        'Users: ',
                                        style: TextStyle(
                                            color: Colors.black87, fontSize: 13),
                                      ),
                                      Text(
                                        '${Provider.of<Notifier>(context,
                                            listen: false)
                                            .users
                                            .elementAt(index)
                                            .userName}',
                                        style: TextStyle(
                                            color: Colors.black87, fontSize: 16,fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "${Provider.of<Notifier>(context, listen: false).users.elementAt(index).score}",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
