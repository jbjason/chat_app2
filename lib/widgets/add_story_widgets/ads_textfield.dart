import 'package:flutter/material.dart';

class AdsTextField extends StatelessWidget {
  const AdsTextField({
    Key? key,
    required this.textController,
    required this.textColor,
    required this.fontStyle,
  }) : super(key: key);

  final TextEditingController textController;
  final Color textColor;
  final FontStyle fontStyle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: TextFormField(
          textAlign: TextAlign.center,
          controller: textController,
          decoration: const InputDecoration(
            hintText: "Write Something.....",
            floatingLabelAlignment: FloatingLabelAlignment.center,
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
            contentPadding: EdgeInsets.only(left: 15, right: 15),
          ),
          cursorColor: textColor,
          style:
              TextStyle(fontSize: 24, color: textColor, fontStyle: fontStyle),
          textInputAction: TextInputAction.done,
          minLines: 1,
        ),
      ),
    );
  }
}
