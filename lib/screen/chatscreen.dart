import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore =FirebaseFirestore.instance;
User loggedInUser;
class ChatScreen extends StatefulWidget {
  static const String id='ChatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController=TextEditingController();
  final _auth= FirebaseAuth.instance;
  String messageText;


  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  //if current user is sign
  void getCurrentUser()async{
    try {
      final user =await _auth.currentUser; // ignore: await_only_futures
      if (user != null) {
        loggedInUser = user;
       //  print(loggedInUser.email);
       }
    }catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

        title: Text('🎀 ️Chat'),
        backgroundColor: Colors.pinkAccent,
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
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText  = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      //Implement send functionality.
                      //messageText + loggedInUser.email
                      _firestore.collection('messages').add({
                        'timestamp':FieldValue.serverTimestamp(),
                        'text':messageText,
                        'sender':loggedInUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
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
      stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.pinkAccent,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          //firebase data
          final messageText = message.get('text');
          final messageSender = message.get('sender');

          final currentUser= loggedInUser.email;

          if(currentUser == messageSender){
            //the message from logged in user
          }

          final messageBubble =MessageBubble(sender: messageSender,text: messageText,isMe: currentUser == messageSender);
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 8.0),
            child: ListView(
              children: messageBubbles,
              reverse: true,
            ),
          ),
        );
      },
    );
  }
}



class MessageBubble extends StatelessWidget {
  MessageBubble({this.text,this.sender,this.isMe});
  final String text;
  final String sender;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender,
          style: TextStyle(
            fontSize: 10.0,
            color: Colors.black54,
          ),),
          Material(
            borderRadius:isMe ? BorderRadius.only(topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30))
            : BorderRadius.only(bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),topRight: Radius.circular(30)),
           elevation: 5.0,
           color: isMe ? Colors.pinkAccent : Colors.white,
           child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
            child: Text(text,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black54,
                fontSize: 15.0),
           ),
          ),
        ),
      ],
      ),
    );
  }
}