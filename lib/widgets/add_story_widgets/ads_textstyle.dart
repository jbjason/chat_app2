import 'package:flutter/material.dart';

class AdsTextStyle extends StatelessWidget {
  const AdsTextStyle(
      {Key? key,
      required this.textColor,
      required this.changeTextStyle,
      required this.fontStyle})
      : super(key: key);
  final Color textColor;
  final FontStyle fontStyle;
  final void Function() changeTextStyle;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: changeTextStyle,
      child: Text(
        'AB+',
        style: TextStyle(
          color: textColor,
          fontSize: 24,
          fontStyle: fontStyle,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
