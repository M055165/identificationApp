import 'dart:io';
import 'dart:async';
import 'package:bamboo/UI/userPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import 'package:bamboo/widgets/sexy_bottom_sheet.dart';
import 'map_page.dart';
import 'cameraPage.dart';
import 'information_page.dart';
import 'package:geolocator/geolocator.dart';

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }
void postTest() async {
  // Body me list hai sirf
  print("步驟1");
  final response = await http.get(
      'https://jsonplaceholder.typicode.com/posts/1'); // Body se banega string
  print("步驟2");
  print(response.body);
}

class FetchDecode {
  List<String> diseaseNameList;
  List<String> speciesList;
  //  = http.get('124');
  String diseaseName;
  String speciesName;
  String boolBamboo;
  String boolHealth;
}

List<String> tempList = ['Test', 'TestA'];

class InfoPage extends StatefulWidget {
  final String imageData; // Location of the captured image to display
  var user;
  InfoPage({Key key, @required this.imageData, this.user}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  String value;
  String scientific_name = '辨識等待中...';
  String common_name = '辨識等待中...';
  String local_language = '辨識等待中...';
  //String location= '辨識等待中...' ;
  String basic_information = '辨識等待中...';
  String medicinal = '辨識等待中...';
  String edible = '辨識等待中...';
  String hunter = '辨識等待中...';
  String sacrifice = '辨識等待中...';
  String other = '辨識等待中...';
  String url = '';
  var _status = 'Ready';
  int _currentIndex = 0;
  String plantResult = '';
  var _data;
  String localMessageLatitude = "0.0";
  String localMessageLongtitude = "0.0";
  bool saveResult = false;
  String saveText = '';
  var resResult;
  _getData() async {
    var api = 'http://140.123.94.131:8800/medicine/name/' + plantResult;
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
        this.url = _data["local_voice"];
      });
      // print(_data["local_language"]);
    } else {
      print(result.statusCode);
    }
  }

  /**
   * 此方法返回本地文件地址
   */
  Future<File> _getLocalFile() async {
    // 获取文档目录的路径
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String dir = appDocDir.path;
    final file = new File('$dir/demo.txt');
    // print(file);
    return file;
  }

  void _getCurrentLocation() async {}

  saveData(String loc) async {
    File imageFile = new File(loc);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String encImage = base64.encode(imageBytes);
    print("上傳圖片到mysql");
    print(localMessageLatitude);
    print(encImage);
    int time = DateTime.now().millisecondsSinceEpoch;
    String t = "$time";
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      this.localMessageLatitude = "${position.latitude}";
      this.localMessageLongtitude = "${position.longitude}";
    });
    var api = 'http://140.123.94.131:8800/map/picture';
    var reqData = {
      "account": widget.user[0]["account"],
      "username": widget.user[0]["username"],
      "picture": encImage,
      "time": t,
      "plant": this.plantResult,
      "latitude": this.localMessageLatitude,
      'longtitude': this.localMessageLongtitude
    };
    print(reqData);
    print("儲存成功!00");
    this.saveText = "儲存成功!";
    final result = await http.post(api, body: reqData);
    print("儲存成功!");
    setState(() {
      resResult = json.decode(result.body);
      print(this.saveText);
    });
  }

  sendImage(String loc) async {
    File imageFile = new File(loc);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String encImage = base64.encode(imageBytes);
    // Map <String, String>  jString=  {
    //   'file': encImage,
    //   'size': '224',
    // };
    print("上傳圖片");
    var temp =
        await http.post('http://140.123.94.131:8000/api/test/', body: encImage);
    print("圖片資訊");
    print("辨識結果:" + temp.body);
    print("圖片資訊2");
    setState(() {
      this.plantResult = temp.body;
      this.plantResult = this.plantResult.trim();
      print("***********");
      print(this.plantResult);
      _getData();
    });
    DateTime now = new DateTime.now();
    //String formattedDate = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
    // print("時間：" + formattedDate);

    try {
      File f = await _getLocalFile();
      IOSink slink = f.openWrite(mode: FileMode.append);
      //slink.write(formattedDate +" \n"+ "辨識結果為:"+ temp.body+" \n" );
      slink.write(temp.body);
      //slink.write(widget.imageData +" \n"+ temp.body);
      // await fs.writeAsString('$value');
      setState(() {
        value = '';
      });
      slink.close();
    } catch (e) {
      // 写入错误
      print(e);
    }
    File file = await _getLocalFile();
    // 从文件中读取变量作为字符串，一次全部读完存在内存里面
    String contents = await file.readAsString();

// 清空本地保存的文件
    File f = await _getLocalFile();
    await f.writeAsString('');
  }

