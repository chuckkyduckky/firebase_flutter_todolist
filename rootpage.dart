import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/authentication.dart';
import 'package:todolist/pages/homePage.dart';
import 'package:todolist/pages/login.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
  NOT_VERIFIED,
  VERIFIED
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      if (user.isEmailVerified) {
        setState(() {
          _userId = user.uid.toString();
          authStatus = AuthStatus.VERIFIED;
        });
      } else {
        setState(() {
          _userId = user.uid.toString();
          authStatus = AuthStatus.NOT_VERIFIED;
        });
      }
    });
  }

  void logoutCallback() {
    widget.auth.signOut();
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.NOT_VERIFIED:
        return new LoginPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 &&
            _userId != null &&
            authStatus == AuthStatus.VERIFIED) {
          return new HomePage(
            auth: widget.auth,
            logoutCallback: logoutCallback,
          );
        } else {
          return new LoginPage(
            auth: widget.auth,
            loginCallback: loginCallback,
          );
        }
        break;
      case AuthStatus.VERIFIED:
        if (_userId.length > 0 &&
            _userId != null &&
            authStatus == AuthStatus.VERIFIED) {
          return new HomePage(
            auth: widget.auth,
            logoutCallback: logoutCallback,
          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
