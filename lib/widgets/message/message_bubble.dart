import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
    this.messages,
    this.usename,
    this.isMe, {
    Key? key,
  }) : super(key: key);
  String messages;
  String usename;
  final bool isMe;
  // final String userName;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: 180,
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: isMe ? Radius.circular(30) : Radius.circular(0),
              bottomRight: !isMe ? Radius.circular(30) : Radius.circular(0),
            ),
            color: isMe ? Color.fromARGB(255, 9, 161, 172) : Colors.pink,
          ),
          child: Column(
            children: [
              Text(
                usename,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
              Divider(),
              Text(
                messages,
                textAlign: isMe ? TextAlign.end : TextAlign.start,
                style: TextStyle(
                  color: isMe ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
