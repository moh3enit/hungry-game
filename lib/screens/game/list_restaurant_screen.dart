import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:restaurant_challenge_app/componnent/filter.dart';
import 'package:restaurant_challenge_app/model/field_notifier.dart';
import 'package:restaurant_challenge_app/model/info_restaurant.dart';
import 'package:restaurant_challenge_app/model/notifier.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert' as convert;
import '../../constants.dart';

class ListRestaurant extends StatefulWidget {
  static String id = 'list_restaurant_screen';

  const ListRestaurant({Key key}) : super(key: key);

  @override
  _ListRestaurantState createState() => _ListRestaurantState();
}

class _ListRestaurantState extends State<ListRestaurant> {
  String url,location,name,categories;

  @override
  void initState() {
    super.initState();
    makeUrl();
  }

  @override
  Widget build(BuildContext context) {
    location=Provider.of<Notifier>(context, listen: false).location;
    name=Provider.of<FieldNotifier>(context, listen: false).nameRestaurantSearch;
    categories=Provider.of<FieldNotifier>(context, listen: false).categoriesRestaurantSearch;
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFFF5715),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Column(
        children: [
          locationRestaurantWidget(location),
          if (name != null || categories != null) ...[filterRestaurantWidget()],
          Expanded(
            child: futureBuilder()
          ),
        ],
      ),
    );
  }

  void makeUrl(){
    String name=Provider.of<FieldNotifier>(context, listen: false).nameRestaurantSearch;
    String categories=Provider.of<FieldNotifier>(context, listen: false).categoriesRestaurantSearch;
    String location=Provider.of<Notifier>(context, listen: false).location;
    if (name == null && categories == null) {
      url = '$infoUrl' + 'search?term=restaurants&location=' + '$location';
    } else if (categories == null) {
      url = '$infoUrl' + 'search?term=' + '$name' + '&location=' + '$location';
    } else if (name == null) {
      url = '$infoUrl' + 'search?term=restaurants&categories=' + '$categories' + '&location=' + '$location';
    } else {
      url = '$infoUrl' + 'search?term=' + '$name' + '&categories=' + '$categories' + '&location=' + '$location';
    }
  }

  FutureBuilder futureBuilder(){
    return FutureBuilder(
      future: http.get(
        Uri.parse('$url'),
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
            var rest = jsonResponse["businesses"] as List;
            List<Businesses> businesses = [];
            businesses = rest
                .map<Businesses>((json) => Businesses.fromJson(json))
                .toList();
            return ListView.builder(
              itemCount: businesses.length,
              itemBuilder: (context, index) {
                return cardListRestaurantWidget(
                    businesses[index].imageUrl,
                    businesses[index].name,
                    businesses[index].rating.round(),
                    businesses[index].location.address1 +
                        " | " +
                        businesses[index].location.city +
                        " | " +
                        businesses[index].location.state +
                        " | " +
                        businesses[index].location.zipCode,
                    businesses[index].reviewCount,
                    businesses[index].id);
              },
            );
            // }
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
          return Shimmer.fromColors(
            // enabled: true,
            baseColor: Colors.grey[400],
            highlightColor: Colors.grey[100],
            child: ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: 7,
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: placeHolderRow(),
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 2),
            ),
          );
        }
      },
    );
  }

  Widget placeHolderRow() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
        child: Row(
          children: [
            Container(
              height: 70,
              width: 70,
              color: Colors.white,
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
                  Container(
                    width: double.infinity,
                    height: 8.0,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < 5; i++)
                        Icon(
                          Icons.star_rate_rounded,
                          size: 20,
                          color: Colors.orange,
                        ),
                      for (var i = 5; i > 5; i--)
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
                  Container(
                    width: double.infinity,
                    height: 8.0,
                    color: Colors.white,
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
            Container(
              child: Column(
                children: [
                  Icon(Icons.visibility),
                  Text('000'),
                ],
              ),
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
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.location_searching_rounded,
                  size: 17.0,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Location:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  location,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        child: FilterDialog(),
                      ),
                    ),
                  );
                },
              ).then((value){
                makeUrl();
                setState(() {});
              });
            },
            icon: Icon(
              Icons.filter_alt_rounded,
              size: 35.0,
            ),
          ),
        ],
      ),
    );
  }

  Container filterRestaurantWidget() {
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
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.filter_alt_rounded,
                  size: 20.0,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Filters:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  width: 5,
                ),
                if(name != null) ...[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 7,vertical: 5),
                    margin: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: Colors.grey,),
                    child: Text(
                      name,
                      style: TextStyle(fontSize: 15,color: kColorWhite),
                    ),
                  )
                ],
                if(categories != null) ...[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 7,vertical: 5),
                    margin: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: Colors.grey,),
                    child: Text(
                      categories,
                      style: TextStyle(fontSize: 15,color: kColorWhite),
                    ),
                  )
                ]
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Provider.of<FieldNotifier>(context, listen: false).changeCategoriesRestaurantSearch(null);
              Provider.of<FieldNotifier>(context, listen: false).changeNameRestaurantSearch(null);
              makeUrl();
              setState(() {});
            },
            icon: Icon(
              Icons.remove_circle,
              size: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  InkWell cardListRestaurantWidget(String img, String name, int rate,
      String address, int review, String id) {
    return InkWell(
      onTap: () async {
        Provider.of<Notifier>(context, listen: false).changeIsSelected(true);
        Provider.of<Notifier>(context, listen: false).changeImg(img);
        Provider.of<Notifier>(context, listen: false).changeName(name);
        Provider.of<Notifier>(context, listen: false).changeRate(rate);
        Provider.of<Notifier>(context, listen: false).changeAddress(address);
        Provider.of<Notifier>(context, listen: false).changeRestaurantId(id);

        try {
          final DatabaseReference dbRef1 = FirebaseDatabase.instance
              .reference()
              .child('restaurant')
              .child(id);
          await dbRef1.once().then((value) {
            print(value.value['restaurantReview']);
            Provider.of<Notifier>(context, listen: false)
                .changeRestaurantReview(value.value['restaurantReview']);
            print('true');
          });
          Navigator.pop(context);
        } catch (e) {
          Navigator.pop(context);
        }
      },
      child: Card(
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
              Container(
                child: Column(
                  children: [
                    Image.asset('assets/images/yelp.png',width: 45,height: 30,),
                    Icon(Icons.visibility),
                    Text('$review'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
