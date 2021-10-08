import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

showHelpDialog(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              child: TestPage(),
            ),
          ),
        );
      });
}

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  var image;
  var pageIndex = 0;
  var numberOfOnBoardScreens = 7;
  var swipeLeft = false;

  var data = [
    [
      'assets/images/2.png',
    ],
    [
      'assets/images/3.png',
    ],
    [
      'assets/images/4.png',
    ],
    [
      'assets/images/5.png',
    ],
    [
      'assets/images/6.png',
    ],
    [
      'assets/images/7.png',
    ],
    [
      'assets/images/1.png',
    ],
  ];

  handleClick(direction) {
    if (direction == -1) //moving left
    {
      if (pageIndex > 0) {
        setState(() {
          pageIndex -= 1;
        });
      }
    } else if (numberOfOnBoardScreens - 1 > pageIndex) {
      setState(() {
        pageIndex += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GestureDetector(
          onPanEnd: (details) {
            if (swipeLeft) {
              handleClick(1);
            } else
              handleClick(-1);
          },
          onPanUpdate: (details) {
            if (details.delta.dx > 0) {
              swipeLeft = false;
            } else {
              swipeLeft = true;
              if (pageIndex == 6) Navigator.pop(context);
            }
          },
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    'Page guide',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.cancel, color: Colors.black87, size: 25),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Expanded(
              child: Image.asset(
                data[pageIndex][0],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left_rounded,
                        color: Colors.black87, size: 40),
                    onPressed: () => handleClick(-1),
                  ),
                  Text('Swipe',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  IconButton(
                    icon: Icon(Icons.chevron_right_rounded,
                        color: Colors.black87, size: 40),
                    onPressed: () => handleClick(1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
