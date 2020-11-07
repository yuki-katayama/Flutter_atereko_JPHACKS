import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttervoicegame/class/classes.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {

  // Future<void> changeUserData()async {
  //   await FirebaseFirestore.instance.collection('users')
  //       .doc(FirebaseAuth.instance.currentUser.uid)
  //       .update({
  //     'name': 'yukk',
  //   });
  // }

  var myselfUser;
  bool isLoading = true;
  Future<void> myselfUserData()async{
    myselfUser = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid)
        .get()
    .then((value) => Customer(
        uid: value.data()['uid'],
        createAt: value.data()['createAt'],
        killCount: value.data()['killCount'],
        name: value.data()['name'],
    ));
    setState(() {
      isLoading = false;
    });

  }

  @override
  void initState() {
    myselfUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('プロフィール'),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            child: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [],
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (!isLoading)?
                _UserProfile(myselfUser: myselfUser)
                    :Center(child: CircularProgressIndicator(),)
                // const SizedBox(height: 120)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Paint paint = Paint()..color = const Color(0xff6361f3);
    Paint paint = Paint()..color = Colors.greenAccent;
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 250.0, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// ignore: must_be_immutable
class _UserProfile extends StatelessWidget {
  var myselfUser;

  _UserProfile({
    Key key,
    @required this.myselfUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _profileText(),
        SizedBox(height: 20),
        _circleAvatar(),
        SizedBox(height: 20),
        _textListCalling(),
        SizedBox(height: 200),
      ],
    );
  }
  Widget _profileText() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SizedBox(
        child: Text(
          'Profile',
          style: TextStyle(
            fontSize: 35.0,
            letterSpacing: 1.5,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _textList({
    String text,
    String myText,
    IconData icon,
  }) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Padding(
        padding:
        const EdgeInsets.only(right: 12, left: 12, top: 14, bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Colors.lightGreen,
                ),
                Text(
                  text,
                  style: TextStyle(
                    letterSpacing: 0.8,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              myText,
              style: TextStyle(
                letterSpacing: 0.8,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
            ),
            Text(
              myText,
              style: TextStyle(
                letterSpacing: 0.8,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }

  Widget _textListCalling() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 30),
          _textList(
              text: '名前',
              myText: myselfUser.name,
              icon: Icons.emoji_people_outlined),
          const SizedBox(height: 16),
          _textList(
              text: '倒した敵数',
              myText: myselfUser.killCount.toString(),
              icon: Icons.message),
          // const SizedBox(height: 16),
        ],
      ),
    );
  }
  Widget _circleAvatar() {
    return Container(
      // width: MediaQuery.of(context).size.width / 2,
      // height: MediaQuery.of(context).size.width / 2,
      padding: EdgeInsets.all(50.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 10),
        shape: BoxShape.circle,
        color: Colors.white,
        image: DecorationImage(
            // fit: BoxFit.cover,
            image: AssetImage('assets/images/ranking.png')
        ),
      ),
    );
  }
}