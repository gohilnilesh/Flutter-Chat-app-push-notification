import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/auth/authform.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isloading = false;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  void _submitAuthForm(
    String email,
    String username,
    String password,
    File image,
    bool isLogin,
  ) async {
    UserCredential? authResult;
    try {
      setState(() {
        _isloading = true;
      });
      if (isLogin) {
        final authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        final authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // final imgstore = _storage
        //     .ref()
        //     .child('user_profile_img')
        //     .child(authResult.user!.uid + '.jpg');
        // await imgstore.putFile(image);
        // final url = imgstore.getDownloadURL();

        return await _firestore
            .collection('users')
            .doc(authResult.user!.uid)
            .set(
          {
            'username': username,
            // 'image_url': url,
            'email': email,
          },
        );
      }
      setState(() {
        _isloading = false;
      });
    } on PlatformException catch (err) {
      var message = 'An error occured Please Check Your Credentials.';
      if (err.message != null) {
        message = err.message!;
      }

      setState(
        () {
          _isloading = false;
        },
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            err.toString(),
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      print(err);
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isloading),
    );
  }
}
