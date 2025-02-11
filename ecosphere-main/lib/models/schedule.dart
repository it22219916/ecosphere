// lib/models/schedule.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'activity.dart';

class Schedule {
  final String id;
  final DateTime date;
  final List<Activity> activities;

  Schedule({
    required this.id,
    required this.date,
    required this.activities,
  });

  factory Schedule.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    List<dynamic> activityList = data['activities'] ?? [];

    return Schedule(
      id: doc.id,
      date: (data['date'] as Timestamp).toDate(),
      activities: activityList.map((activityData) {
        return Activity.fromMap(activityData as Map<String, dynamic>);
      }).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'activities': activities.map((activity) => activity.toMap()).toList(),
    };
  }
}
