import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/authentication.dart';

class HomePage extends StatefulWidget {
  

   HomePage({this.auth, this.logoutCallback});
   
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>{

    Widget loginButon() {
      return Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xff01A0C7),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: widget.logoutCallback,
          child: Text("Login",
              textAlign: TextAlign.center)
            
        ),
      );
    }

      @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter login demo"),
      ),
      body: new Container(
        child: loginButon(),
      ),
    );
  }
}


