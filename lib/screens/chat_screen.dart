// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? messageText;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;

    if (user != null) {
      try {
        signedInUser = user;
        print(signedInUser.email);
      } catch (e) {
        print(e);
      }
    }
  }

  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').get();

  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }
  // }

  void messagesStreams() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset(
              'images/logo.png',
              height: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Text('MessageMe'),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                // _auth.signOut();
                // Navigator.pop(context);
                messagesStreams();
              },
              icon: Icon(Icons.download))
        ],
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('messages').snapshots(),
            builder: (context, snapshot) {
              List<Text> messageWidgets = [];

              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                );
              }
              final messages = snapshot.data!.docs;
              for (var message in messages) {
                final messageText = message.get('text');
                final messageSender = message.get('sender');
                final messageWidget = Text('$messageText - $messageSender');
                messageWidgets.add(messageWidget);
              }

              return Column(children: messageWidgets);
            },
          ),
          Container(
            decoration: BoxDecoration(
                border:
                    Border(top: BorderSide(color: Colors.orange, width: 2))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      messageText = value;
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        hintText: 'Write your message here ...',
                        border: InputBorder.none),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      _firestore.collection('messages').add(
                          {'text': messageText, 'sender': signedInUser.email});
                    },
                    child: Text('Send',
                        style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 18)))
              ],
            ),
          ),
        ],
      )),
    );
  }
}
