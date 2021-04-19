import 'package:bamboo/UI/try.dart';
import 'package:bamboo/UI/userPage.dart';
import 'package:flutter/material.dart';
import 'map_page.dart';
import 'cameraPage.dart';
import 'information_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InformationPage extends StatefulWidget {
  var user;
  InformationPage({Key key, this.user}) : super(key: key);

  @override
  _Information createState() => _Information();
}

class _Information extends State<InformationPage> {
  int _currentIndex = 3;
  List data123 = [];
  List data456 = [];

  _getData() async {
    var api = 'http://140.123.94.131:8800/medicine/all';
    final result = await http.get(api);
    if (result.statusCode == 200) {
      setState(() {
        data456 = json.decode(result.body);
      });
    } else {}
  }

  _getPageData(pageNum) async {
    var api = 'http://140.123.94.131:8800/medicine/page/${pageNum}';
    print(api);
    final result = await http.get(api);
    if (result.statusCode == 200) {
      setState(() {
        data123 = json.decode(result.body);
      });
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    print(widget.user[0]['username']);
    _getData();
    _getPageData(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "知識",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        // actions: [
        //   IconButton(
        //       icon: Icon(Icons.search),
        //       color: Colors.black,
        //       iconSize: 35.0,
        //       onPressed: () {
        //         showSearch(
        //             context: context,
        //             delegate:
        //                 DataSearch(flowerData: data456, user: widget.user));
        //       })
        // ],
      ),
      body: ContentBlock(
        user: widget.user,
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
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
                    builder: (context) => GoogleMapScreen(user: widget.user)));
          } else if (index == 2) {
            pickImage(context, widget.user);
          } else if (index == 3) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InformationPage(user: widget.user)));
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
              onPressed: () {
                pickImage(context, widget.user);
              }),
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
          title:
              Text(widget.user[0]['username'], style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }
}

class ContentBlock extends StatefulWidget {
  var user;
  ContentBlock({Key key, this.user}) : super(key: key);

  @override
  _ContentBlockState createState() => _ContentBlockState();
}

class _ContentBlockState extends State<ContentBlock> {
  int page = 1;
  List _data = [];

  // _getData() async {
  //   var api = 'http://10.0.2.2:888/medicine/all';
  //   final result = await http.get(api);
  //   if (result.statusCode == 200) {
  //     setState(() {
  //       _data = json.decode(result.body);
  //     });
  //     // print(_data[0]["local_voice"]);
  //   } else {
  //     // print(result.statusCode);
  //   }
  // }

  _getPageData(pageNum) async {
    var api = 'http://140.123.94.131:8800/medicine/page/${pageNum}';
    print(api);
    final result = await http.get(api);
    if (result.statusCode == 200) {
      setState(() {
        _data = json.decode(result.body);
      });
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    _getPageData(1);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        buildGridView(context),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(Icons.navigate_before),
                onPressed: () {
                  setState(() {
                    this.page == 1 ? this.page = 1 : this.page--;
                    _getPageData(this.page);
                  });
                }),
            Text('${this.page}',style: TextStyle(
                              fontSize:
                                  20.0)),
            IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: () {
                  setState(() {
                    this.page < 13 ? this.page += 1 : this.page == 87;
                    _getPageData(this.page);
                  });
                }),
          ],
        )
      ],
    );
  }

  GridView buildGridView(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(5),
      childAspectRatio: 0.7,
      crossAxisCount: 2,
      children: <Widget>[
        for (var i = 0; i < this._data.length; i++)
          GestureDetector(
            onTap: () {
              print(321);
            },
            child: Container(
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'images/plant/${(i+1)+(this.page-1)*8}.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          _data[i]['common_name'],
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02),
                        ),
                        Text(
                          "鄒語名:" +
                              (_data[i]['local_language'] != ""
                                  ? _data[i]['local_language']
                                  : "目前無資料"),
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.more_horiz,
                              size: MediaQuery.of(context).size.height * 0.05,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContentPage123(
                                            id: _data[i]["ID"],
                                            user: widget.user,
                                          )));
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final List data = ["台灣獼猴", "台灣欒樹", "123", "456", 'apple', 'banna'];
  final selecteddata = ["apple", "123"];
  var flowerData;
  var user;
  DataSearch({this.flowerData, this.user});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    var dataList = query.split(" ");
    int datalistId = int.parse(dataList[2]);
    return ContentPage123(
      id: datalistId,
      user: user,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestion = query.isEmpty
        ? flowerData
        : flowerData.where((f) => f["common_name"].startsWith("台")).toList();
    return ListView.builder(
        itemCount: suggestion.length,
        itemBuilder: (context, index) => ListTile(
            onTap: () {
              query = suggestion[index]["common_name"] +
                  ' ' +
                  suggestion[index]["local_language"] +
                  " " +
                  "${suggestion[index]["ID"]}";
              showResults(context);
            },
            leading: Icon(Icons.date_range),
            title: Text(suggestion[index]['common_name'])));
  }
}
