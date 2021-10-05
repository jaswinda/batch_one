import 'package:batch_one/services/authentication.dart';
import 'package:batch_one/view/screens/user_auth_checker.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('This is hOme screen')),
          ElevatedButton(
              onPressed: () async {
                await Authentication().logout();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => UserAuthChecker()));
              },
              child: Text('Logout'))
        ],
      ),
    );
  }
}
