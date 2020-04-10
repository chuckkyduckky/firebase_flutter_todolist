import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todolist/authentication.dart';
import 'package:todolist/pages/newUserRegisterPage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.loginCallback});
  final BaseAuth auth;
  final VoidCallback loginCallback;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      _errorMessage = "";
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        userId = await widget.auth.signIn(_email, _password);
        log('Signed in: $userId');
        bool verification;
        await widget.auth.getCurrentUser().then((user){
          verification = user.isEmailVerified;
        });
        if (userId.length > 0 && userId != null && verification) {
          widget.loginCallback();
        } else {
          setState(() {
          _errorMessage = 'please verify your email to proceed';
        });
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  void sendResetMail() async {
   SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      _errorMessage = "";
    });
    if (validateAndSave()) {
      try {
        await widget.auth.passWordResetEmail(_email);
        setState(() {
          _errorMessage = 'password reset link sent';
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    super.initState();
  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    Widget showLogo() {
      return new Hero(
        tag: 'hero',
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 48.0,
            child: Image.asset(
              'assets/logo.png',
            ),
          ),
        ),
      );
    }

    Widget emailField() {
      return TextFormField(
        obscureText: false,
        style: style,
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
        decoration: InputDecoration(
            fillColor: Colors.white54,
            filled: true,
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Email",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      );
    }

    Widget showErrorMessage() {
      if (_errorMessage.length > 0 && _errorMessage != null) {
        return new Text(
          _errorMessage,
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.w300),
        );
      } else {
        return new Container(
          height: 0.0,
        );
      }
    }

    Widget passwordField() {
      return TextFormField(
        obscureText: true,
        style: style,
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
        decoration: InputDecoration(
            fillColor: Colors.white54,
            filled: true,
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      );
    }

    Widget loginButon() {
      return Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xff01A0C7),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: validateAndSubmit,
          child: Text("Login",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
    }

    Widget forgotPassword() {
      return InkWell(
        onTap:sendResetMail,
          child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          decoration: TextDecoration.underline,
        ),
      ));
    }

    Widget _createAccountLabel() {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white54),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewUserRegister(auth: widget.auth)));
              },
              child: Text(
                'Register',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                    decoration: TextDecoration.underline),
              ),
            )
          ],
        ),
      );
    }

    return new Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      // resizeToAvoidBottomPadding: false,
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(36.0),
        child: SingleChildScrollView(
          child: new Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  showLogo(),
                  SizedBox(height: 40.0),
                  emailField(),
                  SizedBox(height: 25.0),
                  passwordField(),
                  SizedBox(height: 25.0),
                  Align(
                    alignment: Alignment(-0.87, 0),
                    child: forgotPassword(),
                  ),
                  SizedBox(height: 40.0),
                  loginButon(),
                  SizedBox(height: 25.0),
                  _createAccountLabel(),
                  showErrorMessage()
                ],
              )),
        ),
      )),
    );
  }
}
