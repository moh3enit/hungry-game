import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_challenge_app/screens/login_screen.dart';
import 'package:restaurant_challenge_app/screens/register_email_screen.dart';

import '../constants.dart';
import '../static_methods.dart';
import 'auth_screen.dart';


enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class RegisterPhoneScreen extends StatefulWidget {
  static String id = 'register_phone_screen';

  @override
  _RegisterPhoneScreenState createState() => _RegisterPhoneScreenState();
}

class _RegisterPhoneScreenState extends State<RegisterPhoneScreen> {
  final _auth = FirebaseAuth.instance;
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final fullNameController = TextEditingController();
  String verificationId;

  bool showLoading = false;

  String phoneNumber, fullName;


  getUser() {
    User user = _auth.currentUser;
    if (user != null) {
      StaticMethods.simplePopAndPushNavigation(
          context: context, routeName: AuthScreen.id);
    } else {
      //pass
    }
  }

  @override
  void initState() {
    Future.delayed(
      Duration(microseconds: 300),
          () {
        getUser();
      },
    );
    super.initState();
  }




  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
      await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });

      if (authCredential?.user != null) {
        _auth.currentUser.updateDisplayName(fullNameController.text);
        Navigator.of(context).pushNamedAndRemoveUntil(
            AuthScreen.id, (Route<dynamic> route) => false);
      }
    } on FirebaseAuthException {
      setState(() {
        showLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          StaticMethods.mySnackBar('Wrong OTP',
              MediaQuery.of(context).size, kDialogErrorColor),
        );
      });
    }
  }

  getMobileFormWidget(context) {
    return Column(
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
              width: MediaQuery.of(context).size.width / 1,
              height: MediaQuery.of(context).size.width / 1.2,
              child: Image(
                image: AssetImage("assets/images/logo.png"),
              ),
            ),
            IconButton(
              iconSize: 20.0,
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.06,
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
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
          child: Column(
            children: <Widget>[
              Text(
                "Register Account Using Phone Number",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                          labelText: "Full Name*",
                          labelStyle: TextStyle(fontSize: 14.0),
                          suffixIcon: Icon(
                            Icons.person,
                            size: 20.0,
                          )),
                    ),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                          labelText: "Phone Number*",
                          labelStyle: TextStyle(fontSize: 14.0),
                          suffixIcon: Icon(
                            Icons.phone,
                            size: 20.0,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  if (isValid()) {
                    setState(() {
                      showLoading = true;
                    });

                    await _auth.verifyPhoneNumber(
                      phoneNumber: phoneController.text,
                      verificationCompleted: (phoneAuthCredential) async {
                        setState(() {
                          showLoading = false;
                        });
                        //signInWithPhoneAuthCredential(phoneAuthCredential);

                      },
                      verificationFailed: (FirebaseAuthException e) async {
                        setState(() {
                          showLoading = false;
                        });
                        if (e.code == 'invalid-phone-number') {
                          print('The provided phone number is not valid.');
                        }
                      },
                      codeSent: (verificationId, resendingToken) async {
                        setState(() {
                          showLoading = false;
                          currentState =
                              MobileVerificationState.SHOW_OTP_FORM_STATE;
                          this.verificationId = verificationId;
                        });
                      },
                      codeAutoRetrievalTimeout: (verificationId) async {},
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[200],
                            blurRadius: 2.0,
                            offset: Offset(0, 4.0))
                      ]),
                  margin: EdgeInsets.only(top: 20.0),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "SEND",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Or Register using",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 5.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RegisterEmailScreen()));
                          },
                          child: Text(
                            "Email Address",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        )
      ],
    );
  }

  getOtpFormWidget(context) {
    return Column(
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
              width: MediaQuery.of(context).size.width / 1,
              height: MediaQuery.of(context).size.width / 1.2,
              child: Image(
                image: AssetImage("assets/images/logo.png"),
              ),
            ),
            IconButton(
              iconSize: 20.0,
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.06,
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
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
          child: Column(
            children: <Widget>[
              Text(
                "Please Enter your OTP",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: otpController,
                      decoration: InputDecoration(
                          labelText: "Enter OTP*",
                          labelStyle: TextStyle(fontSize: 14.0),
                          suffixIcon: Icon(
                            Icons.mail,
                            size: 17.0,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  PhoneAuthCredential phoneAuthCredential =
                  PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: otpController.text);
                  signInWithPhoneAuthCredential(phoneAuthCredential);
                  // uploadToDatabase(phoneController.text, fullNameController.text);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Theme.of(context).primaryColor,
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
                      "VERIFY",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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
    );
  }

  bool isValid() {
    phoneNumber = phoneController.text;
    fullName = fullNameController.text;

    if (phoneNumber.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar(
            'Please Fill PhoneNumber', MediaQuery.of(context).size, kDialogErrorColor),
      );
      return false;
    }
    if (fullName.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar(
            'Please Fill Full Name', MediaQuery.of(context).size, kDialogErrorColor),
      );
      return false;
    }
    if (phoneNumber.length < 13) {
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar('Wrong PhoneNumber',
            MediaQuery.of(context).size, kDialogErrorColor),
      );
      return false;
    }
    return true;
  }


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: showLoading
                  ? SizedBox(
                height: MediaQuery.of(context).size.height / 1.2,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF5715)),
                  ),
                ),
              )
                  : currentState ==
                  MobileVerificationState.SHOW_MOBILE_FORM_STATE
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }
}
