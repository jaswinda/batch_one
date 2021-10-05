import 'package:batch_one/services/authentication.dart';
import 'package:batch_one/view/screens/home.dart';
import 'package:batch_one/view/screens/login.dart';
import 'package:batch_one/view/screens/signup.dart';
import 'package:flutter/material.dart';

class UserAuthChecker extends StatefulWidget {
  const UserAuthChecker({Key? key}) : super(key: key);

  @override
  State<UserAuthChecker> createState() => _UserAuthCheckerState();
}

class _UserAuthCheckerState extends State<UserAuthChecker> {
  @override
  void initState() {
    super.initState();
    checkUserAuthentication();
  }

  checkUserAuthentication() async {
    bool tokenFound =
        await Authentication().getUserToken() == null ? false : true;
    print(await Authentication().getUserToken());
    if (!tokenFound) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return const Login();
      }));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return const Home();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
