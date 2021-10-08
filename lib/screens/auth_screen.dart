import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:restaurant_challenge_app/constants.dart';
import 'package:restaurant_challenge_app/screens/Dashbord_Admin/admin_screen.dart';
import 'package:restaurant_challenge_app/screens/challenge/list_challenge.dart';
import 'package:restaurant_challenge_app/screens/login_screen.dart';
import 'package:restaurant_challenge_app/screens/login_to_challenge_room.dart';
import 'challenge/create_challenge.dart';

class AuthScreen extends StatefulWidget {
  static String id = 'auth_screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  int view=0;
  bool showLoadingProgress = false;

  Future<int> getNumberView() async {
    showLoadingProgress = true;
    DatabaseReference dbRef = FirebaseDatabase.instance.reference();
    DataSnapshot snapshot = await dbRef.child('challenges').once();
    if (snapshot.value != null) {
      Map data = snapshot.value;
      List challengeItems = [];
      data.forEach((key, value) {
        challengeItems.add(value);
      });
      challengeItems.length > 0
          ? view= challengeItems.length
          : view=0;
      showLoadingProgress = false;
      return view;
    } else {
      showLoadingProgress = false;
      return view=0;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ModalProgressHUD(
        inAsyncCall: showLoadingProgress,
        progressIndicator: kCustomProgressIndicator,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: Image(
                          image: AssetImage("assets/images/intro.png"),
                        ),
                      ),
                      if(_auth.currentUser.email=='tbonestitch@gmail.com')...[
                        Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.0),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 1,
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5.0,
                                      offset: Offset(0, 2.0))
                                ]),
                            child: TextButton.icon(
                              onPressed: () {
                                Navigator.push(context,
                                  MaterialPageRoute(
                                    builder: (context) => DashboardAdmin(),
                                  ),);
                              },
                              icon: Icon(Icons.ad_units_rounded,color: Colors.black87,),
                              label: Text(
                                "Ad",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.0),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 1,
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5.0,
                                      offset: Offset(0, 2.0))
                                ]),
                            child: TextButton.icon(
                              onPressed: () async{
                                await getNumberView();
                                setState(() {});
                              },
                              icon: Icon(Icons.visibility_rounded,color: Colors.black87,),
                              label: Text(
                                "$view",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            "My Hungry Game",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      itemBottom('Login To Game', LoginChallengeRoom()),
                      itemBottom('Create Game', ChallengeScreen()),
                      itemBottom('Dashboard Game', ListChallenge()),
                      itemBottom('Logout', LoginChallengeRoom()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector itemBottom(String title, Widget page) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case "Login To Game":
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => page,
                ),
              );
            }
            break;

          case "Create Game":
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => page,
                ),
              );
            }
            break;

          case "Dashboard Game":
            {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                builder: (context) {
                  return ListChallenge();
                },
              );
            }
            break;

          case "Logout":
            {
              _auth.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.id, (Route<dynamic> route) => false);
            }
            break;

          default:
            {
              print("Invalid choice");
            }
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 28.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 1,
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5.0,
                  offset: Offset(0, 2.0))
            ]),
        child: Center(
          child: Text(
            "$title",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
