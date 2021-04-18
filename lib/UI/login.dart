import 'dart:convert';

import 'package:bamboo/UI/ProgressHUD.dart';
import 'package:bamboo/UI/login_model.dart';
import 'package:bamboo/UI/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cameraPage.dart';
import 'information_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  bool hidePassword = true;
  LoginRequestModel requestModel;
  bool isApiCallProcess = false;
  String loginResult = '';
  var data;
  @override
  void initState() {
    super.initState();
    requestModel = new LoginRequestModel();
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
                  // height: MediaQuery.of(context).size.height * 0.8,
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Text(
                          "登入",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          onSaved: (input) => requestModel.account = input,
                          validator: (input) =>
                              input.length < 8 ? "帳號至少需要8個字元以上" : null,
                          decoration: InputDecoration(
                              hintText: "請輸入使用者帳號",
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
                          height: 20,
                        ),
                        TextFormField(
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
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error,
                              color: Colors.red,
                              size: this.loginResult == "" ? 0 : 23,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              loginResult,
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        FlatButton(
                          onPressed: () {
                            if (validateAndSave()) {
                              setState(() {
                                this.isApiCallProcess = true;
                              });
                              _check();
                            }
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
                        SizedBox(
                          height: 25,
                        ),
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()));
                            });
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
                        )
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

  _check() async {
    var data;
    var api = "http://140.123.94.131:8800/user";
    print(api);
    final result = await http.post(api, body: requestModel.toJson());
    print("213");
    if (result.statusCode == 200) {
      setState(() {
        data = json.decode(result.body);
        print(data);
        if (data['statusCode'] == 300) {
          this.isApiCallProcess = false;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InformationPage(user: data['data'])));
        } else {
          setState(() {
            this.isApiCallProcess = false;
            this.loginResult = '帳號或密碼輸入錯誤，請重新輸入';
          });
          print("Login error");
        }
      });
    } else {}
    print(requestModel.toJson());
  }
}
