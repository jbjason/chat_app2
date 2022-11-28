import 'dart:io';
import 'package:chat_app2/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdsImageIcon extends StatelessWidget {
  const AdsImageIcon(
      {Key? key,
      required this.source,
      required this.icon,
      required this.pickedImage,
      required this.textColor})
      : super(key: key);
  final Color textColor;
  final ImageSource source;
  final IconData icon;
  final Function(File image) pickedImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.grey[200],
      child: CircleAvatar(
        radius: 23,
        backgroundColor: AppColors.secondary,
        child: IconButton(
          onPressed: () async {
            final pickedImageFile = await ImagePicker().pickImage(
              source: source,
              imageQuality: 100,
              maxHeight: 500,
              maxWidth: 300,
            );
            pickedImage(File(pickedImageFile!.path));
          },
          icon: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
