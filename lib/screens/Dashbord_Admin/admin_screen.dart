import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_challenge_app/componnent/offer_dialog.dart';
import 'package:restaurant_challenge_app/constants.dart';
import 'package:restaurant_challenge_app/model/notifier.dart';
import 'package:restaurant_challenge_app/static_methods.dart';

class DashboardAdmin extends StatefulWidget {
  static String id = 'dashboardAdmin_screen';

  DashboardAdmin({Key key}) : super(key: key);

  @override
  _DashboardAdminState createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child('Advertising');
  FirebaseStorage storage = FirebaseStorage.instance;
  File imageFile;
  bool showLoadingProgress = false;
  TextEditingController descriptionController;
  bool isPlay=false;
  int visit=0;
  Map map;
  @override
  void initState() {
    getData();
    descriptionController = TextEditingController();
    super.initState();
  }

  getData() async{
    showLoadingProgress = true;
    setState(() {});
    DataSnapshot snapshot = await dbRef.once();
    if (snapshot.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar(
            'There is no information.', MediaQuery.of(context).size,kDialogErrorColor),
      );
    } else {
      await dbRef.once().then((DataSnapshot snapshot) {
        map=snapshot.value;
        isPlay=map['isEnable'];
        visit=map['visit'];
        setState(() {});
      });
    }
    showLoadingProgress = false;
    setState(() {});
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void _clear() {
    setState(() {
      imageFile = null;
      isPlay=true;
      visit=0;
    });
  }

  selectFromGallery() {
    _pickImage(ImageSource.gallery);
    Navigator.pop(context);
  }

  selectFromCamera() {
    _pickImage(ImageSource.camera);
    Navigator.pop(context);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final _picker = ImagePicker();
      PickedFile image = await _picker.getImage(source: source);

      final File selected = File(image.path);

      setState(() {
        imageFile = selected;
      });
    } catch (e) {
      print(e);
    }
  }

  void onSelectImagePressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StaticMethods.myAlertDialog(selectFromCamera, selectFromGallery);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('Ad Management '),
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              showOfferDialog(context, map['description'], map['img']);
            },
            icon: Icon(Icons.visibility_rounded,color: kColorWhite,),
            label: Text(
              '$visit',
              style: TextStyle(
                color: kColorWhite,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              setState(() {
                isPlay=!isPlay;
              });
              Provider.of<Notifier>(context, listen: false).changeIsPlayAd(
                  isPlay);
              onPlayAndPouse();
            },
            icon: Icon(
              isPlay==false
                  ? Icons.play_circle_outline_rounded
                  : Icons.pause_circle_outline_sharp,
              size: 40.0,
              color: kColorWhite,
            ),
            label: Text(
              '${isPlay==false ? 'OFF' : 'ON'}',
              style: TextStyle(
                color: kColorWhite,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: showLoadingProgress,
        progressIndicator: kCustomProgressIndicator,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 5.0 / 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CustomAvatar(
                    onImageSelectPressed: () {
                      onSelectImagePressed();
                    },
                    imageFile: imageFile,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 5.0 / 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    cursorColor: Colors.white,
                    minLines: 7,
                    maxLines: 7,
                    keyboardType: TextInputType.text,
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description of your Ad',
                      contentPadding: EdgeInsets.all(10),
                      border: kOutLineInputBorder.copyWith(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                      focusedBorder: kOutLineInputBorder.copyWith(
                        borderSide: BorderSide(
                          color: kPrimaryColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, -5),
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.all(3.0),

                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      onAddAdsPressed();
                    },
                    child: Text(
                      'Post an Ad',
                      style: TextStyle(color: Colors.white,fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> uploadFile() async {
    showLoadingProgress = true;
    setState(() {});
    try {
      TaskSnapshot task =
          await storage.ref(imageFile.path.split('/').last).putFile(imageFile);
      final String downloadUrl = await task.ref.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    } on FirebaseException catch (e) {
      print(e);
      showLoadingProgress = false;
      setState(() {});
      return null;
    }
  }

  onPlayAndPouse() async{
    await dbRef.update({
      'isEnable': isPlay,
    });
  }

  onAddAdsPressed() async {
    String description = descriptionController.text;
    if(imageFile == null){
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar(
            'No photo selected.', MediaQuery.of(context).size,kDialogErrorColor),
      );
      return false;
    }
    if(description.length < 4){
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar(
            'No ad description entered', MediaQuery.of(context).size,kDialogErrorColor),
      );
      return false;
    }
    String resultUrl = await uploadFile();
    if(resultUrl != null){
      uploadToDatabase(description, resultUrl);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar('An Erro occured while uploading file',
            MediaQuery.of(context).size, kDialogErrorColor),
      );
      return;
    }
  }

  uploadToDatabase(String description, String imageUrl) async {
    try {
      await dbRef.set({
        'description': description,
        'img': imageUrl,
        'visit': 0,
        'isEnable': true,
      });
      setState(() {
        showLoadingProgress = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar('Ad successfully registered.',
            MediaQuery.of(context).size, kDialogSuccessColor),
      );

      _clear();
      descriptionController.clear();
    } catch (e) {
      setState(() {
        showLoadingProgress = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        StaticMethods.mySnackBar('There was a problem registering the ad',
            MediaQuery.of(context).size, kDialogErrorColor),
      );
      print(e);
    }
  }
}

class CustomAvatar extends StatelessWidget {
  final Function onImageSelectPressed;
  final File imageFile;

  CustomAvatar({@required this.onImageSelectPressed, @required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (imageFile != null) ...[
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Center(
                    child: Image(image:FileImage(imageFile),height: MediaQuery.of(context).size.height < 790 ? 370 :450,),
                  ),
                ),
              ),
            ] else ...[
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.all(50.0),
                  child: Center(
                    child: Image(
                        image: AssetImage('assets/images/background.jpg')),
                  ),
                ),
              ),
            ],
          ],
        ),
        Padding(
          padding: MediaQuery.of(context).size.height < 790
            ? EdgeInsets.only(top: 290.0, left: 5.0,bottom: 5.0)
            : EdgeInsets.only(top: 390.0, left: 5.0,bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              MaterialButton(
                onPressed: onImageSelectPressed,
                height: 70,
                shape: CircleBorder(),
                color: Colors.blue,
                child: Center(
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}