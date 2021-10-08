
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:restaurant_challenge_app/model/info_restaurant.dart';
import 'package:restaurant_challenge_app/model/notifier.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' as convert;
import '../../constants.dart';


class InfoRestaurant extends StatefulWidget {
  static String id = 'info_restaurant_screen';
  final String idRestaurant;
  const InfoRestaurant({@required this.idRestaurant});

  @override
  _InfoRestaurantState createState() => _InfoRestaurantState();
}

class _InfoRestaurantState extends State<InfoRestaurant> {

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
          locationRestaurantWidget(Provider.of<Notifier>(context, listen: false).location),
          Expanded(
            child: FutureBuilder(
              future: http.get(
                Uri.parse('$infoUrl' + '${widget.idRestaurant}'),
                headers: {
                  "Authorization":
                  "Bearer hytQphtTOwd7xAj3i8by1nuzi0px6W17cTIQUL6jcv9nwFMVzhRIiNO43tYV_euGT_du-AFsA58gDybdo3d0S_YRX2TjeWbLClmzOzS5sThudtTSa47rYIlT6M0TYXYx",
                },
              ),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  http.Response response = snapshot.data;
                  if (response.statusCode < 300) {
                    var jsonResponse = convert.jsonDecode(response.body);
                    List location=jsonResponse['location']['display_address'];
                    List transactions=jsonResponse['transactions'];
                    var map1 = Map.fromIterable(jsonResponse['categories'] as List);
                    List<String> videoList = [];
                    map1.values.forEach((values) {
                      videoList.add(values['title']);
                    });
                    return cardListRestaurantWidget(
                        jsonResponse['image_url'],
                        jsonResponse['name'],
                        jsonResponse['rating'].round(),
                        location.join(', '),
                        jsonResponse['review_count'],
                        jsonResponse['url'],
                        jsonResponse['display_phone'],
                        jsonResponse['hours'][0]['is_open_now'],
                        transactions.join(', '),
                        jsonResponse['price'],
                        videoList.join(', '),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'An Error happened',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    );
                  }
                } else {
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xFFFF5715), width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Shimmer.fromColors(
                      // enabled: true,
                      baseColor: Colors.grey[400],
                      highlightColor: Colors.grey[100],
                      child: placeHolderRow(),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget placeHolderRow() =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 140,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.visibility_rounded),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 150,
                            height: 10.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          Icon(Icons.star_border_rounded),
                          SizedBox(
                            width: 10,
                          ),
                          for (var i = 0; i < 5; i++)
                            Icon(
                              Icons.star_rate_rounded,
                              size: 15,
                              color: Colors.orange,
                            ),
                          for (var i = 5; i > 5; i--)
                            Icon(
                              Icons.star_border_rounded,
                              size: 15,
                              color: Colors.orange,
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          Icon(Icons.phone),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 150,
                            height: 10.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          Icon(Icons.login_rounded),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 150,
                            height: 10.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        width: 150,
                        height: 20.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 7,
            ),
            Row(
              children: [
                Icon(Icons.home_filled),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 350,
                  height: 10.0,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(
              height: 7,
            ),
            Row(
              children: [
                Icon(Icons.category_rounded),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 350,
                  height: 10.0,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(
              height: 7,
            ),
            Row(
              children: [
                Icon(Icons.delivery_dining_rounded),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 350,
                  height: 10.0,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(
              height: 7,
            ),
            Row(
              children: [
                Icon(Icons.pin_drop_rounded),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 350,
                  height: 10.0,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      );


  Container locationRestaurantWidget(String location) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFFFFF),
            blurRadius: 19.0,
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 27.0,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Info Winner Restaurant',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Card cardListRestaurantWidget(
      String img, String name, int rate, String address, int review,String url,String phone,bool isOpen,String isTransactions,String price,String category) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFFFF5715), width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      height: 180,
                      width: 160,
                      child: Column(
                        children: [
                          Image.asset(
                              'assets/images/yelp_logo_for_restaurants.png'),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Image.network(
                                '$img'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(Icons.visibility_rounded),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '$review',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(Icons.star_border_rounded),
                            SizedBox(
                              width: 10,
                            ),
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
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(Icons.phone),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '$phone',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(Icons.login_rounded),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              isOpen ? 'OPEN' : 'CLOSE',
                              style: TextStyle(fontSize: 18,color: isOpen ? Colors.green : Colors.red,fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.link),
                          label: Text('More information'),
                          onPressed: () async {
                            if (await canLaunch(url)) {
                            await launch(url);
                            } else {
                            throw 'Could not launch $url';
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Icon(Icons.home_filled),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      "$name",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(Icons.category_rounded),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      category,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(Icons.delivery_dining_rounded),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      isTransactions,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(Icons.pin_drop_rounded),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      "$address",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
