import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:restaurant_challenge_app/screens/login_screen.dart';
import 'package:restaurant_challenge_app/screens/reset_password_phone_screen.dart';
import '../constants.dart';
import '../static_methods.dart';

class ResetPasswordEmailScreen extends StatefulWidget {
  static String id = 'reset_password_email_screen';

  @override
  _ResetPasswordEmailScreenState createState() => _ResetPasswordEmailScreenState();
}

class _ResetPasswordEmailScreenState extends State<ResetPasswordEmailScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController emailController;

  Size size;
  FocusNode node;
  String email;

  bool showLoadingProgress = false;

  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    node = FocusScope.of(context);

    return Scaffold(
      backgroundColor: kColorWhite,
      body: ModalProgressHUD(
        inAsyncCall: showLoadingProgress,
        progressIndicator: kCustomProgressIndicator,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                    children: [
                      Text(
                        "Reset Password Using Email",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold,color: Colors.black87),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Email*",
                                labelStyle: TextStyle(fontSize: 14.0),
                                suffixIcon: Icon(
                                  Icons.email,
                                  size: 17.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      GestureDetector(
                        onTap: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          onResetPassword();
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
                              "Send Request",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
                                Text("Or Reset Password using",
                                    style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,)),
                                SizedBox(width: 5.0),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ResetPasswordPhoneScreen()));
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
                          )),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
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

  bool isValid() {
    email = emailController.text;
    if (email.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar('Please Fill email',
            MediaQuery.of(context).size, kDialogErrorColor),
      );
      return false;
    }

    return true;
  }

  sendRequest() async {
    showLoadingProgress = true;
    setState(() {});
    try {
      auth.sendPasswordResetEmail(email: email);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar('Request has been sent to your Email',
            MediaQuery.of(context).size, kDialogSuccessColor),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar(
            'Wrong Email', MediaQuery.of(context).size, kDialogErrorColor),
      );
      print('myError: $e');
      showLoadingProgress = false;
      setState(() {});
    }
  }

  onResetPassword() {
    if (isValid()) {
      sendRequest();
    } else {}
  }
}
