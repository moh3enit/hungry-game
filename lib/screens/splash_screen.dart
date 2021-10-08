import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_challenge_app/constants.dart';
import 'package:restaurant_challenge_app/screens/auth_screen.dart';
import 'package:restaurant_challenge_app/screens/login_screen.dart';

class Splash extends StatefulWidget {
  static String id = 'splash_screen';

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin{
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _visible = true;
  Animation<double> _animation;
  AnimationController _controller;
  getUser() async{
    User user = auth.currentUser;
    if (user != null) {
      Navigator.popAndPushNamed(
        context,
        AuthScreen.id,
      );
    } else {
      Navigator.popAndPushNamed(
        context,
        LoginScreen.id,
      );
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3050),
      vsync: this,
    )..repeat();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    Future.delayed(
      Duration(milliseconds: 500),
          () {
        setState(() => _visible = !_visible);
      },
    );    Future.delayed(
      Duration(seconds: 3),
          () {
        getUser();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedOpacity(
              // If the widget is visible, animate to 0.0 (invisible).
              // If the widget is hidden, animate to 1.0 (fully visible).
              opacity: _visible ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 1700),
              // The green box must be a child of the AnimatedOpacity widget.
              child: CircleAvatar(
                backgroundColor: kColorWhite.withOpacity(0.15),
                backgroundImage: AssetImage("assets/images/logo.png"),
                radius: 110,
                child: SizedBox(),
              ),
            ),
            SizeTransition(
              sizeFactor: _animation,
              axis: Axis.horizontal,
              axisAlignment: -1,
              child: Text(
                "My Hungry Game",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: kColorWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}