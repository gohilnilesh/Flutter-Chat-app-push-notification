import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({Key? key}) : super(key: key);

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _controller = new TextEditingController();
  var _enteredtext = '';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = _auth.currentUser;
    final userData = await _firestore.collection('users').doc(user!.uid).get();

     _firestore.collection('chat').add({
      'text': _enteredtext,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black54,
          ),
        ),
        child: Row(children: [
          Expanded(
            child: TextField(
              cursorColor: Colors.green,
              cursorHeight: 30,
              controller: _controller,
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                setState(() {
                  _enteredtext = value;
                });
              },
              decoration: const InputDecoration(
                hintTextDirection: TextDirection.ltr,
                hintText: 'Message',
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                alignLabelWithHint: true,
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            height: 50,
            width: 50,
            padding: EdgeInsets.only(
              left: 5,
            ),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.green[500]),
            child: IconButton(
                onPressed: _enteredtext.trim().isEmpty ? null : _sendMessage,
                icon: Icon(
                  Icons.send,
                  color: _enteredtext.isEmpty
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                )),
          ),
        ]),
      ),
    );
  }
}
