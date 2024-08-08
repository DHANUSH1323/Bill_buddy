import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
import 'group_provider.dart';

import 'addgroup.dart';
import 'group.dart';
import 'history.dart';
import 'home.dart';
import 'login.dart';
import 'signup.dart';
import 'splitwise.dart'; // Adjust path as per your project structure

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupProvider>(
      create: (context) => GroupProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => Login(),
          '/signup': (context) => Signup(),
          '/home': (context) => Home(),
          '/groupPage': (context) => GroupPage(),
          '/addGroup': (context) => AddGroup(
            onCreateGroup: (groupData) {
              Provider.of<GroupProvider>(context, listen: false).addGroup(groupData);
              Navigator.pushReplacementNamed(context, '/groupPage');
            },
          ),
          '/splitwise': (context) => Splitwise(),
          '/history': (context) => History(),
        },
      ),
    );
  }
}
