import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPage createState() => _StartPage();
}

class _StartPage extends State<StartPage> {
  bool dataExit = false;
  bool isloading = false;
  @override
  initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    isloading = true;
    await FirebaseAuth.instance.signInAnonymously();
    final myselfUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    if (myselfUser.exists)
      dataExit = true;
    else
      dataExit = false;
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (isloading)
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()],
              ),
            ),
          )
        : Container(
      height: EdgeInsetsGeometry.infinity.horizontal,
      width: EdgeInsetsGeometry.infinity.horizontal,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/startpage_back.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: FlatButton(
          child: Column(
            children: [
              SizedBox(height:600),
              Text("Tap to Start",
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0.0075,
                ),),
            ],
          ),
          onPressed: () {
            //ここは後で！を外す
            if (dataExit)
              Navigator.of(context).pushReplacementNamed("/bottom");
            else
              Navigator.of(context).pushReplacementNamed("/name");
          }),
    );
  }
}
