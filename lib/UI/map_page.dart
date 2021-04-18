import 'dart:convert';

import 'package:bamboo/UI/map_location.dart';
import 'package:bamboo/UI/userPage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'cameraPage.dart';
import 'information_page.dart';

class GoogleMapScreen extends StatefulWidget {
  var user;
  GoogleMapScreen({Key key, this.user}) : super(key: key);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  var _currentIndex = 1;
  String valueChoose;
  List listData = [
    {"common_name": ""},
    {"common_name": ""}
  ];
  List listItem = ["apple", "cat", "dog", "bananna", "elephent"];
  var result;
  _getPageData() async {
    var api = 'http://140.123.94.131:8800/map/all';
    print(api);
    final result = await http.get(api);
    if (result.statusCode == 200) {
      setState(() {
        listData = json.decode(result.body);
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    print("456");
    _getPageData();
    result = valueChoose == "123" ? valueChoose : "無";
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
              child: Column(
            children: [
              SizedBox(
                height: height * 0.3,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: DropdownButton(
                    hint: Text("挑選您想要查看的植物: "),
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 36,
                    isExpanded: true,
                    underline: SizedBox(),
                    style: TextStyle(color: Colors.black, fontSize: 22),
                    dropdownColor: Colors.white,
                    value: valueChoose,
                    onChanged: (newValue) {
                      setState(() {
                        valueChoose = newValue;
                        result = valueChoose;
                      });
                    },
                    items: listData.map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem["common_name"],
                        child: Text(valueItem["common_name"]),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "您選擇的是: " + result,
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                height: 22,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    if (valueChoose != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapLocationPage(
                                  user: widget.user, plant: valueChoose)));
                    }
                  });
                },
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                child: Text(
                  "確認",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                color: Theme.of(context).primaryColor,
              )
            ],
          ))),
      appBar: AppBar(
        title: Text(
          "探索頁面",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
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
                      builder: (context) => InformationPage(
                            user: widget.user,
                          )));
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
}
