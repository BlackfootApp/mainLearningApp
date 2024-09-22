import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'local_notification.dart';

DateTime curTime = DateTime.now();

class NotificationProvider extends ChangeNotifier {
  int _remindTimeHr = curTime.hour;
  int _remindTimeMin = curTime.minute;
  int _remindTimeSec = curTime.second;
  double _commitedTime = 5;
  bool _isReminderOn = false;

  int get remindTimeHr => _remindTimeHr;
  int get remindTimeMin => _remindTimeMin;
  int get remindTimeSec => _remindTimeSec;
  double get commitedTime => _commitedTime;
  bool get isReminderOn => _isReminderOn;

  void loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _remindTimeHr = prefs.getInt('remindTimeHr') ?? curTime.hour;
    _remindTimeMin = prefs.getInt('remindTimeMin') ?? curTime.minute;
    _remindTimeSec = prefs.getInt('remindTimeSec') ?? curTime.second;
    _isReminderOn = prefs.getBool('isReminderOn') ?? false;
    _commitedTime = prefs.getDouble('commitedTime') ?? 5;
    notifyListeners();
  }

  void saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('remindTimeHr', _remindTimeHr);
    await prefs.setInt('remindTimeMin', _remindTimeMin);
    await prefs.setInt('remindTimeSec', _remindTimeSec);
    await prefs.setBool('isReminderOn', _isReminderOn);
    await prefs.setDouble('commitedTime', _commitedTime);
  }

  // Modified to cancel or schedule notifications
  void toggleReminderMode() {
    _isReminderOn = !_isReminderOn;

    if (!_isReminderOn) {
      // Cancel all notifications when reminder is turned off
      LocalNotifications.cancelAllNotifications();
    } else {
      // Schedule the reminder when turned on
      LocalNotifications.scheduleDailyReminder(
          _remindTimeHr, _remindTimeMin, _remindTimeSec);
    }

    saveSettings();
    notifyListeners();
  }

  void setRemindTime(int hr, int min, int sec) {
    _remindTimeHr = hr;
    _remindTimeMin = min;
    _remindTimeSec = sec;
    saveSettings();
    notifyListeners();
  }
}
