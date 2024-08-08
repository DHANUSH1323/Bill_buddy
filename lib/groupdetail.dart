import 'package:flutter/material.dart';
import 'split_bill_dialog.dart';

class GroupDetailPage extends StatefulWidget {
  final Map<String, dynamic> group;

  GroupDetailPage({required this.group});

  @override
  _GroupDetailPageState createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  Map<String, double> _splitAmounts = {};

  void _handleSplitAmounts(Map<String, double> splitAmounts) {
    setState(() {
      _splitAmounts = splitAmounts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group['groupName']),
      ),
      body: ListView.builder(
        itemCount: widget.group['members'].length,
        itemBuilder: (context, index) {
          String member = widget.group['members'][index];
          return ListTile(
            title: Text(member),
            subtitle: _splitAmounts.containsKey(member)
                ? Text('Amount: \$${_splitAmounts[member]!.toStringAsFixed(2)}')
                : null,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SplitBillDialog(
                    group: widget.group,
                    onSplit: _handleSplitAmounts,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
