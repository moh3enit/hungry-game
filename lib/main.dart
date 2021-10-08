import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:restaurant_challenge_app/constants.dart';
import 'package:restaurant_challenge_app/screens/Dashbord_Admin/admin_screen.dart';
import 'package:restaurant_challenge_app/screens/auth_screen.dart';
import 'package:restaurant_challenge_app/screens/challenge/ResturantList.dart';
import 'package:restaurant_challenge_app/screens/challenge/manage.dart';
import 'package:restaurant_challenge_app/screens/challenge/create_challenge.dart';
import 'package:restaurant_challenge_app/screens/game/game_screen.dart';
import 'package:restaurant_challenge_app/screens/game/result_gmae_screen.dart';
import 'package:restaurant_challenge_app/screens/game/info_challenge_screen.dart';
import 'package:restaurant_challenge_app/screens/login_screen.dart';
import 'package:restaurant_challenge_app/screens/login_to_challenge_room.dart';
import 'package:restaurant_challenge_app/screens/register_email_screen.dart';
import 'package:restaurant_challenge_app/screens/register_phone_screen.dart';
import 'package:restaurant_challenge_app/screens/reset_password_email_screen.dart';
import 'package:restaurant_challenge_app/screens/reset_password_phone_screen.dart';
import 'package:restaurant_challenge_app/screens/splash_screen.dart';

import 'model/field_notifier.dart';
import 'model/notifier.dart';
import 'screens/challenge/userScore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FieldNotifier()),
        ChangeNotifierProvider(create: (context) => Notifier()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget),
        maxWidth: 1000,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(450, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.autoScale(1000, name: TABLET),
        ],
      ),
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Splash.id,
      routes: {
        Splash.id: (context) => Splash(),
        LoginScreen.id: (context) => LoginScreen(),
        RegisterEmailScreen.id: (context) => RegisterEmailScreen(),
        RegisterPhoneScreen.id: (context) => RegisterPhoneScreen(),
        ResetPasswordEmailScreen.id: (context) => ResetPasswordEmailScreen(),
        ResetPasswordPhoneScreen.id: (context) => ResetPasswordPhoneScreen(),
        AuthScreen.id: (context) => AuthScreen(),
        ChallengeScreen.id: (context) => ChallengeScreen(),
        LoginChallengeRoom.id: (context) => LoginChallengeRoom(),
        GameScreen.id: (context) => GameScreen(),
        ChallengeManagement.id: (context) => ChallengeManagement(),
        InfoChallenge.id: (context) => InfoChallenge(),
        UserScore.id: (context) => UserScore(),
        RestaurantList.id: (context) => RestaurantList(),
        ResultGama.id: (context) => ResultGama(),
        DashboardAdmin.id: (context) => DashboardAdmin(),
      },
    );
  }
}
