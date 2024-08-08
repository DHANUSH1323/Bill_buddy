import 'package:flutter/material.dart';

typedef OnCreateGroupCallback = void Function(Map<String, dynamic> groupData);

class AddGroup extends StatefulWidget {
  final OnCreateGroupCallback onCreateGroup;

  AddGroup({required this.onCreateGroup});

  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  final _membersController = TextEditingController();
  final _payerController = TextEditingController(); // New controller for payer
  final _totalAmountController = TextEditingController(); // Controller for total amount

  @override
  void dispose() {
    _groupNameController.dispose();
    _membersController.dispose();
    _payerController.dispose(); // Dispose of the new controller
    _totalAmountController.dispose(); // Dispose of the total amount controller
    super.dispose();
  }

  void _createGroup(Map<String, dynamic> groupData) {
    widget.onCreateGroup(groupData);
  }

  void _splitEqually() {
    if (_formKey.currentState!.validate()) {
      String groupName = _groupNameController.text;
      String membersString = _membersController.text;
      String payer = _payerController.text.trim();
      double totalAmount = double.tryParse(_totalAmountController.text) ?? 0.0;

      List<String> members = membersString.split(',').map((member) => member.trim()).toList();

      if (totalAmount > 0 && members.isNotEmpty) {
        double splitAmount = totalAmount / members.length;

        List<Map<String, dynamic>> groupMembers = members.map((member) {
          return {
            'name': member,
            'amount': splitAmount,
          };
        }).toList();

        Map<String, dynamic> groupData = {
          'groupName': groupName,
          'members': groupMembers,
          'payer': payer,
          'totalAmount': totalAmount,
        };

        _createGroup(groupData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Group'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _groupNameController,
                decoration: InputDecoration(labelText: 'Group Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a group name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _membersController,
                decoration: InputDecoration(labelText: 'Members (comma separated)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter at least one member';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _payerController,
                decoration: InputDecoration(labelText: 'Who paid this bill?'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name of the person who paid';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _totalAmountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Total Amount'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the total amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _splitEqually,
                child: Text('Split Equally Among Members'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
