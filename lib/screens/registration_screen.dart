import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {

  static String id = 'registration_screen';


  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;

  bool showSpinner = false;

  String email;
  String password;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'Logo',  //should match with the initial widget
                  child: Container(
                    height: 150.0,
                    child: Image.asset('images/chatbox.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  email = value;
                  //Do something with the user input.
                },
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                decoration: kTextFieldDecorator.copyWith(
                  hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Colors.white38)
                )
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {

                  password = value;
                  //Do something with the user input.
                },
                  textAlign: TextAlign.center,
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                decoration: kTextFieldDecorator.copyWith(
                  hintText: 'Enter your password',
                    hintStyle: TextStyle(color: Colors.white38)
                )
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(onPressed: ()async{

                setState(() {
                  showSpinner = true;
                });

                try {
                  final newuser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);

                  if (newuser != null) {
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                  setState(() {
                    showSpinner = false;
                  });
                }
                catch(e)
                {
                  print(e);
                }
                /*register*/
              },
                title: 'Register', color: Colors.blueAccent,),
            ],
          ),
        ),
      ),
    );
  }
}
