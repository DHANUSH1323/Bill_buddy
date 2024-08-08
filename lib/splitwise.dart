import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';

void main() {
  runApp(MaterialApp(
    home: Splitwise(),
    routes: {
      '/': (context) => Login(), // Define your Login page route
      '/home': (context) => Home(), // Define your Home page route
      '/splitwise': (context) => Splitwise(), // Define your Splitwise page route
    },
  ));
}

class Splitwise extends StatefulWidget {
  const Splitwise({super.key});

  @override
  State<Splitwise> createState() => _SplitwiseState();
}

class _SplitwiseState extends State<Splitwise> {
  int age = 26;

  void _navigateTo(String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'Splitwise app',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        elevation: 0.0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[850],
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                _navigateTo('/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                _navigateTo('/splitwise');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () {
                _navigateTo('/');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/user_profile.jpeg'),
                radius: 40.0,
              ),
            ),
            Divider(
              height: 50.0,
              color: Colors.grey[800],
            ),
            Text(
              'Name:',
              style: TextStyle(
                color: Colors.yellow,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Dhanush Babu',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              children: [
                Icon(
                  Icons.email,
                  color: Colors.grey,
                ),
                SizedBox(width: 10.0),
                Text(
                  'dhanushramrt@gmail.com',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Text(
              'DOB:',
              style: TextStyle(
                color: Colors.yellow,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '$age',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              'Phone No:',
              style: TextStyle(
                color: Colors.yellow,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '(+1)716-939-8230',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Divider(
              height: 10.0,
              color: Colors.grey[800],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  '>',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Terms of Service',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  '>',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Account',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  '>',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Feedback',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  '>',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            Divider(
              height: 50.0,
              color: Colors.grey[800],
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  _navigateTo('/login');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
                child: Text('Sign Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
