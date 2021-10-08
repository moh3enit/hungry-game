import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_challenge_app/componnent/offer_dialog.dart';
import 'package:restaurant_challenge_app/constants.dart';
import 'package:restaurant_challenge_app/model/notifier.dart';
import 'package:restaurant_challenge_app/screens/game/result_gmae_screen.dart';

class GameScreen extends StatelessWidget {
  static String id = 'game_screen';
  static Map args;
  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    bool isCheck=args['isPlayAd'];
    return Scaffold(
      backgroundColor: Color(0xFFEE9E01),
      body: SafeArea(
        child: FeatureDiscovery.withProvider(
          persistenceProvider: NoPersistenceProvider(),
          child: Game(isCheck: isCheck,),
        ),
      ),
    );
  }
}

class Game extends StatefulWidget {
  final bool isCheck;
  Game({this.isCheck});
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final DatabaseReference dbRef = FirebaseDatabase.instance.reference();
  Size size;
  int dSum = 0;
  bool end = false;
  double sum = 0;
  bool startTimer = false;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    print(widget.isCheck);
    Future.delayed(
      Duration(milliseconds: 500),
          () {
        if(widget.isCheck==true) {
          showOfferDialog(context, Provider.of<Notifier>(context, listen: false).descriptionAd, Provider.of<Notifier>(context, listen: false).imgAd);
          onUpdateVisit();
        }
      },
    );
    _init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(context,
          <String>[
            'feature1',
            'feature2',
            'feature3',
          ]
      );
    });
  }

  void _init() async {
    var duration = await player.setAsset('assets/audio.mp3');
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    double f = size.height / 470;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/background-game.jpg'),
            fit: BoxFit.fill),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 30.0),
                child: DescribedFeatureOverlay(
                  featureId: 'feature2',
                  targetColor: Colors.white,
                  textColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  contentLocation: ContentLocation.below,
                  title: Text(
                    'Countdown timer',
                    style: TextStyle(fontSize: 30.0),
                  ),
                  pulseDuration: Duration(seconds: 2),
                  enablePulsingAnimation: true,
                  overflowMode: OverflowMode.extendBackground,
                  openDuration: Duration(seconds: 2),
                  description: Text(
                    'In this section you can see \nthe remaining time of the game.',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  tapTarget: CircularCountDownTimer(
                    duration: 30,
                    initialDuration: 0,
                    controller: CountDownController(),
                    width: MediaQuery.of(context).size.width / 5,
                    height: MediaQuery.of(context).size.height / 5,
                    ringColor: Colors.grey[300],
                    ringGradient: null,
                    fillColor: Theme.of(context).primaryColor,
                    fillGradient: null,
                    backgroundColor: Colors.white,
                    backgroundGradient: null,
                    strokeWidth: 8.0,
                    strokeCap: StrokeCap.round,
                    textStyle: TextStyle(
                        fontSize: 17.0,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  child: startTimer == true
                      ? CircularCountDownTimer(
                          duration: 30,
                          initialDuration: 0,
                          controller: CountDownController(),
                          width: 75,
                          height: 75,
                          ringColor: Colors.grey[300],
                          ringGradient: null,
                          fillColor: Theme.of(context).primaryColor,
                          fillGradient: null,
                          backgroundColor: Colors.white,
                          backgroundGradient: null,
                          strokeWidth: 8.0,
                          strokeCap: StrokeCap.round,
                          textStyle: TextStyle(
                              fontSize: 17.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                          textFormat: CountdownTextFormat.S,
                          isReverse: true,
                          isReverseAnimation: false,
                          isTimerTextShown: true,
                          autoStart: true,
                          onComplete: () {
                            insertScore();
                            end = true;
                          },
                        )
                      : Container(
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: CircleAvatar(
                              radius: 34,
                              backgroundColor: kColorWhite,
                              child: Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(
                    top: (size.height / 2) - sum,
                  ),
                  child: Lottie.asset('assets/53947-sushi.json',
                      height: 170, width: 170)),
              Container(
                margin: EdgeInsets.only(top: 30.0),
                child: DescribedFeatureOverlay(
                  featureId: 'feature3',
                  targetColor: Colors.white,
                  textColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  contentLocation: ContentLocation.below,
                  title: Text(
                    'Points taken',
                    style: TextStyle(fontSize: 30.0),
                  ),
                  pulseDuration: Duration(seconds: 2),
                  enablePulsingAnimation: true,
                  overflowMode: OverflowMode.extendBackground,
                  openDuration: Duration(seconds: 2),
                  description: Text(
                      'In this section, you can see the points collected in the game.',
                      style: TextStyle(fontSize: 17.0)),
                  tapTarget: CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Color.fromRGBO(37, 100, 138, 0.99),
                    child: CircleAvatar(
                      radius: 34,
                      backgroundColor: kColorWhite,
                      child: Text(
                        '0',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Color.fromRGBO(37, 100, 138, 0.99),
                    child: CircleAvatar(
                      radius: 34,
                      backgroundColor: kColorWhite,
                      child: Text(
                        dSum.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(37, 100, 138, 0.99),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          DescribedFeatureOverlay(
            featureId: 'feature1',
            targetColor: Colors.white,
            textColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
            contentLocation: ContentLocation.above,
            title: Text(
              'On Tap Here',
              style: TextStyle(fontSize: 30.0),
            ),
            pulseDuration: Duration(seconds: 2),
            enablePulsingAnimation: true,
            overflowMode: OverflowMode.extendBackground,
            openDuration: Duration(seconds: 2),
            description: Text('Tap here repeatedly to earn points and move the food up to the plates',style: TextStyle(fontSize: 17.0)),
            tapTarget: Container(
              child: Lottie.asset(
                  'assets/food1.json',
                  height: 200,
                  width: 200),
            ),
            child: InkWell(
              onTap: () {
                player.play();
                startTimer = true;
                if (!end) {
                  dSum += 2;
                  sum += f;
                  setState(() {});
                } else {
                  insertScore();
                }
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 30.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: kColorWhite,
                  child: Lottie.asset(
                      'assets/food1.json',
                      height: 550,
                      width: 550),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  insertScore() async {
    try {
      await dbRef.child('challenges')
          .child(Provider.of<Notifier>(context, listen: false).referral)
          .child('users')
          .child(auth.currentUser.uid)
          .update({
        'isPlay': true,
        'score': dSum,
      });
      player.stop();
      Navigator.popAndPushNamed(
        context,
        ResultGama.id,
      );
    } catch (e) {
      print(e);
    }
  }

  onUpdateVisit() async{
    int visit=Provider.of<Notifier>(context, listen: false).visitAd;
    await dbRef.child('Advertising').update({
      'visit': visit+1,
    });
  }

}
