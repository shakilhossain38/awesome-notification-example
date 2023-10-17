int createUniqueId() {
  final now = DateTime.now();
  final id = now.millisecondsSinceEpoch ~/ 1000;
  return id;
}

class NotificationWeekAndTime {
  final int hour;
  final int minute;
  NotificationWeekAndTime({required this.hour, required this.minute});
}
