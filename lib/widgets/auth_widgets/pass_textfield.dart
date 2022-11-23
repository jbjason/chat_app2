import 'package:flutter/material.dart';

class PassTextField extends StatelessWidget {
  const PassTextField({
    Key? key,
    required TextEditingController passController,
  })  : _passController = passController,
        super(key: key);

  final TextEditingController _passController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const ValueKey('password'),
      decoration: const InputDecoration(labelText: 'Password'),
      obscureText: true,
      controller: _passController,
      validator: (value) {
        if (value!.isEmpty || value.length <= 5) {
          return 'Please enter atleast 4 characters';
        }
        return null;
      },
    );
  }
}
