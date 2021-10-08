import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_challenge_app/componnent/base_ticket_widget.dart';
import 'package:restaurant_challenge_app/constants.dart';
import 'package:restaurant_challenge_app/model/field_notifier.dart';
import 'package:restaurant_challenge_app/model/notifier.dart';
import 'package:restaurant_challenge_app/screens/auth_screen.dart';

import '../../static_methods.dart';
import 'manage.dart';
import '../date_picker/date_picker_widget.dart';
import '../date_picker/time_picker_widget.dart';

class ChallengeScreen extends StatefulWidget {
  static String id = 'ChallengeScreen';

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final _auth = FirebaseAuth.instance;
  int _currentStep = 0;
  TextEditingController cityEditingController,stateEditingController,challengeNameController;
  StepperType stepperType = StepperType.vertical;
  Random random = Random();
  String name,date,time,referral,city,date2,time2;
  bool showLoadingProgress = false;

  @override
  void initState() {
    Provider.of<FieldNotifier>(context,listen: false).changeDate(null);
    Provider.of<FieldNotifier>(context,listen: false).changeTime(null);
    cityEditingController = TextEditingController();
    stateEditingController = TextEditingController();
    challengeNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    cityEditingController.dispose();
    stateEditingController.dispose();
    challengeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: ModalProgressHUD(
        inAsyncCall: showLoadingProgress,
        progressIndicator: kCustomProgressIndicator,
        child: SafeArea(
          child: Center(
            child: BaseTicketWidget(
              width: size.width / 1.15,
              height: size.height / 1.20,
              isCornerRounded: true,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          iconSize: 20.0,
                          icon: Icon(Icons.arrow_back_ios),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                'Create Invitation',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 44,
                            minHeight: 44,
                            maxWidth: 64,
                            maxHeight: 64,
                          ),
                          child: Image.asset("assets/icons/fastfood.png",
                              fit: BoxFit.cover),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Stepper(
                        type: stepperType,
                        physics: ScrollPhysics(),
                        currentStep: _currentStep,
                        onStepTapped: (step) => tapped(step),
                        onStepContinue: continued,
                        onStepCancel: cancel,
                        steps: <Step>[
                          Step(
                            title: Text('Game Name'),
                            content: Column(
                              children: <Widget>[
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Game Name'),
                                  controller: challengeNameController,
                                ),
                              ],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 0
                                ? StepState.complete
                                : StepState.disabled,
                          ),
                          Step(
                            title: Text('Date You Want To Go To The Restaurant'),
                            content: Column(
                              children: <Widget>[
                                DatePickerWidget(),
                              ],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 1
                                ? StepState.complete
                                : StepState.disabled,
                          ),
                          Step(
                            title: Text('Time You Want To Go To The Restaurant'),
                            content: Column(
                              children: <Widget>[
                                TimePickerWidget(),
                              ],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 2
                                ? StepState.complete
                                : StepState.disabled,
                          ),
                          Step(
                            title: Text('City Name'),
                            content: Column(
                              children: <Widget>[
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'State Name'),
                                  controller: stateEditingController,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'City Name'),
                                  controller: cityEditingController,
                                ),
                              ],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 3
                                ? StepState.complete
                                : StepState.disabled,
                          ),
                          Step(
                            title: Text('Final confirmation of information'),
                            content: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit_rounded,),
                                  label:Text('Game Name:',style: TextStyle(fontSize: 16.0,color:Colors.blueAccent,fontWeight: FontWeight.bold),),
                                ),
                                Text('${challengeNameController.text}',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                                Row(
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.date_range,),
                                      label:Text('Date: ',style: TextStyle(fontSize: 16.0,color:Colors.blueAccent,fontWeight: FontWeight.bold),),
                                    ),
                                    Text('$date',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.timer,),
                                      label:Text('Time: ',style: TextStyle(fontSize: 16.0,color:Colors.blueAccent,fontWeight: FontWeight.bold),),
                                    ),
                                    Text('$time',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.location_city,),
                                  label:Text('City, State: ',style: TextStyle(fontSize: 16.0,color:Colors.blueAccent,fontWeight: FontWeight.bold),),
                                ),
                                Text('${cityEditingController.text}, ${stateEditingController.text.toUpperCase()}',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                              ],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 4
                                ? StepState.complete
                                : StepState.disabled,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() async{
    if (_currentStep == 0) {
      if(challengeNameController.text.length == 0){
        ScaffoldMessenger.of(context).showSnackBar(
          StaticMethods.mySnackBar(
              'Enter your Game Name', MediaQuery.of(context).size,kDialogErrorColor),
        );
        return false;
      }
      if(challengeNameController.text.length < 6){
        ScaffoldMessenger.of(context).showSnackBar(
          StaticMethods.mySnackBar(
              'The Game name must be at least 6 characters long', MediaQuery.of(context).size,kDialogErrorColor),
        );
        return false;
      }
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
    if (_currentStep == 1) {
      print(Provider.of<FieldNotifier>(context, listen: false).date);
      if (Provider.of<FieldNotifier>(context, listen: false).date == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          StaticMethods.mySnackBar('Specify the date of the game', MediaQuery.of(context).size, kDialogErrorColor),
        );
        return false;
      }
    }
    if (_currentStep == 2) {
      if (Provider.of<FieldNotifier>(context, listen: false).time == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          StaticMethods.mySnackBar('Specify the game time', MediaQuery.of(context).size, kDialogErrorColor),
        );
        return false;
      }
    }
    if (_currentStep == 3) {
      if(cityEditingController.text.length < 2){
        ScaffoldMessenger.of(context).showSnackBar(
          StaticMethods.mySnackBar(
              'Enter the name of the City', MediaQuery.of(context).size, kDialogErrorColor),
        );
        return false;
      }
      if(stateEditingController.text.length < 1){
        ScaffoldMessenger.of(context).showSnackBar(
          StaticMethods.mySnackBar(
              'Enter the name of the State', MediaQuery.of(context).size, kDialogErrorColor),
        );
        return false;
      }
      date=dateChallenge();
      time=timeChallenge();
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
    if(_currentStep == 4){
      showLoadingProgress = true;
      bool check=await createChallenge();
      if(check){
        Provider.of<Notifier>(context, listen: false).changeReferral(referral);
        Provider.of<Notifier>(context, listen: false).changeIsStartPlay(false);
        Provider.of<Notifier>(context, listen: false).changeIsEndPlay(false);
        String _city="${cityEditingController.text}, ${stateEditingController.text.toUpperCase()}";
        showLoadingProgress = false;
        Navigator.popAndPushNamed(
          context,
          ChallengeManagement.id,
          arguments: {
            'challengeName': challengeNameController.text,
            'city': _city,
            'time': time,
            'date': date,
            'show': false,
          },
        );
      }else{
        showLoadingProgress = false;
      }
    } else {
      _currentStep < 4
          ? setState(() => _currentStep += 1)
          : setState(() => null);
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : setState(() => null);
  }

  String dateChallenge(){
    date=Provider.of<FieldNotifier>(context, listen: false).date.toString();
    date=date.substring(0,10);
    return date;
  }

  String timeChallenge(){
    String hour=Provider.of<FieldNotifier>(context, listen: false).time.hour.toString();
    String minute=Provider.of<FieldNotifier>(context, listen: false).time.minute.toString();
    hour.length == 1 ? hour="0"+hour : hour=hour ;
    minute.length == 1 ? minute="0"+minute : minute=minute ;
    return time="$hour:$minute";
  }

  Future<bool>createChallenge() async {
    bool check=true;
    int id=random.nextInt(9000000) + 1000000;
    String _city="${cityEditingController.text}, ${stateEditingController.text.toUpperCase()}";
    final DatabaseReference dbRef = FirebaseDatabase.instance
        .reference()
        .child('challenges').child(id.toString());
    await dbRef.set(
        {
          'challengeName': challengeNameController.text,
          'date': date,
          'time': time,
          'isActive': true,
          'isStartPlay': false,
          'isEndPlay': false,
          'city': _city,
          'referralCode': id,
          'creatorId': _auth.currentUser.uid,
          'filter': '${_auth.currentUser.uid}_true',
        }
    ).onError((error, stackTrace) {
      check=false;
      showLoadingProgress = false;
    });
    referral=id.toString();
    return check;
  }

}
