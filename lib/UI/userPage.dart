import 'package:bamboo/UI/login.dart';
import 'package:bamboo/UI/try.dart';
import 'package:flutter/material.dart';
import 'map_page.dart';
import 'cameraPage.dart';
import 'information_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserPage extends StatefulWidget {
  var user;
  UserPage({Key key, this.user}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _currentIndex = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserContent(user: widget.user),
      appBar: AppBar(
        title: Text(
          "使用者頁面",
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
                  print("231");
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

class UserContent extends StatefulWidget {
  var user;
  UserContent({Key key, this.user}) : super(key: key);

  @override
  _UserContentState createState() => _UserContentState();
}

class _UserContentState extends State<UserContent> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.3;
    var width = MediaQuery.of(context).size.width * 0.15;
    return ListView(
      // padding: EdgeInsets.fromLTRB(width, height, , 0),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .25,
        ),
        Row(
          children: [
            SizedBox(
              width: 18,
            ),
            Icon(
              Icons.person,
              size: 50,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "使用者名稱: " + '${widget.user[0]["username"]}',
              style: TextStyle(fontSize: 20.0),
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
        FlatButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
          child: Text(
            "登出",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          color: Theme.of(context).primaryColor,
          shape: StadiumBorder(),
        ),
      ],
    );
  }
}
