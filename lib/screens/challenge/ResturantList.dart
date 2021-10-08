import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_challenge_app/model/notifier.dart';
import 'package:restaurant_challenge_app/model/users.dart';

import '../../constants.dart';

class RestaurantList extends StatelessWidget {
  static String id = 'RestaurantList';

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
                  "Selected Restaurants",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                      fontSize: 20),
                ),
              ),
            ),
          ),
          Provider.of<Notifier>(context, listen: false).uniqueRestaurantList.length == 0
              ? Expanded(
                  child: Center(
                      child: Text(
                  'No restaurant found',
                  style: TextStyle(fontSize: 20, color: kColorWhite),
                )))
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount:  Provider.of<Notifier>(context, listen: false).uniqueRestaurantList.length,
                  itemBuilder: (context, index) {
                    print( Provider.of<Notifier>(context, listen: false).uniqueRestaurantList.length);
                    return cardListRestaurantWidget(
                      Provider.of<Notifier>(context, listen: false).uniqueRestaurantList.elementAt(index).restaurantImg,
                      Provider.of<Notifier>(context, listen: false).uniqueRestaurantList.elementAt(index).restaurantName,
                      Provider.of<Notifier>(context, listen: false).uniqueRestaurantList.elementAt(index).restaurantRate,
                      Provider.of<Notifier>(context, listen: false).uniqueRestaurantList.elementAt(index).restaurantAddress,
                    );
                  },
                ),
        ],
      ),
    );
  }

  Card cardListRestaurantWidget(
      String img, String name, int rate, String address) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFFFF5715), width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
        child: Row(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage("$img"))),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "$name",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < rate; i++)
                        Icon(
                          Icons.star_rate_rounded,
                          size: 20,
                          color: Colors.orange,
                        ),
                      for (var i = 5; i > rate; i--)
                        Icon(
                          Icons.star_border_rounded,
                          size: 20,
                          color: Colors.orange,
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    address,
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Image.asset('assets/images/yelp.png',width: 45,height: 30,),
          ],
        ),
      ),
    );
  }
}
