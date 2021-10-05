import 'dart:convert';

import 'package:batch_one/services/authentication.dart';
import 'package:batch_one/view/components/my_field.dart';
import 'package:batch_one/view/screens/signup.dart';
import 'package:batch_one/view/screens/user_auth_checker.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  String changedData = "";
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logoa.png',
            width: 100,
            height: 100,
          ),
          const Text(
            'Login',
            style: TextStyle(fontSize: 24),
          ),
          MyField(isPassword: false, hint: 'Email', mycontroller: email),
          MyField(isPassword: true, hint: 'Password', mycontroller: password),
          isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    login(email.text, password.text);
                  },
                  child: const Text('Login')),
          const Text(
            "Don't Have account?",
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const SignUp();
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

  login(email, password) async {
    Map data = {
      'email': email,
      'password': password,
    };
    changeLoadingState();
    final response = await Authentication().login(data);

    if (response.statusCode == 200 && response != null) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      if (resposne['success']) {
        Map<String, dynamic> user = resposne;

        await Authentication().saveUserToLocal(resposne['token']);

        myScakbar(resposne['message'] + " " + user["email"]);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => UserAuthChecker()));
      } else {
        myScakbar(resposne['message']);
      }
    } else {
      myScakbar('Something Went Wrong!');
    }
    changeLoadingState();
  }

  changeLoadingState() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  myScakbar(message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
