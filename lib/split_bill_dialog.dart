import 'package:flutter/material.dart';

class SplitBillDialog extends StatefulWidget {
  final Map<String, dynamic> group;
  final Function(Map<String, double>) onSplit;

  SplitBillDialog({required this.group, required this.onSplit});

  @override
  _SplitBillDialogState createState() => _SplitBillDialogState();
}

class _SplitBillDialogState extends State<SplitBillDialog> {
  final _totalAmountController = TextEditingController();
  final Map<String, TextEditingController> _individualAmountControllers = {};

  bool _isEqualSplit = true;

  @override
  void initState() {
    super.initState();
    widget.group['members'].forEach((member) {
      _individualAmountControllers[member] = TextEditingController();
    });
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _individualAmountControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _splitBill() {
    Map<String, double> splitAmounts = {};

    if (_isEqualSplit) {
      double totalAmount = double.tryParse(_totalAmountController.text) ?? 0;
      double splitAmount = totalAmount / widget.group['members'].length;
      widget.group['members'].forEach((member) {
        splitAmounts[member] = splitAmount;
      });
    } else {
      widget.group['members'].forEach((member) {
        double amount = double.tryParse(_individualAmountControllers[member]!.text) ?? 0;
        splitAmounts[member] = amount;
      });
    }

    widget.onSplit(splitAmounts);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Split Bill'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _totalAmountController,
              decoration: InputDecoration(labelText: 'Total Amount'),
              keyboardType: TextInputType.number,
            ),
            SwitchListTile(
              title: Text('Split Equally'),
              value: _isEqualSplit,
              onChanged: (bool value) {
                setState(() {
                  _isEqualSplit = value;
                });
              },
            ),
            if (!_isEqualSplit)
              ...widget.group['members'].map((member) {
                return TextFormField(
                  controller: _individualAmountControllers[member],
                  decoration: InputDecoration(labelText: '$member\'s Amount'),
                  keyboardType: TextInputType.number,
                );
              }).toList(),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Split'),
          onPressed: _splitBill,
        ),
      ],
    );
  }
}
