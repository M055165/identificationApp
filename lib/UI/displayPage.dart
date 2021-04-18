import 'dart:io';
import 'package:bamboo/UI/InfoPage.dart';
import 'package:bamboo/UI/userPage.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'map_page.dart';
import 'cameraPage.dart';
import 'information_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'package:bamboo/widgets/sexy_bottom_sheet.dart';

class DisplayPage extends StatefulWidget {
  final String imageLocation;
  var user;
  int type;
  DisplayPage({Key key, @required this.imageLocation, this.user, this.type})
      : super(key: key);
  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    print("顯示圖片" + widget.imageLocation);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff009100),
        title: Text('鄒族植物辨識'),
      ),
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.25,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/bg.jpg'), fit: BoxFit.cover),
              ),
            ),
          ),

          /* Now Draw the Centre frame for image */
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200,
                child: Card(
                  child: Image.file(File(widget.imageLocation)),
                  // child: Image(
                  //   image: Image.file(widget.imageLocation);
                  // ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: GradientButton(
                        gradient: Gradients.tameer,
                        callback: () {
                          if (widget.type == 1) {
                            pickImage(context, widget.user);
                          } else {
                            pickgallery(context, widget.user);
                          }
                        },
                        increaseHeightBy: 5,
                        increaseWidthBy: 5,
                        child: Text(
                          "重新",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: GradientButton(
                        callback: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InfoPage(
                                        imageData: widget.imageLocation,
                                        user: widget.user,
                                      )));
                        }, // Info page ko bas paas kar do Khatam
                        increaseHeightBy: 5,
                        increaseWidthBy: 5,
                        child: Text(
                          "送出",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // SexyBottomSheet(),
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
}
