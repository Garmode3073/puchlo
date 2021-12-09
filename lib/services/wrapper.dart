import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puchlo/models/user.dart';
import 'package:puchlo/screens/home.dart';
import 'package:puchlo/screens/signin.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserinApp>(context);
    if (user == null) {
      return LoginPage();
    } else {
      return HomeScreen();
    }
  }
}
