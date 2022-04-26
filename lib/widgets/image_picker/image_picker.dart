import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);
  final Function(File pickedimage) imagePickFn;
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final img = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 100,
      maxWidth: 100,
    );
    if (img == null) return;
    final image = File(img.path);
    setState(() {
      _pickedImage = image;
    });
    widget.imagePickFn(image);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          maxRadius: 50,
          backgroundColor: Colors.blueGrey,
          backgroundImage:
              _pickedImage == null ? null : FileImage(_pickedImage!),
        ),
        SizedBox(
          height: 10,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add Profile Picture'),
        ),
      ],
    );
  }
}
