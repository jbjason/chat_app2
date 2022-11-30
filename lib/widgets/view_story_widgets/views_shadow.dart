import 'package:flutter/material.dart';

class ViewsShadow extends StatelessWidget {
  const ViewsShadow({Key? key, required this.topPadding}) : super(key: key);
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topPadding,
      left: 0,
      right: 0,
      height: 60,
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              spreadRadius: 20,
              blurRadius: 60,
              offset: Offset(0, -5),
              color: Colors.black38,
            )
          ],
        ),
      ),
    );
  }
}
