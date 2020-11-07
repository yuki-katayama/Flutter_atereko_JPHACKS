import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttervoicegame/page/Signup/components/background.dart';
import 'Round/rounded_button.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State {
  String name = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Future saveUserData(String name) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signInAnonymously();
    final doc = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseAuth.currentUser.uid)
        .get();
    doc.then((doc) async {
      print("No such document!");
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseAuth.currentUser.uid)
          .set({
        'name': name,
        'uid': firebaseAuth.currentUser.uid,
        'killCount': 0,
        'createAt': Timestamp.now()
      });
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseAuth.currentUser.uid)
        .collection('calenderList')
        .doc()
        .set({
      'uid': firebaseAuth.currentUser.uid,
      'killCount': 0,
      'createAt': Timestamp.now()
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.03),
            Text(
              "名前を入力してください",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  background: Paint()
                    ..strokeWidth = 40.0
                    ..color = Colors.white
                    ..style = PaintingStyle.stroke
                    ..strokeJoin = StrokeJoin.round),
            ),
            Container(
              width: size.width * 0.7,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: "name",
                      hintText: "音楽 優希",
                      fillColor: Colors.white,
                      filled: true,
                      // border: OutlineInputBorder()
                  ),
                  autofocus: true,
                  onChanged: (String userName) {
                    name = userName;
                  },
                ),
              ),
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () {
                if (_formKey.currentState.validate()) {
                  saveUserData(name);
                  Navigator.of(context).pushReplacementNamed("/bottom");
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }
}

String validateName(String value) {
  if (value.length < 5)
    return 'Name must be more than 2 charater';
  else
    return null;
}
