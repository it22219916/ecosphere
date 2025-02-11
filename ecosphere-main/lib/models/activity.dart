// lib/models/activity.dart

class Activity {
  final String activity;
  final String city;
  final String collectionTime;

  Activity({
    required this.activity,
    required this.city,
    required this.collectionTime,
  });

  factory Activity.fromMap(Map<String, dynamic> data) {
    return Activity(
      activity: data['activity'] ?? '',
      city: data['city'] ?? '',
      collectionTime: data['collectionTime'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'activity': activity,
      'city': city,
      'collectionTime': collectionTime,
    };
  }
}
