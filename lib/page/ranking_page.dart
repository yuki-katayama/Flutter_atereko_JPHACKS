import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {

  final userList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ranking_back.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').orderBy('killCount',descending:true).snapshots(),
          builder: (context, snapshot) {
            return (!snapshot.hasData)
                ? Container()
                :ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    CourseCard(
                        subtitle: index + 1.toInt(),
                        title: snapshot.data.docs[index].get('name'),
                        trailing: snapshot.data.docs[index].get('killCount'),
                      ),
                  ],
                );
              },
            );
          }
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final int subtitle;
  final String title;
  final int trailing;
  const CourseCard({
    Key key,
    @required this.subtitle,
    @required this.title,
    @required this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            trailing: Container(
              child: Text('倒した敵数:  $trailing'),
            ),
            leading: Container(
              width: 60,
              height: 60,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child:  Image.asset(
                'assets/images/ranking.png',
                fit: BoxFit.contain,
              ),
            ),
            title: Text('$title'),
            subtitle: Text('$subtitle位'),
          ),
        ),
      );
  }
}