import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:restaurant_challenge_app/screens/auth_screen.dart';
import 'package:restaurant_challenge_app/screens/login_screen.dart';
import 'package:restaurant_challenge_app/screens/register_phone_screen.dart';
import '../constants.dart';
import '../static_methods.dart';


class RegisterEmailScreen extends StatefulWidget {
  static String id = 'register_email_screen';

  @override
  _RegisterEmailScreenState createState() => _RegisterEmailScreenState();
}



class _RegisterEmailScreenState extends State<RegisterEmailScreen> {

  TextEditingController emailController,fullNameController, passwordController, rePasswordController;
  String fullName, email, password, rePassword;
  bool showLoadingProgress = false;
  bool _hidePassword = true;


  final auth = FirebaseAuth.instance;
  // User user;



  getUser() {
    User user = auth.currentUser;
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
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    rePasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kColorWhite,
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
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.06,
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
                          "Register Account Using Email Address",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
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
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: "Email*",
                                    labelStyle: TextStyle(fontSize: 14.0),
                                    suffixIcon: Icon(
                                      Icons.email,
                                      size: 20.0,
                                    )
                                ),
                              ),
                              TextField(
                                controller: passwordController,
                                obscureText: _hidePassword,
                                decoration: InputDecoration(
                                    labelText: "Password*",
                                    labelStyle: TextStyle(fontSize: 14.0),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _hidePassword = !_hidePassword;
                                        });
                                      },
                                      icon: Icon(
                                        _hidePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: 17.0,
                                      ),
                                    )),
                              ),
                              TextField(
                                controller: rePasswordController,
                                obscureText: _hidePassword,
                                decoration: InputDecoration(
                                    labelText: "confirm password*",
                                    labelStyle: TextStyle(fontSize: 14.0),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _hidePassword = !_hidePassword;
                                        });
                                      },
                                      icon: Icon(
                                        _hidePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: 17.0,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        GestureDetector(
                          onTap: () {
                            FocusScopeNode currentFocus =
                            FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            onSignUpPressed();
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
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
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
                                            RegisterPhoneScreen()));
                              },
                              child: Text(
                                "Phone Number",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                              ),
                            )
                          ],
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
  bool isValid() {
    email = emailController.text;
    password = passwordController.text;
    rePassword = rePasswordController.text;
    fullName = fullNameController.text;
    if (email.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar('Please Fill Email', MediaQuery.of(context).size, kDialogErrorColor),
      );
      return false;
    }
    if (fullName.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar('Please Fill FullName', MediaQuery.of(context).size, kDialogErrorColor),
      );
      return false;
    }
    if (password.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar('Please Fill password', MediaQuery.of(context).size, kDialogErrorColor),
      );
      return false;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar('Please Enter a Password of More Than 6 Digits', MediaQuery.of(context).size, kDialogErrorColor),
      );
      return false;
    }
    if (password != rePassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar('Password and confirm password does not match', MediaQuery.of(context).size, kDialogErrorColor),
      );
      return false;
    }
    return true;
  }

  uploadInfo() async {
    showLoadingProgress = true;
    setState(() {});
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userCredential != null) {
        userCredential.user.updateDisplayName(fullNameController.text);
        Navigator.of(context).pushNamedAndRemoveUntil(
            AuthScreen.id, (Route<dynamic> route) => false);
      } else {
        print('user is null');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar('There is a Problem', MediaQuery.of(context).size, kDialogErrorColor),
      );
      print('myError: $e');
      showLoadingProgress = false;
      setState(() {});
    }
  }

  onSignUpPressed() {
    if (isValid()) {
      uploadInfo();
    } else {
      // pass
    }
  }

  uploadToDatabase() async {
    try{
      setState(() {});
      Navigator.of(context).pushNamedAndRemoveUntil(
          AuthScreen.id, (Route<dynamic> route) => false);
      showLoadingProgress = false;
    }
    catch(e){
      showLoadingProgress = false;
      setState(() {});
      StaticMethods.showErrorDialog(context: context, text: 'sth went wrong');
      print(e);
    }
  }

}
