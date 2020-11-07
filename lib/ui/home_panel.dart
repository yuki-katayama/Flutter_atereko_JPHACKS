import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:fluttervoicegame/page/play_page.dart';

class HomePanel extends StatelessWidget {
  int level;
  String course;

  double width = 220;
  double height = 80;
  String text = 'sss';
  IconData icon = Icons.person_outline;
  Color color = Colors.green;
  Color textColor = Colors.white;
  Color iconColor;
  double iconSize = 40.0;
  List<String> imageList = [
    "assets/icons/sneak.png",
    "assets/icons/zebra2.png",
    "assets/icons/lion.png",
    "assets/icons/rabbit.png",
    "assets/icons/tiger.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/play_back.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(height: 15),
                gameStageButton(context, 'レベル１', 'easy', 1, Colors.green),
                SizedBox(height: 15),
                gameStageButton(context, 'レベル2', 'easy', 2, Colors.red),
                SizedBox(height: 15),
                gameStageButton(context, 'レベル3', 'easy', 3, Colors.purple),
                SizedBox(height: 15),
                gameStageButton(context, 'レベル4', 'easy', 4, Colors.orangeAccent),
                SizedBox(height: 15),
                gameStageButton(context, 'レベル5', 'easy', 5, Colors.cyan),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget gameStageButton(BuildContext context, text, course, level, color) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PlayPage(level: level, course: course)),
        );
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text("基本的な早口言葉レベル\n"
                    "ボスを倒してください"),
                children: [
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context),
                    child: Text("開始"),
                  ),
                ],
              );
            });
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(0.0, 20.0),
                  blurRadius: 30.0,
                  color: Colors.black12)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(22.0),
                topLeft: Radius.circular(42.0),
                bottomRight: Radius.circular(22.0),
                bottomLeft: Radius.circular(42.0))),
        child: Row(
          children: <Widget>[
            Container(
              height: height,
              width: width - 45.0,
              alignment: Alignment.center,
              //padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              child: Text(
                '${text}',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .apply(color: textColor),
              ),
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(42.0),
                      topLeft: Radius.circular(42.0),
                      bottomRight: Radius.circular(width))),
            ),
            Image.asset(imageList[level - 1],width: 40,height: 50,)
          ],
        ),
      ),
    );
  }
}
