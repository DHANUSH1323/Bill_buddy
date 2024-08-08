import 'package:flutter/foundation.dart';

class GroupProvider with ChangeNotifier {
  List<Map<String, dynamic>> _groups = [];

  List<Map<String, dynamic>> get groups => _groups;

  void addGroup(Map<String, dynamic> groupData) {
    _groups.add(groupData);
    notifyListeners();
  }

  void addMember(String groupName, String memberName) {
    int groupIndex = _groups.indexWhere((group) => group['groupName'] == groupName);
    if (groupIndex != -1) {
      if (_groups[groupIndex]['members'] == null) {
        _groups[groupIndex]['members'] = [];
      }
      _groups[groupIndex]['members'].add({
        'name': memberName,
        'amount': 0.0,
      });
      notifyListeners();
    }
  }

  void updateAmount(String groupName, String memberName, double amount) {
    int groupIndex = _groups.indexWhere((group) => group['groupName'] == groupName);
    if (groupIndex != -1) {
      int memberIndex = _groups[groupIndex]['members'].indexWhere((m) => m['name'] == memberName);
      if (memberIndex != -1) {
        _groups[groupIndex]['members'][memberIndex]['amount'] = amount;
        notifyListeners();
      }
    }
  }

  void removeMember(String groupName, String memberName) {
    int groupIndex = _groups.indexWhere((group) => group['groupName'] == groupName);
    if (groupIndex != -1) {
      _groups[groupIndex]['members'].removeWhere((member) => member['name'] == memberName);
      notifyListeners();
    }
  }

  void removeGroup(String groupName) {
    _groups.removeWhere((group) => group['groupName'] == groupName);
    notifyListeners();
  }

  Map<String, Map<String, Map<String, double>>> calculateDebtsWithGroups() {
    Map<String, Map<String, Map<String, double>>> debtsWithGroups = {};

    for (var group in _groups) {
      String groupName = group['groupName'] ?? 'Unknown';
      List<dynamic>? members = group['members'];
      String payer = group['payer'] ?? 'Unknown';

      if (members != null) {
        for (var member in members) {
          String memberName = member['name'] ?? '';
          double amountPaid = member['amount'] ?? 0.0;

          if (memberName != payer) {
            // Update debts for the member who paid
            if (!debtsWithGroups.containsKey(memberName)) {
              debtsWithGroups[memberName] = {};
            }
            if (!debtsWithGroups[memberName]!.containsKey(groupName)) {
              debtsWithGroups[memberName]![groupName] = {};
            }
            debtsWithGroups[memberName]![groupName]?[payer] =
                (debtsWithGroups[memberName]![groupName]?[payer] ?? 0.0) +
                    amountPaid;

            // Update debts for the payer
            if (!debtsWithGroups.containsKey(payer)) {
              debtsWithGroups[payer] = {};
            }
            if (!debtsWithGroups[payer]!.containsKey(groupName)) {
              debtsWithGroups[payer]![groupName] = {};
            }
            debtsWithGroups[payer]![groupName]?[memberName] =
                (debtsWithGroups[payer]![groupName]?[memberName] ?? 0.0) -
                    amountPaid;
          }
        }
      }
    }

    return debtsWithGroups;
  }

  void settleDebt(String memberName, double amountToSettle, Map<String, Map<String, double>> groupDebts) {
    if (groupDebts.containsKey(memberName)) {
      groupDebts[memberName]!.forEach((groupName, debt) {
        if (debt > 0) {
          if (debt >= amountToSettle) {
            groupDebts[memberName]![groupName] = debt - amountToSettle;
            amountToSettle = 0.0;
          } else {
            groupDebts[memberName]![groupName] = 0.0;
            amountToSettle -= debt;
          }
        } else {
          if (-debt >= amountToSettle) {
            groupDebts[memberName]![groupName] = debt + amountToSettle;
            amountToSettle = 0.0;
          } else {
            groupDebts[memberName]![groupName] = 0.0;
            amountToSettle += debt;
          }
        }
      });
    }

    notifyListeners();
  }
}