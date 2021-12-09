import 'package:flutter/material.dart';
import 'package:puchlo/globals.dart' as g;
import 'package:puchlo/services/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: g.height,
        width: g.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blueAccent.withOpacity(0.8),
                Colors.blueAccent.withOpacity(0.2),
              ]),
        ),
        child: Center(
          child: RawMaterialButton(
            splashColor: Colors.deepPurpleAccent.withOpacity(0.2),
            onPressed: () async {
              AuthServices auth = AuthServices();
              await auth.signOut();
            },
            child: Container(
              width: 130,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple[400],
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(7),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepPurpleAccent.withOpacity(0.2),
                      Colors.deepPurpleAccent.withOpacity(0.8),
                    ]),
              ),
              child: Center(
                  child: Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'Lucida Fax',
                  fontSize: 22,
                  color: Colors.deepPurple,
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
