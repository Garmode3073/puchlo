import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puchlo/models/user.dart';
import 'package:puchlo/screens/loading.dart';
import 'package:puchlo/services/auth.dart';
import 'package:puchlo/services/wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(home: LoadingPage());
        } else if (snapshot.connectionState == ConnectionState.done) {
          AuthServices auth = AuthServices();
          return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: StreamProvider<UserinApp>.value(
                value: auth.userIsIn,
                initialData: null,
                child: Wrapper(),
              ));
        }
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: LoadingPage(),
        );
      },
    );
  }
}

class Dummy extends StatefulWidget {
  const Dummy({Key key}) : super(key: key);

  @override
  _DummyState createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  String data = "WarMachine rox";
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => data,
      child: Scaffold(
        body: Center(
          child: Text("data"),
        ),
      ),
    );
  }
}