// 清空本地保存的文件
  void _clearContent() async {
    File f = await _getLocalFile();
    await f.writeAsString('');
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
    await audioPlayer.play(url);
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  // Init state me kare to har redraw pe print karna hoga
  @override
  void initState() {
    sendImage(widget.imageData);
    super.initState();
    print("sendImage");
    String INimg1 = "123" + widget.imageData;
    print(INimg1);
    initAudioPlayer();
  }

  //

  @override
  Widget build(BuildContext context) {
    print("IMG" + widget.imageData);

    return new Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        children: <Widget>[
          Container(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  child: Card(
                    child: Image.file(
                      File(widget.imageData),
                      fit: BoxFit.cover,
                    ),
                    // child: Image(
                    //   image: Image.file(widget.imageLocation);
                    // ),
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.14,
                    color: Colors.green,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              local_language== ""
                                  ? "鄒族名:目前無資料"
                                  : "鄒族名:$local_language",
                              style: TextStyle(
                                fontSize: 20.0,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              '俗名:$common_name',
                              style: TextStyle(
                                fontSize: 20.0,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            play();
                          },
                          iconSize: 25.0,
                          icon: Icon(Icons.volume_down),
                        ),
                        IconButton(
                          icon: Icon(Icons.get_app),
                          iconSize: 15.0,
                          onPressed: () {
                            _buildPlayer();
                            saveData(widget.imageData);

                            print("IMG DOWN");
                          },
                        ),
                        Text(
                          saveText,
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    )),
                Column(
                  children: [
                    Card(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              "學名:",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              scientific_name == ""
                                  ? "目前無資料"
                                  : "${scientific_name}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(10),
                      child: Column(
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
                              basic_information == ""
                                  ? "目前無資料"
                                  : "${basic_information}",
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
                      margin: EdgeInsets.all(10),
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
                              medicinal == "" ? "目前無資料" : "${medicinal}",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              "食用:",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              edible == "" ? "目前無資料" : "${edible}",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              "狩獵",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              hunter == "" ? "目前無資料" : "${hunter}",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              "祭儀:",
                              style: TextStyle(
                                  fontSize: 18.0,
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              sacrifice == "" ? "目前無資料" : "${sacrifice}",
                              style: TextStyle(
                                  color: Colors.green[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
                          builder: (context) =>
                              InformationPage(user: widget.user)));
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

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      setState(() {
        _status = 'Unable to launch url $url';
      });
    }
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
}

/*

class DropDownList extends StatefulWidget {
  // Lis

  final String headValue;
  final List<String> listValues;
  DropDownList(this.headValue, this.listValues);

  @override
  _DropDownListState createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
  String curValue = 'Test'; // Yahi Change hoga

  @override
  Widget build(BuildContext context) {
    print("未知動作步驟1");
    return Container(
        child: Row(
        mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(widget.headValue + " : "),
        DropdownButton(
          onChanged: (String newValue) {
            setState(
              () {
                this.curValue = newValue;
              },
            );
          },
          value: curValue,
          /* Basically List ka type change karna hai,  */
          items:
              widget.listValues.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    ));
  }
}
*/ //
