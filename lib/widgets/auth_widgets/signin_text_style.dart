import 'package:flutter/material.dart';

class SignInTextStyle extends StatelessWidget {
  const SignInTextStyle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 30, left: 10, bottom: 10),
          child: RotatedBox(
            quarterTurns: -1,
            child: Text(
              'Sign in',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 10.0, bottom: 10),
          child: Container(
            //color: Colors.green,
            height: 200,
            width: 200,
            child: Column(
              children: [
                Container(
                  height: 60,
                ),
                const Center(
                  child: Text(
                    'A world of possibility in an app',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}