import 'package:batch_one/view/components/my_field.dart';
import 'package:batch_one/view/screens/signup.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String changedData = "";
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Login',
            style: TextStyle(fontSize: 24),
          ),
          MyField(isPassword: false, hint: 'Email', mycontroller: email),
          MyField(isPassword: true, hint: 'Password', mycontroller: password),
          ElevatedButton(onPressed: () {}, child: Text('Login')),
          const Text(
            "Don't Have account?",
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return SignUp();
              }));
            },
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
