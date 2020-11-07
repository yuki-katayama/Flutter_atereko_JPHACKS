import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart'; // AudioPlayerインスタンスを使う場合
import 'package:fluttervoicegame/ui/home_panel.dart';
import 'package:fluttervoicegame/widget/root.dart';
import 'dart:math';
import "dart:async";
import 'package:quiver/async.dart';
import 'package:fluttervoicegame/class/classes.dart';

final assetsAudioPlayer = AssetsAudioPlayer();

class PlayPage extends StatefulWidget {
  PlayPage({Key key, this.level, this.course}) : super(key: key);

  final int level;
  final String course;

  // アロー関数を用いて、Stateを呼ぶ
  @override
  State<StatefulWidget> createState() => _PlayPage();
}

const List<String> baseThemeList = [
  'らりるれろ',
  'たちつてと',
  'なにぬねの',
  // '生麦生米生卵',
  // '隣の客はよく柿食う客だ',
  // 'バスガス爆発',
  // '赤パジャマ黄パジャマ青パジャマ',
  // '赤巻紙青巻紙黄巻紙',
  // '老若男女',
  // '旅客機の旅客'
];

const List<String> advancedThemeList = [
  'あいうえお',
  'かきくけこ',
  'さしすせそ',
  // 'アンドロメダだぞ',
  // '肩固かったから買った肩たたき機',
  // '打者走者勝者走者一掃',
  // '専売特許許可局',
  // '新設診察室視察',
  // '著作者手術中',
  // '除雪車除雪作業中',
  // '貨客船の旅客と旅客機の旅客',
  // '骨粗鬆症訴訟勝訴'
];

const languages = const [
  const Language('Japanese', 'ja_JA'),
];

