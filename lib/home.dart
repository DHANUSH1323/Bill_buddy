import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'group.dart';
import 'addgroup.dart';
import 'history.dart';
import 'group_provider.dart';
import 'login.dart'; // Import your Login page

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions() => <Widget>[
    _buildHomePage(),
    GroupPage(),
    AddGroup(onCreateGroup: _createGroup),
    History(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _createGroup(Map<String, dynamic> groupData) {
    Provider.of<GroupProvider>(context, listen: false).addGroup(groupData);
    setState(() {
      _selectedIndex = 1; // Switch to the Groups page tab
    });
  }

  void _settleDebt(String memberName, double amountToSettle) {
    Provider.of<GroupProvider>(context, listen: false).settleDebt(
      memberName,
      amountToSettle,
      Provider.of<GroupProvider>(context, listen: false).calculateDebtsWithGroups().cast<String, Map<String, double>>(),
    );
  }

  Widget _buildHomePage() {
    return Consumer<GroupProvider>(
      builder: (context, groupProvider, child) {
        final debtsWithGroups = groupProvider.calculateDebtsWithGroups();

        return ListView.builder(
          itemCount: debtsWithGroups.keys.length,
          itemBuilder: (context, index) {
            String member = debtsWithGroups.keys.elementAt(index);
            Map<String, Map<String, double>> groupDebts = debtsWithGroups[member] ?? {};

            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text('$member'),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: groupDebts.keys.length,
                    itemBuilder: (context, index) {
                      String groupName = groupDebts.keys.elementAt(index);
                      Map<String, double> memberDebts = groupDebts[groupName] ?? {};

                      // Calculate total owed and total owes within the group
                      double totalOwed = 0.0;
                      double totalOwes = 0.0;
                      memberDebts.forEach((debtor, amount) {
                        if (amount > 0) {
                          totalOwed += amount;
                        } else {
                          totalOwes += amount.abs();
                        }
                      });

                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Group: $groupName'),
                            Text('Gets: ${totalOwes.toStringAsFixed(2)}'),
                            Text('Owes: ${totalOwed.toStringAsFixed(2)}'),
                            if (totalOwed > 0)
                              Text(
                                  'To: ${memberDebts.keys.where((key) => memberDebts[key]! > 0).join(', ')}'),
                            if (totalOwes > 0)
                              Text('From: ${memberDebts.keys.where((key) => memberDebts[key]! < 0).join(', ')}'),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                // Example: settling half of totalOwes
                                _settleDebt(member, totalOwes / 2);
                              },
                              child: Text('Settle Your Buddy'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _navigateTo(String routeName) {
    if (routeName == '/login') {
      Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
    } else {
      Navigator.pushReplacementNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome to Splitwise App',
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                _navigateTo('/splitwise');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () {
                _navigateTo('/login'); // Navigate to Login page on Sign Out
              },
            ),
          ],
        ),
      ),
      body: _widgetOptions().elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Group',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey[850], // Color for the selected item
        unselectedItemColor: Colors.grey[400], // Color for unselected items
        onTap: _onItemTapped,
      ),
    );
  }
}
