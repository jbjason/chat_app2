import 'package:chat_app2/constants/theme.dart';
import 'package:flutter/material.dart';

class ButtonloginSignup extends StatelessWidget {
  const ButtonloginSignup(
      {Key? key,
      required this.trySubmit,
      required this.changeLoginStatus,
      required this.isLoading,
      required this.isLogin})
      : super(key: key);

  final void Function() trySubmit;
  final void Function() changeLoginStatus;
  final ValueNotifier<bool> isLoading;
  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isLoading,
      builder: (context, bool _isLoad, _) => Column(
        children: [
          const SizedBox(height: 8),
          _isLoad
              ? const CircularProgressIndicator()
              : Container(
                  width: double.infinity,
                  height: 70,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white70,
                      shadowColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: trySubmit,
                    child: Text(
                      isLogin ? 'Login' : 'Signup',
                      style: const TextStyle(
                        color: Color(0xFF1F787A),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
          if (!_isLoad)
            TextButton(
              onPressed: () => changeLoginStatus(),
              child: Text(
                isLogin ? 'Create new account' : 'I already have an account',
                style: const TextStyle(color: AppColors.textLigth),
              ),
            )
        ],
      ),
    );
  }
}
