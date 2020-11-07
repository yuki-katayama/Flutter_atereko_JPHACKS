import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List calenderList = [];
  bool isLoading = true;
  @override
  void initState() {
    fetchCalenderList();
    super.initState();
  }

  List<Meeting> _getDataSource() {
    var meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    // final DateTime endTime = startTime.add(const Duration(hours: 2));
    for (var y = 0; y < calenderList.length; y++) {
      meetings.add(Meeting(
          calenderList[y]['killCount'].toString(),
          DateTime(calenderList[y]['year'].toInt(),
              calenderList[y]['month'].toInt(), calenderList[y]['day'].toInt()),
          DateTime(calenderList[y]['year'].toInt(),
              calenderList[y]['month'].toInt(), calenderList[y]['day'].toInt()),
          const Color(0xFF0F8644),
          false));
      print(calenderList[0]['uid']);
    }
    return meetings;
  }

  Future<void> fetchCalenderList() async {
    final _firebaseAuth = FirebaseAuth.instance.currentUser.uid;
    final calender = await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseAuth)
        .collection('calenderList')
        .get();
    for (var i = 0; i < calender.docs.length; i++) {
      if (calender.docs[i].data()['killCount'] != 0) {
        calenderList.add({
          'uid': calender.docs[i].data()['uid'],
          'killCount': calender.docs[i].data()['killCount'].toString(),
          'year': DateTime.parse(
                  calender.docs[i].data()['createAt'].toDate().toString())
              .year,
          'month': DateTime.parse(
                  calender.docs[i].data()['createAt'].toDate().toString())
              .month,
          'day': DateTime.parse(
                  calender.docs[i].data()['createAt'].toDate().toString())
              .day
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('クリア回数')),
        body: (isLoading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SfCalendar(
                view: CalendarView.month,
                dataSource: MeetingDataSource(_getDataSource()),
                monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment),
              ));
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);
  var eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
