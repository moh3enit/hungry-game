import 'package:flutter/material.dart';
import 'package:restaurant_challenge_app/screens/Dashbord_Admin/info_ad_screen.dart';

showOfferDialog(BuildContext context, String title, String imageURL) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 700,
                    child: Stack(
                      children: <Widget>[
                      Positioned.fill(
                          child: Image.network(imageURL, fit: BoxFit.cover)),
                      Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: IconButton(
                          icon:
                              Icon(Icons.cancel, color: Colors.white, size: 25),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: InkWell(
                          onTap: (){
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              builder: (context) {
                                return InfoAd();
                              },
                            );
                          },
                          child: Container(
                            child: Text('Ad',style: TextStyle(color: Colors.black87),),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(top: 10,left: 10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.white,),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 1,
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5.0,
                                      offset: Offset(0, 2.0))
                                ]),
                            child: Text(
                              "$title",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    ),
                  )
              )
          );
      });
}