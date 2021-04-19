import 'dart:async';

import 'package:bamboo/UI/userPage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'InfoPage.dart';
import 'cameraPage.dart';
import 'information_page.dart';
import 'map_page.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';

class ContentPage123 extends StatefulWidget {
  int id;
  var user;

  ContentPage123({Key key, this.id, this.user}) : super(key: key);

  @override
  _ContentPage123State createState() => _ContentPage123State();
}

class _ContentPage123State extends State<ContentPage123> {
  int _currentIndex = 3;
  Map _data;
  String scientific_name = '資料讀取中...';
  String common_name = '資料讀取中...';
  String local_language = '資料讀取中...';
  String basic_information = '資料讀取中...';
  String medicinal = '資料讀取中...';
  String edible = '資料讀取中...';
  String hunter = '資料讀取中...';
  String sacrifice = '資料讀取中...';
  String other = '資料讀取中...';
  String local_voice = '';
  String standard_photo = '';

  _getData() async {
    String idList = widget.id.toString();
    var api = 'http://140.123.94.131:8800/medicine/' + idList;
    print(api);
    final result = await http.get(api);
    if (result.statusCode == 200) {
      setState(() {
        print(result.body);
        this._data = json.decode(result.body);
        this.scientific_name = _data["scientific_name"];
        this.common_name = _data["common_name"];
        this.local_language = _data["local_language"];
        this.basic_information = _data["basic_information"];
        this.medicinal = _data["medicinal"];
        this.edible = _data["edible"];
        this.hunter = _data["hunter"];
        this.sacrifice = _data["sacrifice"];
        this.other = _data["other"];
        this.local_voice = _data["local_voice"];
        this.standard_photo = _data["standard_photo"];
      });
      // print(_data["local_language"]);
    } else {
      print(result.statusCode);
    }
  }

  //sound
  Duration position;

  AudioPlayer audioPlayer;
  PlayerState playerState = PlayerState.stopped;
  get isPlaying => playerState == PlayerState.playing;

  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  @override
  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription = audioPlayer.onPlayerStateChanged.listen(
      (s) {},
    );
  }

  Future play() async {
    print("以撥放");
    await audioPlayer.play(local_voice);
    setState(() {
      print("以撥放");
      playerState = PlayerState.playing;
    });
  }

  Widget _buildPlayer() => Container(
        padding: EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                onPressed: isPlaying ? null : () => play(),
                iconSize: 40.0,
                icon: Icon(Icons.volume_down),
                color: Colors.cyan,
              ),
            ]),
          ],
        ),
      );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
    initAudioPlayer();

    // print(_data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildListView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,
        iconSize: 40.0,
        fixedColor: Colors.blue, //選中的顏色
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            this._currentIndex = index;
            this._currentIndex = index;
            if (index == 0) {
              pickgallery(context, widget.user);
            } else if (index == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GoogleMapScreen(user: widget.user)));
            } else if (index == 2) {
              pickImage(context, widget.user);
            } else if (index == 3) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          InformationPage(user: widget.user)));
            } else if (index == 4) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserPage(user: widget.user)));
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              iconSize: 40,
              icon: Icon(Icons.photo_library),
              onPressed: () => pickgallery(context, widget.user),
              //{
              //Navigator.push(context,
              //  MaterialPageRoute(builder: (context) => ContentPage()));
              //}
            ),
            title: Text("相冊", style: TextStyle(fontSize: 20)),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                iconSize: 40,
                icon: Icon(Icons.explore),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              GoogleMapScreen(user: widget.user)));
                }),
            title: Text("探索", style: TextStyle(fontSize: 20)),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              iconSize: 40,
              icon: Icon(Icons.camera_alt),
              onPressed: () => pickImage(context, widget.user), // {
              //Navigator.push(context,MaterialPageRoute(builder: (context) =>CameraApp()));
              //}
            ),
            title: Text("相機", style: TextStyle(fontSize: 20)),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                iconSize: 40,
                icon: Icon(Icons.find_in_page),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InformationPage(
                                user: widget.user,
                              )));
                }),
            title: Text("知識", style: TextStyle(fontSize: 20)),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                iconSize: 40,
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserPage(
                                user: widget.user,
                              )));
                }),
            title: Text(widget.user[0]['username'],
                style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }

  ListView buildListView() {
    return ListView(padding: EdgeInsets.fromLTRB(10, 20, 10, 10), children: <
        Widget>[
      Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
    'images/plant/${this.widget.id}.jpg',fit: BoxFit.cover,
            ),
            Positioned(
              top: 10,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.cancel,
                  size: 35.0,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
      Container(
          height: MediaQuery.of(context).size.height * 0.15,
          color: Colors.green,
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "鄒族名: " + this.local_language,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.026,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.008,
                  ),
                  Text(
                    "植物俗名: " + this.common_name ?? "目前無資料",
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.026),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.volume_down),
                iconSize: 40.0,
                onPressed: () {
                  play();
                },
              ),
            ],
          )),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.02,
      ),
      Column(
        children: [
          Card(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "學名: ",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    this.scientific_name == "" ? "目前無資料" : this.scientific_name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            child: Column(
              textDirection: TextDirection.ltr,
              children: [
                ListTile(
                  title: Text(
                    "基本資料:",
                    style: TextStyle(
                        height: 1.0,
                        fontSize: 18.0,
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    this.basic_information == ""
                        ? "目前無資料"
                        : this.basic_information,
                    style: TextStyle(
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "藥用:",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    this.medicinal == "" ? "目前無資料" : this.medicinal,
                    style: TextStyle(
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "食用: ",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    this.edible == "" ? "目前無資料" : this.edible,
                    style: TextStyle(
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "狩獵: ",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    this.hunter == "" ? "目前無資料" : this.hunter,
                    style: TextStyle(
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "祭儀: ",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    this.sacrifice == "" ? "目前無資料" : this.sacrifice,
                    style: TextStyle(
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}
