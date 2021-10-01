import 'package:flutter/material.dart';

class MyField extends StatelessWidget {
  final bool isPassword;
  final String hint;
  final TextEditingController mycontroller;
  const MyField(
      {Key? key,
      required this.isPassword,
      required this.hint,
      required this.mycontroller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Align(alignment: Alignment.topLeft, child: Text(hint)),
          TextFormField(
            controller: mycontroller,
            obscureText: isPassword,
          ),
        ],
      ),
    );
  }
}
