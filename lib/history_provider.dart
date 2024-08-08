import 'package:flutter/foundation.dart';

/// Model representing a history entry.
class HistoryEntry {
  final String activity;
  final DateTime timestamp;

  HistoryEntry({
    required this.activity,
    required this.timestamp,
  });
}

class HistoryProvider with ChangeNotifier {
  List<HistoryEntry> get _history => [];

  List<HistoryEntry> get history => _history;

  void addToHistory(String activity) {
    _history.add(HistoryEntry(activity: activity, timestamp: DateTime.now()));
    notifyListeners();
  }
}
