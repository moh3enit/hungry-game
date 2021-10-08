import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_challenge_app/constants.dart';
import 'package:restaurant_challenge_app/model/notifier.dart';
import 'package:restaurant_challenge_app/model/users.dart';
import 'package:restaurant_challenge_app/screens/auth_screen.dart';
import 'package:restaurant_challenge_app/screens/game/result_gmae_screen.dart';
import 'package:restaurant_challenge_app/screens/game/info_challenge_screen.dart';
import 'package:restaurant_challenge_app/static_methods.dart';


class LoginChallengeRoom extends StatefulWidget {
  static String id = 'login_challenge_room';

  @override
  _LoginChallengeRoomState createState() => _LoginChallengeRoomState();
}

class _LoginChallengeRoomState extends State<LoginChallengeRoom> {
  TextEditingController codeController;
  String code;
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference dbRef =
  FirebaseDatabase.instance.reference().child('challenges');
  bool showLoadingProgress = false;

  @override
  void initState() {
    codeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFF6F5FA),
      body: ModalProgressHUD(
        inAsyncCall: showLoadingProgress,
        progressIndicator: kCustomProgressIndicator,
        child: SafeArea(
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Image(
                            width: 310.0,
                            image: AssetImage("assets/images/shape.png"),
                          )
                        ],
                      ),
                      Positioned(
                        width: size.width / 1,
                        height: size.width / 1.2,
                        child: Image(
                          image: AssetImage("assets/images/logo.png"),
                        ),
                      ),
                      IconButton(
                        iconSize: 20.0,
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.07,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400],
                          blurRadius: 5.0,
                          offset: Offset(0, 0),
                        )
                      ],
                    ),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 18.0),
                    padding:
                    EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Please Enter Challenge Code",
                          style:
                          TextStyle(fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: <Widget>[
                              TextField(
                                decoration: InputDecoration(
                                  labelText: "Code*",
                                  labelStyle: TextStyle(fontSize: 14.0),

                                ),
                                controller: codeController,
                                keyboardType: TextInputType.number,
                                maxLength: 7,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            FocusScopeNode currentFocus = FocusScope.of(
                                context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            onLoginToChallenge();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[200],
                                      blurRadius: 2.0,
                                      offset: Offset(0, 4.0))
                                ]),
                            margin: EdgeInsets.only(top: 20.0),
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            width: 200.0,
                            child: Center(
                              child: Text(
                                "Enter To Match",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12.0),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onLoginToChallenge() async {
    if (checkCode()) {
      getCodeChallenge();
    } else {
      // pass
    }
  }

  bool checkCode() {
    code = codeController.text;
    if (code.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar(
            'Enter the code', MediaQuery.of(context).size, kDialogErrorColor),
      );
      return false;
    }
    if (code.length < 7) {
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar(
            'Code length must be 7 digits', MediaQuery.of(context).size, kDialogErrorColor),
      );
      return false;
    }
    return true;
  }

  Future<bool> checkReferralCode() async {
    DataSnapshot snapshot = await dbRef.child(code).once();
    if (snapshot.value == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> checkIsActiveReferralCode() async {
    DataSnapshot snapshot = await dbRef.child(code).once();
    if (snapshot.value == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> checkIsPlayGame() async{
    DataSnapshot snapshot = await dbRef.child(code).child('users').child(auth.currentUser.uid).once();
    if( snapshot.value == null ){
      return true;
    }else{
      return false;
    }
  }

  getCodeChallenge() async {
    showLoadingProgress = true;
    setState(() {});

    bool check=await checkReferralCode();
    if(check) {
      try {
        String challengeName, city, date, time,referralCode;
        bool isActive=false;
        await dbRef.child(code)
            .once()
            .then((value) {
          challengeName = value.value['challengeName'].toString();
          city = value.value['city'].toString();
          time = value.value['time'].toString();
          date = value.value['date'].toString();
          isActive = value.value['isActive'];
          referralCode = value.value['referralCode'].toString();
          if(value.value['winner']!=null){
            Restaurant restaurant = Restaurant(
                restaurantAddress: value.value['winner']['restaurantAddress'],
                restaurantImg: value.value['winner']['restaurantImg'],
                restaurantName: value.value['winner']['restaurantName'],
                restaurantRate: value.value['winner']['restaurantRate'],
                restaurantId: value.value['winner']['restaurantId']);
            Provider.of<Notifier>(context, listen: false).changeWinnerRestaurant(restaurant);
            Provider.of<Notifier>(context, listen: false).changeWinnerRestaurantScore(value.value['winner']['restaurantScore']);
            Provider.of<Notifier>(context, listen: false).changeWinnerReview(value.value['winner']['restaurantReview']);
          }else{
            Provider.of<Notifier>(context, listen: false).changeIsSelected (false);
          }
        });
        showLoadingProgress = false;
        setState(() {});
        bool checkPlay=await checkIsPlayGame();
        if (isActive) {
          if (checkPlay){
            Provider.of<Notifier>(context, listen: false).changeLocation(city);
            Provider.of<Notifier>(context, listen: false).changeReferral(referralCode);
            Navigator.popAndPushNamed(
              context,
              InfoChallenge.id,
              arguments: {
                'challengeName': challengeName,
                'city': city,
                'time': time,
                'date': date,
                'referralCode': referralCode,
              },
            );
          }else{
            bool isPlay;
            await dbRef.child(code).child('users').child(auth.currentUser.uid)
                .once()
                .then((value) {
              isPlay = value.value['isPlay'];
            });
            if(isPlay){
              Provider.of<Notifier>(context, listen: false).changeReferral(referralCode);
              Navigator.popAndPushNamed(
                context,
                ResultGama.id,
                arguments: {
                  'challengeName': challengeName,
                  'city': city,
                  'time': time,
                  'date': date,
                  'referralCode': referralCode,
                },
              );
            }else{
              Provider.of<Notifier>(context, listen: false).changeLocation(city);
              Provider.of<Notifier>(context, listen: false).changeReferral(referralCode);
              Navigator.popAndPushNamed(
                context,
                InfoChallenge.id,
                arguments: {
                  'challengeName': challengeName,
                  'city': city,
                  'time': time,
                  'date': date,
                  'referralCode': referralCode,
                },
              );
            }
          }
        } else {
          if (checkPlay){
            ScaffoldMessenger.of(context).showSnackBar(
              StaticMethods.mySnackBar(
                  'Game no Active', MediaQuery.of(context).size, kDialogErrorColor),
            );
          } else{
            Provider.of<Notifier>(context, listen: false).changeReferral(referralCode);
            Navigator.popAndPushNamed(
              context,
              ResultGama.id,
              arguments: {
                'challengeName': challengeName,
                'city': city,
                'time': time,
                'date': date,
                'referralCode': referralCode,
              },
            );
          }
        }
      } catch (e) {
        showLoadingProgress = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          StaticMethods.mySnackBar(
              'Game not fund', MediaQuery.of(context).size, kDialogErrorColor),
        );
      }
    }
    else{
      showLoadingProgress = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar(
            'Referral Code is Wrong', MediaQuery.of(context).size, kDialogErrorColor),
      );
    }
  }
}

