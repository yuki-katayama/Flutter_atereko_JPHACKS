import 'package:cloud_firestore/cloud_firestore.dart';

class Customer{
  int killCount;
  String uid;
  String name;
  Timestamp createAt;
  Customer({this.uid,this.createAt,this.killCount, this.name});
}

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}