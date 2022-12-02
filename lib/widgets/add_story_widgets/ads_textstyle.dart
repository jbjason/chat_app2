import 'package:chat_app2/constants/constants.dart';
import 'package:flutter/material.dart';

class AdsTextStyle extends StatelessWidget {
  const AdsTextStyle(
      {Key? key,
      required this.textColor,
      required this.changeTextStyle,
      required this.textStyle})
      : super(key: key);
  final Color textColor;
  final ValueNotifier<int> textStyle;
  final void Function() changeTextStyle;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: changeTextStyle,
      child: ValueListenableBuilder(
        valueListenable: textStyle,
        builder: (context, int _textStyle, _) => Text(
          'AB+',
          style: getTextStyle(_textStyle, textColor, TextDecoration.underline),
        ),
      ),
    );
  }
}
