import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const UserImagePicker({required this.imagePickFn});
  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  void _pickImage() async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );
    setState(() => _pickedImage = File(pickedImageFile!.path));
    widget.imagePickFn(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _pickedImage == null
            ? const CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey,
              )
            : CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey,
                backgroundImage: FileImage(_pickedImage!),
              ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Add image'),
        )
      ],
    );
  }
}
