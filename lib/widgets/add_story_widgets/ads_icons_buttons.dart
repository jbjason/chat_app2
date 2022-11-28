import 'dart:io';
import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/widgets/add_story_widgets/ads_chng_color.dart';
import 'package:chat_app2/widgets/add_story_widgets/ads_image_icon.dart';
import 'package:chat_app2/widgets/add_story_widgets/ads_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdsIconsButtons extends StatelessWidget {
  const AdsIconsButtons({
    Key? key,
    required this.pickedImage,
    required this.changeTextStyle,
    required this.changeColor,
    required this.backColor,
    required this.fontStyle,
  }) : super(key: key);

  final Function(File image) pickedImage;
  final void Function() changeTextStyle;
  final Function(String isColor, int index) changeColor;
  final Color backColor;
  final FontStyle fontStyle;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // camera, gallery, text color, text style Icon
        Positioned(
          top: 30,
          right: 15,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Camera Icon
                AdsImageIcon(
                  source: ImageSource.camera,
                  icon: Icons.camera,
                  pickedImage: pickedImage,
                  textColor: AppColors.textLigth,
                  backColor: backColor,
                ),
                const SizedBox(height: 10),
                // Gallery Icon
                AdsImageIcon(
                  source: ImageSource.gallery,
                  icon: Icons.image_outlined,
                  pickedImage: pickedImage,
                  textColor: AppColors.textLigth,
                  backColor: backColor,
                ),
                const SizedBox(height: 10),
                // text color
                AdsChngColor(
                  changeColor: changeColor,
                  isColor: 'text',
                  backColor: backColor,
                  child: const Text('A',
                      style:
                          TextStyle(color: AppColors.textLigth, fontSize: 24)),
                ),
                const SizedBox(height: 10),
                // textStyle
                AdsTextStyle(
                  fontStyle: fontStyle,
                  textColor: AppColors.textLigth,
                  changeTextStyle: changeTextStyle,
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
        // backColor Icon
        Positioned(
          right: 80,
          top: 30,
          child: AdsChngColor(
            changeColor: changeColor,
            isColor: 'back',
            backColor: backColor,
            child: CircleAvatar(
              radius: 23,
              backgroundColor: backColor.withOpacity(.9),
            ),
          ),
        ),
      ],
    );
  }
}
