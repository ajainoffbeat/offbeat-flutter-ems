import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  int _unreadCount = 0;

  int get unreadCount => _unreadCount;

  // Add a notification
  void addNotification() {
    _unreadCount++;
    notifyListeners();
  }

  // Clear all notifications
  void clearNotifications() {
    _unreadCount = 0;
    notifyListeners();
  }
}
