import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_challenge_app/componnent/ticket_widget2.dart';
import 'package:restaurant_challenge_app/constants.dart';
import 'package:restaurant_challenge_app/model/notifier.dart';
import 'package:restaurant_challenge_app/model/users.dart';
import 'package:restaurant_challenge_app/screens/auth_screen.dart';
import 'package:restaurant_challenge_app/screens/login_to_challenge_room.dart';

class ResultGama extends StatefulWidget {
  static String id = 'result_game_screen';

  const ResultGama({Key key}) : super(key: key);

  @override
  _ResultGamaState createState() => _ResultGamaState();
}

class _ResultGamaState extends State<ResultGama> {
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child('challenges');
  FirebaseAuth auth = FirebaseAuth.instance;
  int score=0,rate=0;
  String name;
  String
  challengeName='Game Name',
      city='city',
      date='date',
      time='time',
      referralCode='referralCode',
      restaurantName='restaurantName',
      restaurantImg='restaurantImg',
      restaurantAddress='restaurantAddress',
      winner='winner';
  bool showLoadingProgress = false;

  getDataInvitationTicket(BuildContext context) {
    showLoadingProgress = true;
    setState(() {});
    try {
      dbRef.child(Provider.of<Notifier>(context, listen: true).referral)
          .once().then((DataSnapshot snapshot) {
        Map data = snapshot.value;
        challengeName = data['challengeName'];
        city = data['city'];
        time = data['time'];
        date = data['date'].substring(0, 10);
        score = data['users'][auth.currentUser.uid]['score'];
        name = data['users'][auth.currentUser.uid]['name'];
        rate = data['users'][auth.currentUser
            .uid]['restaurant']['restaurantRate'];
        restaurantImg =
        data['users'][auth.currentUser.uid]['restaurant']['restaurantImg'];
        restaurantName =
        data['users'][auth.currentUser.uid]['restaurant']['restaurantName'];
        restaurantAddress =
        data['users'][auth.currentUser.uid]['restaurant']['restaurantAddress'];
        if (data['winner'] != null) {
          Restaurant restaurant = Restaurant(
              restaurantAddress: data['winner']['restaurantAddress'],
              restaurantImg: data['winner']['restaurantImg'],
              restaurantName: data['winner']['restaurantName'],
              restaurantRate: data['winner']['restaurantRate'],
              restaurantId: data['winner']['restaurantId']);
          Provider.of<Notifier>(context, listen: false).changeWinnerRestaurant(
              restaurant);
          Provider.of<Notifier>(context, listen: false)
              .changeWinnerRestaurantScore(data['winner']['restaurantScore']);
          Provider.of<Notifier>(context, listen: false).changeWinnerReview(
              data['winner']['restaurantReview']);
        } else {
          winner = data['winner'];
          Restaurant winnerRestaurant = Restaurant(
              restaurantName: 'Restaurant name unknown',
              restaurantId: '',
              restaurantRate: 0,
              restaurantImg: '',
              restaurantAddress: 'Restaurant address unknown');
          Provider.of<Notifier>(context, listen: false).changeWinnerRestaurant(
              winnerRestaurant);
          Provider.of<Notifier>(context, listen: false).changeWinnerReview(
              null);
        }
      });
      showLoadingProgress = false;
      setState(() {});
    } on FirebaseException catch (e) {
      showLoadingProgress = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    getDataInvitationTicket(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showLoadingProgress,
          progressIndicator: kCustomProgressIndicator,
          child: Center(
            child: FlutterTicketWidget2(
              width: size.width / 1.15,
              height: size.height < 850 ? size.height / 1.14 : size.height / 1.33,
              isCornerRounded: true,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          iconSize: 20.0,
                          icon: Icon(Icons.arrow_back_ios),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.pop(context, AuthScreen.id);
                          },
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 17.0),
                              child: Text(
                                'Invitation Ticket',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 50,
                            minHeight: 50,
                            maxWidth: 50,
                            maxHeight: 50,
                          ),
                          child: Image.asset("assets/icons/fastfood.png",
                              fit: BoxFit.cover),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 40.0),
                            child: ticketDetailsWidget(
                                'Game Participant Name', '${auth.currentUser.displayName}', '', ''),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 17.0, right: 40.0),
                            child: ticketDetailsWidget(
                                'Game Name', '$challengeName', '', ''),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 17.0, right: 40.0),
                            child: ticketDetailsWidget(
                                'Date', '$date', 'Time', '$time'),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 17.0, right: 40.0),
                            child: ticketDetailsWidget(
                                'City', '$city', 'Score', '$score'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: size.height < 850
                          ? const EdgeInsets.only(top: 50.0,bottom: 40.0)
                          : const EdgeInsets.only(top: 40.0,bottom: 45.0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFF5715),
                              blurRadius: 9.0,
                            ),
                          ],
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color(0xFFFF5715), width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: restaurantImg=='restaurantImg'
                                            ? AssetImage('assets/icons/pizza1.png')
                                            : NetworkImage("$restaurantImg")),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "$restaurantName",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          for (var i = 0; i < rate; i++)
                                            Icon(
                                              Icons.star_rate_rounded,
                                              size: 18,
                                              color: Colors.orange,
                                            ),
                                          for (var i = 5; i > rate; i--)
                                            Icon(
                                              Icons.star_border_rounded,
                                              size: 18,
                                              color: Colors.orange,
                                            ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "$restaurantAddress",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Image.asset('assets/images/yelp.png',width: 45,height: 30,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox(height: size.height / 1,)),
                    Flex(
                      direction: Axis.vertical,
                      children: [
                        MySeparator(color: Colors.grey),
                      ],
                    ),
                    size.height < 850 ? SizedBox(height: 20,) : SizedBox(height: 10,),
                    Expanded(child: SizedBox(height: size.height / 1,)),
                    Provider.of<Notifier>(context, listen: true).winnerRestaurant.restaurantImg == ''
                        ? Center(
                      child: Text(
                        'The result of the game: The game is not over yet',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    )
                        : Center(
                      child: Text(
                        'Game Result: The game is over the restaurant wins',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightGreen,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Color(0xFFFF5715),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
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
                                backgroundImage: Provider.of<
                                    Notifier>(
                                    context,
                                    listen: true)
                                    .winnerRestaurant
                                    .restaurantImg ==
                                    ''
                                    ? AssetImage(
                                    'assets/icons/pizza1.png')
                                    : NetworkImage(
                                    Provider.of<Notifier>(
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
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
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
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      for (var i = 1; i < 6; i++) ...{
                                        if (i <=
                                            Provider.of<Notifier>(
                                                context,
                                                listen: true)
                                                .winnerRestaurant
                                                .restaurantRate) ...{
                                          Icon(
                                            Icons.star_rate_sharp,
                                            size: 18,
                                            color: Colors.orange,
                                          ),
                                        },
                                        if (i >
                                            Provider.of<Notifier>(
                                                context,
                                                listen: true)
                                                .winnerRestaurant
                                                .restaurantRate) ...{
                                          Icon(
                                            Icons
                                                .star_border_rounded,
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
                                    style:
                                    TextStyle(fontSize: 10),
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
                                  Icon(Icons.visibility),
                                  Provider.of<Notifier>(context,
                                      listen: true)
                                      .winnerReview ==
                                      null
                                      ? Text(
                                    'unknown',
                                    style: TextStyle(
                                        fontSize: 12),
                                  )
                                      : Text(
                                      Provider.of<Notifier>(
                                          context,
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
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 75.0, right: 75.0),
                      child: Center(
                        child: Text(
                          'ReferralCode: ${Provider.of<Notifier>(context, listen: false).referral}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget ticketDetailsWidget(String firstTitle, String firstDesc,
      String secondTitle, String secondDesc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                firstTitle,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  firstDesc,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                  ),
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
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  secondDesc,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
