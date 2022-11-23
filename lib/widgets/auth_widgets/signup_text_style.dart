import 'package:flutter/material.dart';

class SignUpTextStyle extends StatelessWidget {
  const SignUpTextStyle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 30, left: 16),
          child: RotatedBox(
            quarterTurns: -1,
            child: Text(
              'Sign up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 10.0),
          child: SizedBox(
            height: 200,
            width: 200,
            child: Column(
              children: const [
                SizedBox(height: 60),
                Center(
                  child: Text(
                    'We can start something new',
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
