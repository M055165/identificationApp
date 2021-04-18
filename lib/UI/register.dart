import 'dart:convert';

import 'package:bamboo/UI/ProgressHUD.dart';
import 'package:bamboo/UI/login.dart';
import 'package:bamboo/UI/register_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cameraPage.dart';
import 'information_page.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  bool hidePassword = true;
  bool hidePasswordagain = true;
  RegisterRequestModel requestModel;
  bool isApiCallProcess = false;
  String registerResult = '';
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  var data;
  @override
  void initState() {
    super.initState();
    requestModel = new RegisterRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSteup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSteup(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity * 2,
                  // height: MediaQuery.of(context).size.height * 0.88,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).hintColor.withOpacity(0.2),
                            offset: Offset(0, 10),
                            blurRadius: 20)
                      ]),
                  child: Form(
                    key: globalFormKey,
                    child: Column(
                      children: [
                        SizedBox(height: 0),
                        Text(
                          "註冊",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(
                          height: 0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          onSaved: (input) => requestModel.account = input,
                          validator: (input) =>
                              input.length < 8 ? "帳號至少需要8個字元以上" : null,
                          decoration: InputDecoration(
                              hintText: "請輸入使用者帳號 ",
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.2))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor)),
                              prefixIcon: Icon(
                                Icons.account_circle,
                                color: Theme.of(context).accentColor,
                              )),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        TextFormField(
                          controller: _pass,
                          keyboardType: TextInputType.text,
                          obscureText: this.hidePassword,
                          onSaved: (input) => requestModel.password = input,
                          validator: (input) =>
                              input.length < 8 ? "密碼至少需要8個字元以上" : null,
                          decoration: InputDecoration(
                              hintText: "請輸入使用者密碼",
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.2))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor)),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).accentColor,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    this.hidePassword = !this.hidePassword;
                                  });
                                },
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.4),
                                icon: Icon(hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              )),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        TextFormField(
                          controller: _confirmPass,
                          keyboardType: TextInputType.text,
                          obscureText: this.hidePasswordagain,
                          onSaved: (input) => requestModel.password = input,
                          validator: (input) =>
                              input == _pass.text ? null : "密碼不一致",
                          decoration: InputDecoration(
                              hintText: "再次輸入密碼",
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.2))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor)),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).accentColor,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    this.hidePasswordagain =
                                        !this.hidePasswordagain;
                                  });
                                },
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.4),
                                icon: Icon(hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              )),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          onSaved: (input) => requestModel.username = input,
                          validator: (input) =>
                              input.length < 1 ? "使用者名稱不得為空白" : null,
                          decoration: InputDecoration(
                              hintText: "請輸入使用者名稱 ",
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.2))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor)),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Theme.of(context).accentColor,
                              )),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              this.registerResult == "已有此帳號，請輸入其他帳號名稱"
                                  ? Icons.error
                                  : Icons.assignment_turned_in,
                              color: this.registerResult == "已有此帳號，請輸入其他帳號名稱"
                                  ? Colors.red
                                  : Colors.green,
                              size: this.registerResult == "" ? 0 : 23,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              registerResult,
                              style: TextStyle(
                                  color:
                                      this.registerResult == "已有此帳號，請輸入其他帳號名稱"
                                          ? Colors.red
                                          : Colors.green,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        FlatButton(
                          onPressed: () {
                            if (validateAndSave()) {
                              setState(() {
                                this.isApiCallProcess = true;
                              });
                              _addaccount();
                            }
                          },
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 80),
                          child: Text(
                            "註冊",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          color: Theme.of(context).primaryColor,
                          shape: StadiumBorder(),
                        ),
                        SizedBox(height: 15),
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            });
                          },
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 80),
                          child: Text(
                            "登入",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          color: Theme.of(context).primaryColor,
                          shape: StadiumBorder(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  _addaccount() async {
    var data;
    var api = "http://140.123.94.131:8800/user/add";
    print(api);
    int time = DateTime.now().millisecondsSinceEpoch;
    String t = "$time";
    requestModel.time = t;
    final result = await http.post(api, body: requestModel.toJson());
    if (result.statusCode == 200) {
      setState(() {
        data = json.decode(result.body);
        print(data);
        if (data['status'] == "ok") {
          this.isApiCallProcess = false;
          this.registerResult = "帳號新增成功，可以登入囉!";
        } else {
          this.registerResult = '已有此帳號，請輸入其他帳號名稱';
          this.isApiCallProcess = false;
          print("註冊失敗");
        }
      });
    } else {}
    print(requestModel.toJson());
  }
}
