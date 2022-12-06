import 'dart:io';

import 'package:flutter/material.dart';

class AdsBackImage extends StatelessWidget {
  const AdsBackImage(
      {Key? key, required this.backColor, required this.pickedImage})
      : super(key: key);

  final Color backColor;
  final File? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backColor.withOpacity(.6),
            backColor,
            backColor.withOpacity(.7),
          ],
        ),
      ),
      child: pickedImage != null
          ? Image.file(pickedImage!, fit: BoxFit.contain)
          : const SizedBox(),
    );
  }
}
