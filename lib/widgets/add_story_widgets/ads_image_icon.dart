import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdsImageIcon extends StatelessWidget {
  const AdsImageIcon(
      {Key? key,
      required this.source,
      required this.icon,
      required this.pickedImage,
      required this.backColor,
      required this.textColor})
      : super(key: key);
  final Color textColor;
  final Color backColor;
  final ImageSource source;
  final IconData icon;
  final Function(File image) pickedImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: backColor,
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
          icon: Icon(icon, color: textColor),
        ),
      ),
    );
  }
}
