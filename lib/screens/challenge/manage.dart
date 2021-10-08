import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_challenge_app/componnent/help_dialog.dart';
import 'package:restaurant_challenge_app/model/notifier.dart';
import 'package:restaurant_challenge_app/model/users.dart';
import 'package:restaurant_challenge_app/screens/auth_screen.dart';
import 'package:restaurant_challenge_app/screens/challenge/ResturantList.dart';
import 'package:restaurant_challenge_app/screens/challenge/info_restaurant.dart';
import 'package:restaurant_challenge_app/screens/challenge/userScore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

import '../../constants.dart';

class ChallengeManagement extends StatefulWidget {
  static String id = 'challengeManagement_screen';
  @override
  _ChallengeManagementState createState() => _ChallengeManagementState();
}

class _ChallengeManagementState extends State<ChallengeManagement> {
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child('challenges');
  final double rate = 6;
  int winnerRestaurant;
  String referral,idRestaurant,massage;
  Map args;
  String date;

  @override
  void initState() {
      Timer(Duration(milliseconds: 200), () {
        if (args['show'] == false) {
          showHelpDialog(context);
          setShow(true);
        }
      });
    stream(context);
    super.initState();
  }

  Future<void> setShow(bool isShow) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show', isShow);
  }

  @override
  Widget build(BuildContext context) {
    referral = Provider.of<Notifier>(context, listen: false).referral;
    winnerRestaurant = Provider.of<Notifier>(context, listen: true)
        .winnerRestaurant
        .restaurantRate;
    Size size = MediaQuery.of(context).size;
    args = ModalRoute.of(context).settings.arguments;
    date = args['date'].substring(0, 10);
    String isStartPlay =
        Provider.of<Notifier>(context, listen: true).isStartPlay == true
            ? 'Yes'
            : 'No';
    String isEndPlay =
        Provider.of<Notifier>(context, listen: true).isEndPlay == true
            ? 'Yes'
            : 'No';
    massage =
        "You have been invited to the ${args['challengeName']} challenge. This is a challenge between my friends on $date at ${args['time']} and you can participate in this challenge through the following code.\nYour invitation code: $referral";

    return Scaffold(
      floatingActionButton: Provider.of<Notifier>(context, listen: true)
              .isActive
          ? FloatingActionButton(
        child: Icon(
          Icons.stop_circle_outlined,
          color: kPrimaryColor,
          size: 45,
        ),
        backgroundColor: kColorWhite,
        onPressed: () {
          changeStatus(context,
              !Provider.of<Notifier>(context, listen: false).isActive);
          Fluttertoast.showToast(
              msg: 'Your game has stopped',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black87,
              textColor: Colors.white);
        },
      )
          : SizedBox(),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Challenge'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            iconSize: 25.0,
            icon: Icon(Icons.info_rounded),
            onPressed: ()=> showHelpDialog(context),
          ),
          IconButton(
            iconSize: 25.0,
            icon: Icon(Icons.delete_rounded),
            onPressed: ()=> showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Do you want to delete this game?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () =>  onPressChallengeDelete(referral),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        ],
        leading: IconButton(
          iconSize: 20.0,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 5.0 / 2,
                ),
                height: size.height < 790 ? size.height / 1.75 : size.height / 1.99,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/icons/cheat-day.png"))),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 14.0, right: 40.0),
                                  child: ticketDetailsWidget('Game Name',
                                      '${args['challengeName']}', '', ''),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 18.0, right: 40.0),
                                  child: ticketDetailsWidget('Date', '$date',
                                      'Time', '${args['time']}'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 18.0, right: 40.0),
                                  child: ticketDetailsWidget(
                                      'City',
                                      '${args['city']}',
                                      'Users',
                                      Provider.of<Notifier>(context,
                                              listen: true)
                                          .users
                                          .length
                                          .toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 18.0, right: 40.0),
                                  child: ticketDetailsWidget('Play Game',
                                      '$isStartPlay', 'End Game', '$isEndPlay'),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Expanded(
                          child: SizedBox(
                        height: size.height / 1,
                      )),
                      Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color(0xFFFF5715),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          onTap: (){
                            if (Provider
                                .of<Notifier>(context, listen: false)
                                .winnerRestaurant
                                .restaurantId != '') {
                              showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      )),
                                  builder: (context) {
                                    return InfoRestaurant(idRestaurant:Provider
                                        .of<Notifier>(context, listen: false)
                                        .winnerRestaurant
                                        .restaurantId,);
                                  });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  child: CircleAvatar(
                                    backgroundColor: kColorWhite,
                                    backgroundImage: Provider.of<Notifier>(
                                                    context,
                                                    listen: true)
                                                .winnerRestaurant
                                                .restaurantImg ==
                                            ''
                                        ? AssetImage('assets/icons/pizza1.png')
                                        : NetworkImage(Provider.of<Notifier>(
                                                context,
                                                listen: true)
                                            .winnerRestaurant
                                            .restaurantImg),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        Provider.of<Notifier>(context,
                                                listen: true)
                                            .winnerRestaurant
                                            .restaurantName,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          for (var i = 1; i < rate; i++) ...{
                                            if (i <= winnerRestaurant) ...{
                                              Icon(
                                                Icons.star_rate_sharp,
                                                size: 18,
                                                color: Colors.orange,
                                              ),
                                            },
                                            if (i > winnerRestaurant) ...{
                                              Icon(
                                                Icons.star_border_rounded,
                                                size: 18,
                                                color: Colors.orange,
                                              ),
                                            }
                                          }
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        Provider.of<Notifier>(context,
                                                listen: true)
                                            .winnerRestaurant
                                            .restaurantAddress,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      SizedBox(
                                        height: 5,
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
                                      Provider.of<Notifier>(context, listen: true)
                                                  .winnerReview ==
                                              null
                                          ? Text('unknown')
                                          : Text(Provider.of<Notifier>(context,
                                                  listen: true)
                                              .winnerReview
                                              .toString()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: SizedBox(
                        height: size.height / 1,
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Referral Code:',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 2,),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: kPrimaryColor,
                                  // boxShadow: [
                                  //   BoxShadow(color: Colors.green, spreadRadius: 3),
                                  // ],
                                ),
                                padding: EdgeInsets.symmetric(vertical: 1,horizontal: 6),
                                child: Text(
                                  Provider.of<Notifier>(context, listen: true)
                                      .referral
                                      .toString(),
                                  style: TextStyle(color: kColorWhite,
                                      fontSize: 30, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 20.0,),
                          socialIcon(
                              context, Icons.copy, Colors.black45, "copy"),
                          socialIcon(context, FontAwesomeIcons.sms,
                              Colors.black87, "sms"),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            child: TextButton.icon(
                              // style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryColor.withOpacity(0.8))),
                              onPressed: () {
                                Share.share(massage,subject: 'Hungry Game');
                              },
                              icon: Icon(Icons.share_rounded,color: Colors.black87,),
                              label: Text(
                                'Share In',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                          child: SizedBox(
                        height: size.height / 1,
                      )),
                    ],
                  ),
                ),
              ),
              InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                        builder: (context) {
                          return UserScore();
                        });
                  },
                  child: list(context, "rating", "Users")),
              InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                        builder: (context) {
                          return RestaurantList();
                        });
                  },
                  child: list(context, "restaurant", "Restaurant")),
              // stream(context),
            ],
          ),
        ),
      ),
    );
  }

  changeStatus(BuildContext context, bool isActive) async {
    print('kkkk');
    try {
      DatabaseReference databaseRef =
          dbRef.child(Provider.of<Notifier>(context, listen: false).referral);

      await databaseRef.update({
        'isActive': isActive,
        'isEndPlay': true,
      });
      Provider.of<Notifier>(context, listen: false).changeIsActive(isActive);
      List<int> scoreRestaurant = [];
      for (int i = 0;
          i <
              Provider.of<Notifier>(context, listen: false)
                  .uniqueRestaurantList
                  .length;
          i++) {
        scoreRestaurant.add(1);
        for (int j = 0;
            j <
                Provider.of<Notifier>(context, listen: false)
                    .restaurantList
                    .length;
            j++) {
          if (Provider.of<Notifier>(context, listen: false)
                  .uniqueRestaurantList
                  .elementAt(i)
                  .restaurantId ==
              Provider.of<Notifier>(context, listen: false)
                  .users
                  .elementAt(j)
                  .restaurant
                  .restaurantId) {
            scoreRestaurant[i] += Provider.of<Notifier>(context, listen: false)
                    .users
                    .elementAt(j)
                    .score *
                (Provider.of<Notifier>(context, listen: false)
                        .countRestaurantList
                        .elementAt(i) *
                    Provider.of<Notifier>(context, listen: false)
                        .countRestaurantList
                        .elementAt(i));
          }
        }
      }
      for (int j = 0; j < scoreRestaurant.length; j++) {
        if (scoreRestaurant.elementAt(0) < scoreRestaurant.elementAt(j)) {
          int a = scoreRestaurant.elementAt(j);
          scoreRestaurant.remove(j);
          scoreRestaurant.insert(0, a);

          Restaurant b = Provider.of<Notifier>(context, listen: false)
              .uniqueRestaurantList
              .elementAt(j);
          Provider.of<Notifier>(context, listen: false)
              .uniqueRestaurantList
              .remove(j);
          Provider.of<Notifier>(context, listen: false)
              .uniqueRestaurantList
              .insert(0, b);
          int c = Provider.of<Notifier>(context, listen: false)
              .countRestaurantList
              .elementAt(j);
          Provider.of<Notifier>(context, listen: false)
              .countRestaurantList
              .remove(j);
          Provider.of<Notifier>(context, listen: false)
              .countRestaurantList
              .insert(0, c);
        }
      }
      print(Provider.of<Notifier>(context, listen: false).uniqueRestaurantList);
      print(scoreRestaurant);

      Provider.of<Notifier>(context, listen: false).changeWinnerRestaurant(
          Provider.of<Notifier>(context, listen: false)
              .uniqueRestaurantList
              .elementAt(0));
      Provider.of<Notifier>(context, listen: false).changeWinnerReview(
          Provider.of<Notifier>(context, listen: false)
              .countRestaurantList
              .elementAt(0));
      Provider.of<Notifier>(context, listen: false)
          .changeWinnerRestaurantScore(scoreRestaurant.elementAt(0));
      // scoreRestaurant.sort();
      databaseRef.child('winner').update({
        'restaurantName': Provider.of<Notifier>(context, listen: false)
            .winnerRestaurant
            .restaurantName,
        'restaurantImg': Provider.of<Notifier>(context, listen: false)
            .winnerRestaurant
            .restaurantImg,
        'restaurantRate': Provider.of<Notifier>(context, listen: false)
            .winnerRestaurant
            .restaurantRate,
        'restaurantAddress': Provider.of<Notifier>(context, listen: false)
            .winnerRestaurant
            .restaurantAddress,
        'restaurantId': Provider.of<Notifier>(context, listen: false)
            .winnerRestaurant
            .restaurantId,
        'restaurantScore':
            Provider.of<Notifier>(context, listen: false).winnerRestaurantScore,
        'restaurantReview':
            Provider.of<Notifier>(context, listen: false).winnerReview
      });
      print('eeeeeeeeee');
    } catch (e) {
      print('aaaaaa');

      print(e);
    }
  }

  GestureDetector socialIcon(
      BuildContext context, IconData iconSrc, Color color, String nameIcon) {
    return GestureDetector(
      onTap: () async {
        if (nameIcon == "copy") {
          Clipboard.setData(ClipboardData(text: "$referral"));
          Fluttertoast.showToast(
              msg: 'Copied to clipboard',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black87,
              textColor: Colors.white);
        } else if (nameIcon == "sms") {
          launch('sms:?body=$massage');
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Icon(
          iconSrc,
          color: color,
          size: 30,
        ),
      ),
    );
  }

  Container list(BuildContext context, String img, String title) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 5.0 / 2,
      ),
      // color: Colors.blueAccent,
      height: 100,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // Those are our background
          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              // color: itemIndex.isEven ? kBlueColor : kSecondaryColor,
              // boxShadow: [kDefaultShadow],
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
            child: Row(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/icons/$img.png"))),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$title",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list_alt_rounded),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget ticketDetailsWidget(String firstTitle, String firstDesc,
      String secondTitle, String secondDesc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                firstTitle,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  firstDesc,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                secondTitle,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  secondDesc,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  stream(BuildContext context) {
    dbRef
        .child(Provider.of<Notifier>(context, listen: false).referral)
        .once()
        .then((value) {
      List<Users> users = [];
      List<Restaurant> restaurants = [];
      Map map = value.value;

      Provider.of<Notifier>(context, listen: false)
          .changeIsStartPlay(map['isStartPlay']);
      Provider.of<Notifier>(context, listen: false)
          .changeIsActive(map['isActive']);

      Provider.of<Notifier>(context, listen: false)
          .changeIsEndPlay(map['isEndPlay']);
      if (map['winner'] != null) {
        Restaurant restaurant = Restaurant(
            restaurantAddress: map['winner']['restaurantAddress'],
            restaurantImg: map['winner']['restaurantImg'],
            restaurantName: map['winner']['restaurantName'],
            restaurantRate: map['winner']['restaurantRate'],
            restaurantId: map['winner']['restaurantId']);
        Provider.of<Notifier>(context, listen: false)
            .changeWinnerRestaurant(restaurant);
        Provider.of<Notifier>(context, listen: false)
            .changeWinnerRestaurantScore(map['winner']['restaurantScore']);
        Provider.of<Notifier>(context, listen: false)
            .changeWinnerReview(map['winner']['restaurantReview']);
      } else {
        Restaurant winnerRestaurant = Restaurant(
            restaurantName: 'restaurant winner not decided',
            restaurantId: '',
            restaurantRate: 0,
            restaurantImg: '',
            restaurantAddress: 'Restaurant address unknown');
        Provider.of<Notifier>(context, listen: false)
            .changeWinnerRestaurant(winnerRestaurant);
        Provider.of<Notifier>(context, listen: false).changeWinnerReview(null);
      }
      if (map['users'] != null) {
        for (Map each in map['users'].values) {
          Restaurant restaurant = Restaurant(
              restaurantAddress: each['restaurant']['restaurantAddress'],
              restaurantImg: each['restaurant']['restaurantImg'],
              restaurantName: each['restaurant']['restaurantName'],
              restaurantRate: each['restaurant']['restaurantRate'],
              restaurantId: each['restaurant']['restaurantId']);
          restaurants.add(restaurant);

          Users user = Users(
              isPlay: each['isPlay'],
              restaurant: restaurant,
              score: each['score'],
              userName: each['name'],
              id: each['id']);
          users.add(user);
        }
      }
      users.sort((b, a) => a.score.compareTo(b.score));
      Provider.of<Notifier>(context, listen: false).changeUsersList(users);
      Provider.of<Notifier>(context, listen: false)
          .changeRestaurantList(restaurants);
      List<Restaurant> uniqueRestaurant = [];
      List<int> countRestaurant = [];
      for (int i = 0;
          i <
              Provider.of<Notifier>(context, listen: false)
                  .restaurantList
                  .length;
          i++) {
        bool check = false;

        for (int j = 0; j < uniqueRestaurant.length; j++) {
          if (uniqueRestaurant.elementAt(j).restaurantId ==
              Provider.of<Notifier>(context, listen: false)
                  .restaurantList
                  .elementAt(i)
                  .restaurantId) {
            check = true;
            break;
          }
        }
        if (check) {
          print('ok');
        } else {
          uniqueRestaurant.add(Provider.of<Notifier>(context, listen: false)
              .restaurantList
              .elementAt(i));
        }
      }
      for (int i = 0; i < uniqueRestaurant.length; i++) {
        countRestaurant.add(0);
        for (int j = 0;
            j <
                Provider.of<Notifier>(context, listen: false)
                    .restaurantList
                    .length;
            j++) {
          if (uniqueRestaurant.elementAt(i).restaurantId ==
              Provider.of<Notifier>(context, listen: false)
                  .restaurantList
                  .elementAt(j)
                  .restaurantId) {
            countRestaurant[i]++;
          }
        }
      }

      Provider.of<Notifier>(context, listen: false)
          .changeUniqueRestaurantList(uniqueRestaurant);
      Provider.of<Notifier>(context, listen: false)
          .changeCountRestaurantList(countRestaurant);
    });
  }

  onPressChallengeDelete(String idChallenge) async{
    await dbRef.child(idChallenge).remove();
    Navigator.of(context).pushNamedAndRemoveUntil(
        AuthScreen.id, (Route<dynamic> route) => false);
  }
}

