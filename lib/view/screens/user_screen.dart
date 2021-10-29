import 'package:batch_one/services/authentication.dart';
import 'package:batch_one/view/screens/user_auth_checker.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset(
          'assets/images/logoa.png',
          height: 150,
          width: 150,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Name: ',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Sharon Poudel ',
              style: TextStyle(fontSize: 24),
            )
          ],
        ),
        Center(
          child: ElevatedButton(
              onPressed: () async {
                await Authentication().logout();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => UserAuthChecker()));
              },
              child: Text('Logout')),
        ),
      ],
    ));
  }
}
