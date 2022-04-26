import 'dart:io';

import 'package:chat_app/widgets/image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isloading);
  final bool isloading;
  final void Function(
    String email,
    String username,
    String password,
    File image,
    bool isLogin,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final _isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!_isValid) {
      return;
    }
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: const Text('Please set a Profile Picture'),
        ),
      );
      return;
    }
    if (_isValid) {
      _formkey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _userImageFile!,
        _isLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shadowColor: Colors.grey,
        color: Colors.amberAccent,
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    key: const ValueKey('email'),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Enter Valid Email Address';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.red,
                    cursorHeight: 25,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.email),
                        iconColor: Colors.redAccent,
                        hintText: 'Email Address'),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      onSaved: (value) {
                        _userName = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a usename';
                        }
                        if (value.length <= 4) {
                          return 'username should have atleast 4 characters ';
                        }
                        return null;
                      },
                      cursorColor: Colors.red,
                      cursorHeight: 25,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.person),
                          iconColor: Colors.redAccent,
                          hintText: 'Username'),
                    ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    key: const ValueKey('password'),
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Password';
                      }
                      if (value.length <= 6) {
                        return 'Password must be 6 characters long';
                      }
                      return null;
                    },
                    obscureText: true,
                    cursorColor: Colors.red,
                    cursorHeight: 25,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.key),
                        iconColor: Colors.redAccent,
                        hintText: 'Enter Password'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (widget.isloading) CircularProgressIndicator(),
                  if (!widget.isloading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Submit' : 'SignUp'),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (!widget.isloading)
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create New Account'
                            : 'Already have account'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