class _PlayPage extends State<PlayPage> with SingleTickerProviderStateMixin {
  SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  int _hp = 5;
  int _hpMax;
  int _count = 0;
  String _themeText = '';
  String transcription = '';
  List<String> BackgroundImageList = [];
  List<String> imageList = [];
  Language selectedLang = languages.first;
  int _start = 5;
  int _current = 5;
  int _limitsDecreaseHP = 0;
  int _stageLevel;
  bool _complete = false;
  var _sub;
  var UserData;
  // ③ カウントダウン処理を行う関数を定義
  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start), //初期値
      new Duration(seconds: 1), // 減らす幅
    );

    _sub = countDownTimer.listen(null);
    _sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds; //毎秒減らしていく
      });
    });
    // ④終了時の処理
    _sub.onDone(() {
      if (_themeText == transcription) {
        _sub.cancel();
        _current = 5;
      } else {
        stop();
        _sub.cancel();
        _current = 5;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BottomNavgationBarPage()),
        );
      }
    });
  }

  void finishTimer() {
    _sub.cancel();
    _current = 5;
  }

  Future<void> myselfUserData() async {
    UserData = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
  }

  Future<void> changeUserData(int killCount) async {
    final _firebaseUser = FirebaseAuth.instance.currentUser.uid;
    final firebaseCalenderList = await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseUser)
        .collection('calenderList')
        .orderBy('createAt', descending: true)
        .limit(1)
        .get();

    for (var i = 0; i < 1; i++) {
      DateTime latestCreateAt =
          firebaseCalenderList.docs[i].data()['createAt'].toDate();

      if (latestCreateAt.difference(DateTime.now()).inDays == 0) {
        print('createAt is matched');
        var document = firebaseCalenderList.docs[i];
        FirebaseFirestore.instance
            .collection('users')
            .doc(_firebaseUser)
            .collection('calenderList')
            .doc(document.id)
            .update({'killCount': killCount});
      } else {
        print('createAt is not matched');
        FirebaseFirestore.instance
            .collection('users')
            .doc(_firebaseUser)
            .collection('calenderList')
            .doc()
            .set({
          'uid': _firebaseUser,
          'killCount': killCount,
          'createAt': Timestamp.now()
        });
      }
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
      'killCount': killCount,
    });
  }
  
  void enemyImage(int level){
    if(widget.course == "easy")
      imageList = [
        'assets/images/level1-00_enemy.png',
        'assets/images/level1-01_enemy.png',
        'assets/images/level1-02_enemy.png',
        'assets/images/level1-03_enemy.png',
        'assets/images/level1-04_enemy.png',
      ];
  }

  void BackColor(int level) {
    if (widget.course == "easy")
      BackgroundImageList=[
        'assets/images/level1-00_back.png',
        'assets/images/level1-00_back.png',
        'assets/images/level1-00_back.png',
        'assets/images/level2-00_back.png',
        'assets/images/level2-00_back.png',
        'assets/images/level2-00_back.png'
      ];
  }

  @override
  initState() {
    super.initState();
    enemyImage(widget.level - 1);
    activateSpeechRecognizer();
    myselfUserData();
    BackColor(widget.level - 1);
    setTongueTwister(widget.level);
    if (widget.course == 'easy') {
      _stageLevel = widget.level;
      _hp = _hpMax = 3;
      // assetsAudioPlayer.open(
      //   Audio("assets/bgm_level1.mp3"),
      // );
    } else if (widget.course == 'normal') {
      _stageLevel = 2;
      // _image = imageList[widget.level];
      _hp = _hpMax = 7;
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    // _speech.setRecognitionResultHandler(attack);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);
    _speech.activate('ja_JA').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(BackgroundImageList[widget.level - 1]),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Container(
              width: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.green,
                  width: 8,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 175),
                        child: Row(
                          // ⑤現在のカウントを表示
                          children: [
                            Text(
                              "$_current秒",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () => _themeText != '終了!!'
                                ? setTongueTwister(widget.level)
                                : null,
                            child: Container(
                              child: _themeText != '終了!!' ? Icon(Icons.autorenew) : null,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                (_themeText != '終了!!') ? _themeText : '',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('HP : ',
                              style: TextStyle(
                                fontSize: 18,
                              )),
                          Text(_hp.toString(),
                              style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.red)),
                        ],
                      ),
                    ],
                  )
              ),
            ),
            Container(
              height: 280,
              child: Center(
                child: Image.asset(imageList[widget.level - 1]),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              width: 300,
              color: Colors.grey.shade200,
              child: Text(transcription),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildButton(
                    onPressed: chantButtonPermit(),
                    label: (!_isListening && _current == 5 && _hp != 0)
                        ? '詠唱開始' : (_hp == 0)
                        ? 'ホームに戻る' : '..isListening',
                  ),
                ]),
          ],
        ),
      ),
    );
  }

  Function chantButtonPermit() {
    if (!_isListening &&
        _current == 5 && _hp != 0) {
      return () {
        setState(() {
          start();
        });
      };
    } else if(_hp == 0) {
      return () {
        setState(() {
          Navigator.of(context).pushReplacementNamed("/bottom");
        });
      };
    }else {
      return null;
    }
  }

  Widget _buildButton({String label, VoidCallback onPressed}) => new Padding(
      padding: new EdgeInsets.all(12.0),
      child: new RaisedButton(
        color: Colors.cyan.shade600,
        onPressed: onPressed,
        child: new Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ));

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_MyAppState.start => result $result');
          setState(() {
            startTimer();
            _limitsDecreaseHP = 0;
            _isListening = result;
          });
        });
      });

  void cancel() =>
      _speech.cancel().then((_) => setState(() => _isListening = false));

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });

  void clear() {
    cancel();
    setState(() => transcription = '');
  }

  void attack(String text) async {
    transcription = text;
    if (_isListening) {
      await Future.delayed(Duration(milliseconds: 500));
      stop();
    }
    if (_themeText == transcription) {
      setState(() {
        finishTimer();
        stop();
        _current = 5;
        _hp = _hp - 1;
        _complete = true;
        if (_hp == 0) {
          // assetsAudioPlayer.stop();
          // assetsAudioPlayer.open(
          //   Audio("assets/enemy_level1.mp3"),
          // );
          // _image = 'assets/images/victory.png';
          _themeText = '終了!!';
          changeUserData(UserData.data()['killCount'] + 1);
          showDialog(
            context: context,
            builder: (context) {
              //最後のダイアログ
              return SimpleDialog(
                title: Text("ステージ${_stageLevel}をクリアしました！"),
                children: [
                  SimpleDialogOption(
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed("/bottom"),
                    child: Text("戻る"),
                  ),
                ],
              );
              },
          );
        }
        },
      );
    }
    setTongueTwister(widget.level);
  }

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) {
    print('_MyAppState.onRecognitionResult... $text');
    if(text == _themeText) {
      _limitsDecreaseHP += 1;
      if (_limitsDecreaseHP == 1) {
        setState(() => attack(text));
      }
    }
  }

  void onRecognitionComplete(String text) {
    print('_MyAppState.onRecognitionComplete... $text');
    setState(() {
      if(_complete){
        finishTimer();
      }
      _complete = false;
      _isListening = false;
    });
  }

  void errorHandler() => activateSpeechRecognizer();

  void setTongueTwister(int level) {
    if (level == 1) {
      int index = Random().nextInt(baseThemeList.length);
      setState(() => _themeText = baseThemeList[index]);
    }
    if (level == 2) {
      int index = Random().nextInt(advancedThemeList.length);
      setState(() => _themeText = advancedThemeList[index]);
    }
    // どちらの条件でもなかった場合
    if (level != 1 && level != 2) {
      int index = Random().nextInt(baseThemeList.length);
      setState(() => _themeText = baseThemeList[index]);
    }
  }
}
