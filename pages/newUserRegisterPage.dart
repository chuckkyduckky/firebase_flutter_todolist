import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todolist/authentication.dart';

class NewUserRegister extends StatefulWidget {
  NewUserRegister({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => _NewUserRegisterState();
}

class _NewUserRegisterState extends State<NewUserRegister> {
  final _formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _errorMessage;
  bool loadingScreen;

  @override
  void initState() {
    _errorMessage = "";
    loadingScreen = false;
    super.initState();
  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

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

  Widget registerButton() {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: registerNewUser,
        child: Text("Register",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget loadingSymbol() {
    if (loadingScreen == true) {
      return CircularProgressIndicator();
    } else {
      return new Container(
        height: 0.0,
      );
    }
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

  void toggleLoadingScreen() {
    setState(() {
      loadingScreen = loadingScreen == true ? false : true;
    });
  }

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> registerNewUser() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      _errorMessage = "";
    });
    if(validateAndSave()){
       try{
         toggleLoadingScreen();
         await widget.auth.signUp(_email, _password);
         await widget.auth.sendEmailVerification();
         toggleLoadingScreen();
         setState(() {
            _errorMessage = 'verify email to proceed';
         });
       } catch (e) {
        print('Error: $e');
        toggleLoadingScreen();
        setState(() {
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  emailField(),
                  SizedBox(height: 25.0),
                  passwordField(),
                  SizedBox(height: 25.0),
                  registerButton(),
                  SizedBox(height: 25.0),
                  loadingSymbol(),
                  showErrorMessage(),
                  SizedBox(height: 25.0)
                ],
              )),
        ),
      )),
    );
  }
}
