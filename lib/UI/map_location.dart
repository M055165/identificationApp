import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:bamboo/UI/userPage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'cameraPage.dart';
import 'information_page.dart';
import 'map_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapLocationPage extends StatefulWidget {
  var user;
  String plant;
  MapLocationPage({Key key, this.user, this.plant}) : super(key: key);

  @override
  _MapLocationPageState createState() => _MapLocationPageState();
}

class _MapLocationPageState extends State<MapLocationPage> {
  @override
  int _currentIndex = 1;
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapSample(
        plantName: widget.plant,
      ),
      appBar: AppBar(
        title: Text(
          widget.plant,
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

class MapSample extends StatefulWidget {
  String plantName = '';
  MapSample({Key key, this.plantName}) : super(key: key);
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  // GoogleMapController mapController;
  var localMessageLatitude = 23.563266;
  var localMessageLongtitude = 120.474245;
  var latLng = LatLng(23.563266, 120.474245);
  var positonData;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      this.localMessageLatitude = position.latitude;
      this.localMessageLongtitude = position.longitude;
      latLng = LatLng(localMessageLatitude, localMessageLongtitude);
    });
  }

  int generateIds() {
    var rng = new Random();
    var randomInt;
    randomInt = rng.nextInt(100);
    return randomInt;
  }

  _getPlantData() async {
    var api = 'http://140.123.94.131:8800/map/position/${widget.plantName}';

    final result = await http.get(api);
    if (result.statusCode == 200) {
      setState(() {
        positonData = json.decode(result.body);
        for (var i = 0; i < positonData.length; i++) {
          var markerIdVal = generateIds();
          final MarkerId markerId = MarkerId(markerIdVal.toString());
          var latLng123 = LatLng(double.parse(positonData[i]["latitude"]),
              double.parse(positonData[i]["longtitude"]));

          Marker marker = Marker(
              markerId: markerId,
              position: latLng123,
              infoWindow: InfoWindow(
                  title: "植物: ${positonData[i]['plant']}",
                  snippet: "拍攝者: ${positonData[i]['username']}"));
          markers[markerId] = marker;
// you could do setState here when adding the markers to the Map
        }
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getPlantData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        zoomGesturesEnabled: true, //縮放手勢
        mapType: MapType.hybrid, //設定googlemap的顯示類型
        compassEnabled: true, //旋轉地圖時右上角是否顯示指北針，預設為true
        initialCameraPosition: CameraPosition(
            target: LatLng(localMessageLatitude, localMessageLongtitude),
            zoom: 16.0, //Camera縮放尺寸，越近數值越大，越遠數值越小，預設為0
            bearing: 30, //Camera旋轉的角度，方向為逆時針轉動，預設為0
            tilt: 0 //Camera侵斜角度
            ), //設定地圖Camera的位置
        onMapCreated: (GoogleMapController mapController) {
          _controller.complete(mapController);
        },
        markers: Set<Marker>.of(markers.values),
      ),
    );
  }

  Marker marker01 = Marker(
      markerId: MarkerId("marker01"),
      position: LatLng(24.137396, 120.6866),
      infoWindow: InfoWindow(title: "台北車站", snippet: "來自台北的車站"));
  Marker marker02 = Marker(
      markerId: MarkerId("marker02"),
      position: LatLng(23.563266, 120.474245),
      infoWindow: InfoWindow(title: "中正大學", snippet: "國立中正大學"));
  Marker marker03 = Marker(
      markerId: MarkerId("marker03"),
      position: LatLng(24.137396, 120.6866),
      infoWindow: InfoWindow(title: "台中火車站", snippet: "這是台中火車站"));
}
