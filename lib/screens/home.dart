import 'package:flutter/material.dart';
import 'package:puchlo/globals.dart' as g;
import 'package:puchlo/services/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String cat = 'All';

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blueAccent.withOpacity(0.8),
                      Colors.blueAccent.withOpacity(0.2),
                    ]),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://st.depositphotos.com/1779253/5140/v/950/depositphotos_51405259-stock-illustration-male-avatar-profile-picture-use.jpg'),
              ),
              accountName: Text(
                g.userinApp.name,
                style: TextStyle(color: Colors.deepPurple, fontSize: 20),
              ),
              accountEmail: Text(
                g.userinApp.email != null
                    ? g.userinApp.email
                    : g.userinApp.phoneNumber,
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
            Expanded(child: Container()),
            ListTile(
              tileColor: Colors.blueAccent.withOpacity(0.35),
              onTap: () async {
                AuthServices auth = AuthServices();
                await auth.signOut();
              },
              title: Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'Lucida Fax',
                  fontSize: 18,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
      ),
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
          child: ListView(
            children: [
              Container(
                width: g.width,
                height: g.height * 0.07,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List<Widget>.generate(
                    g.categories.length,
                    (i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              cat = g.categories[i];
                            });
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(g.categories[i]),
                            ),
                          ),
                        ),
                        decoration: cat == g.categories[i]
                            ? BoxDecoration(
                                border: Border.all(
                                  color: Colors.deepPurple.withOpacity(0.2),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(7),
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.deepPurpleAccent.withOpacity(0.2),
                                      Colors.deepPurpleAccent.withOpacity(0.4),
                                    ]),
                              )
                            : BoxDecoration(
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(7),
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.05),
                                    ]),
                              ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
