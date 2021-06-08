import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore =
    Firestore.instance; // so that it can be used by other classes too

FirebaseUser loggedUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final _auth = FirebaseAuth.instance;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      loggedUser = await _auth.currentUser();
      if (loggedUser != null) {
        print(loggedUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages()
  // async{
  //   final messages = await _firestore.collection('messages').getDocuments();
  //   //messages.documents is a list
  //
  //   for (var message in messages.documents)
  //     {
  //       print(message.data);
  //     }
  // }

  void messagesStream() async {
    //almost like lists, this method is prefered cause Static type

    await for (var snapshot in _firestore.collection('messages').snapshots())
      for (var message in snapshot.documents) {
        print(message.data);
      }
  }

  String messageText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('oyus chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        messageText = value;
                        //Do something with the user input.
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _controller.clear();
                      _firestore.collection('messages').add(
                          {'text': messageText, 'sender': loggedUser.email});

                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0,)
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents.reversed; //to reverse the order of the list to show new items
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];

          final currentUser = loggedUser.email;

          final messageBubble =
              MessageBubble(sender: messageSender, text: messageText,
              isMe: messageSender==currentUser,);
          messageBubbles.add(messageBubble);
        }
        return Expanded(
            child: ListView(
              reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                children: messageBubbles));
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 10.0, color: Colors.white70),
          ),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.only(topLeft: isMe?Radius.circular(30.0):Radius.circular(0.0),bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0), topRight: isMe?Radius.circular(0.0):Radius.circular(30.0)),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text('$text',
                  style: TextStyle(fontSize: 15.0, color: isMe?Colors.white:Colors.black54)),
            ),
            color: isMe?Colors.lightBlueAccent:Colors.white,
          ),
        ],
      ),
    );
  }
}
