import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
import 'group_provider.dart';

class GroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> groups = Provider.of<GroupProvider>(context).groups;

    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          final groupName = group['groupName'] ?? '';
          final List<dynamic> members = group['members'] ?? [];
          final String payer = group['payer'] ?? 'Unknown';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(groupName),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.person_add),
                          onPressed: () {
                            _showAddMemberDialog(context, groupName);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () {
                            _showRemoveMemberDialog(context, group);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                subtitle: Text('Paid by: $payer'),
                onTap: () {
                  // Handle tapping on group item here
                },
              ),
              Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: members.length,
                itemBuilder: (context, memberIndex) {
                  final member = members[memberIndex];
                  final String memberName = member['name'] ?? '';
                  final double amount = member['amount'] ?? 0.0;

                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(memberName),
                        ),
                        IconButton(
                          icon: Icon(Icons.attach_money),
                          onPressed: () {
                            _showAmountDialog(context, groupName, memberName);
                          },
                        ),
                      ],
                    ),
                    subtitle: Text('\$$amount'),
                  );
                },
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context, String groupName) {
    TextEditingController memberNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Member to $groupName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: memberNameController,
              decoration: InputDecoration(labelText: 'Member Name'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                String memberName = memberNameController.text.trim();
                if (memberName.isNotEmpty) {
                  _handleAddMember(context, groupName, memberName);
                  Navigator.pop(context);
                }
              },
              child: Text('Add Member'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAddMember(BuildContext context, String groupName, String memberName) {
    Provider.of<GroupProvider>(context, listen: false).addMember(groupName, memberName);
  }

  void _showRemoveMemberDialog(BuildContext context, Map<String, dynamic> group) {
    final List<dynamic> members = group['members'] ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove from ${group['groupName']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                _handleDeleteGroup(context, group);
                Navigator.pop(context);
              },
              child: Text('Delete Group'),
            ),
            Divider(),
            ...members.map<Widget>((member) {
              final memberName = member['name'];
              return ListTile(
                title: Text(memberName),
                onTap: () {
                  _handleRemoveMember(context, group, memberName);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _handleDeleteGroup(BuildContext context, Map<String, dynamic> group) {
    Provider.of<GroupProvider>(context, listen: false).removeGroup(group['groupName']);
  }

  void _handleRemoveMember(BuildContext context, Map<String, dynamic> group, String memberName) {
    Provider.of<GroupProvider>(context, listen: false).removeMember(group['groupName'], memberName);
  }

  void _showAmountDialog(BuildContext context, String groupName, String memberName) {
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Amount for $memberName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                double amount = double.tryParse(amountController.text) ?? 0.0;
                _handleAmountUpdate(context, groupName, memberName, amount);
                Navigator.pop(context);
              },
              child: Text('Set Amount Manually'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAmountUpdate(BuildContext context, String groupName, String memberName, double amount) {
    Provider.of<GroupProvider>(context, listen: false).updateAmount(groupName, memberName, amount);
  }
}
