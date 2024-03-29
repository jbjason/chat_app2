import 'package:chat_app2/constants/constants.dart';
import 'package:flutter/material.dart';

class AdsTextField extends StatelessWidget {
  const AdsTextField({
    Key? key,
    required this.textController,
    required this.textColor,
    required this.textStyle,
  }) : super(key: key);

  final TextEditingController textController;
  final Color textColor;
  final ValueNotifier<int> textStyle;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: textStyle,
      builder: (context, int _textStyle, _) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: textController,
            decoration: const InputDecoration(
              hintText: "Write Something.....",
              floatingLabelAlignment: FloatingLabelAlignment.center,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.only(left: 15, right: 15),
            ),
            cursorColor: textColor,
            style: getTextStyle(_textStyle, textColor, TextDecoration.none),
            textInputAction: TextInputAction.done,
            minLines: 1,
            maxLines: 5,
          ),
        ),
      ),
    );
  }
}
