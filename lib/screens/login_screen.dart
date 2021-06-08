import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {

  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _auth = FirebaseAuth.instance;

  bool showSpinner = false;

  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner ,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'Logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                  keyboardType: TextInputType.emailAddress,
                decoration: kTextFieldDecorator.copyWith(
                  hintText: 'Enter your email'
                )
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                  obscureText: true,
                decoration: kTextFieldDecorator.copyWith(
                  hintText: 'Enter your password'
                )
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(onPressed: ()async{

                setState(() {
                  showSpinner = true;
                });

                try{
                  final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                  if(user!=null){
                  Navigator.pushNamed(context, ChatScreen.id);}

                  setState(() {
                    showSpinner = false;
                  });

                }
                catch(e)
                {
                  print(e);
                }
                /*Log in*/
              }, color: Colors.lightBlueAccent,title: 'Log In',),

            ],
          ),
        ),
      ),
    );
  }
}
