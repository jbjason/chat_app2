import 'package:chat_app2/constants/theme.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({Key? key, required this.imagePickFn})
      : super(key: key);
  final void Function(File pickedImage) imagePickFn;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage(ImageSource source) async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: source,
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
        _circleAvatar(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageIcon(ImageSource.camera, Icons.camera_alt_sharp),
            const Text(
              'Add image',
              style: TextStyle(color: AppColors.textFaded),
            ),
            _imageIcon(ImageSource.gallery, Icons.image),
          ],
        ),
      ],
    );
  }

  Widget _circleAvatar() => _pickedImage == null
      ? CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey[900]!,
        )
      : CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey[900]!,
          backgroundImage: FileImage(_pickedImage!),
        );

  Widget _imageIcon(ImageSource source, IconData icon) => IconButton(
        onPressed: () => _pickImage(source),
        icon: Icon(icon, color: AppColors.iconDark),
      );
}
