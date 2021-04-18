import 'dart:io';
import 'package:bamboo/UI/displayPage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as provider;
import 'package:image_picker/image_picker.dart';
import 'information_page.dart';
import 'map_page.dart';
import 'package:bamboo/widgets/sexy_bottom_sheet.dart';

List<CameraDescription> cameras;

class CameraApp extends StatefulWidget {
  var user;
  CameraApp({Key key, this.user}) : super(key: key);

  @override
  _CameraAppState createState() => _CameraAppState();
}

void takePicture(CameraController cam, BuildContext context, user) async {
  // Generate random path
  Directory tempDir = await provider.getTemporaryDirectory();
  String tempPath = tempDir.path;
  final fPath = path.join(tempPath, '${DateTime.now()}.png');
  String Datatime;
  print(fPath);
  print("拍照" + fPath);
  await cam.takePicture(fPath);
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DisplayPage(
                imageLocation: fPath,
                user: user,
              )));
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    // siAR  = _size.
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff009100),
        title: Text('鄒族植物辨識'),
      ),
      body: Stack(
        children: <Widget>[
          ClipRect(
            child: Container(
              child: Transform.scale(
                scale: controller.value.aspectRatio / _size.aspectRatio,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 300, 0, 0),
                child: GradientButton(
                  callback: () {
                    takePicture(controller, context, widget.user);
                  },
                  increaseHeightBy: 20,
                  increaseWidthBy: 20,
                  child: Text(
                    "拍照",
                    style: TextStyle(fontSize: 20),
                  ),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InformationPage()));
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
                          builder: (context) => InformationPage()));
                }),
            title: Text("知識", style: TextStyle(fontSize: 20)),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                iconSize: 40, icon: Icon(Icons.more_horiz), onPressed: () {}),
            title: Text("更多", style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}

pickImage(BuildContext context, user) async {
  final navigator = Navigator.of(context);
  // ignore: deprecated_member_use
  File pickedImage = await ImagePicker.pickImage(source: ImageSource.camera);
  if (pickedImage != null) {
    print(pickedImage.path);
    await navigator.push(
      MaterialPageRoute(
          // ignore: missing_required_param
          builder: (context) => DisplayPage(
                imageLocation: pickedImage.path,
                user: user,
                type: 1,
              )),
    );
  }
}

pickgallery(BuildContext context, user) async {
  final navigator = Navigator.of(context);
  // ignore: deprecated_member_use
  File pickedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
  if (pickedImage != null) {
    print(pickedImage.path);
    await navigator.push(
      MaterialPageRoute(
          builder: (context) => DisplayPage(
                imageLocation: pickedImage.path,
                user: user,
                type: 2,
              )),
    );
  }
}
