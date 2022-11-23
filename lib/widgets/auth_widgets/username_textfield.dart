import 'package:flutter/material.dart';

class UserNameTextField extends StatelessWidget {
  const UserNameTextField({
    Key? key,
    required TextEditingController userNameController,
  })  : _userNameController = userNameController,
        super(key: key);

  final TextEditingController _userNameController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const ValueKey('username'),
      decoration: const InputDecoration(labelText: 'Username'),
      controller: _userNameController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter atleast 4 characters';
        }
        return null;
      },
    );
  }
}
