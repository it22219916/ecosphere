import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSchedules() async {
    // Sample waste schedules with city and collection time for each activity
    List<Map<String, dynamic>> schedules = [
      {
        'date': Timestamp.fromDate(DateTime.parse('2024-10-07T00:00:00Z')),
        'activities': [
          {
            'activity': 'Recyclable Waste Collection',
            'city': 'City A',
            'collectionTime': '08:00 AM',
          },
          {
            'activity': 'E-Waste Collection',
            'city': 'City A',
            'collectionTime': '10:00 AM',
          },
          {
            'activity': 'Battery Collection',
            'city': 'City B',
            'collectionTime': '12:00 PM',
          },
          {
            'activity': 'Plastics Recycling Collection',
            'city': 'City B',
            'collectionTime': '02:00 PM',
          },
        ],
      },
      {
        'date': Timestamp.fromDate(DateTime.parse('2024-10-16T00:00:00Z')),
        'activities': [
          {
            'activity': 'Organic Waste Collection',
            'city': 'City C',
            'collectionTime': '09:00 AM',
          },
          {
            'activity': 'General Waste Collection',
            'city': 'City C',
            'collectionTime': '11:00 AM',
          },
        ],
      },
      {
        'date': Timestamp.fromDate(DateTime.parse('2024-10-17T00:00:00Z')),
        'activities': [
          {
            'activity': 'General Waste Collection',
            'city': 'City A',
            'collectionTime': '08:00 AM',
          },
          {
            'activity': 'Hazardous Waste Collection',
            'city': 'City A',
            'collectionTime': '10:00 AM',
          },
          {
            'activity': 'Medical Waste Collection',
            'city': 'City B',
            'collectionTime': '12:00 PM',
          },
        ],
      },
      {
        'date': Timestamp.fromDate(DateTime.parse('2024-10-20T00:00:00Z')),
        'activities': [
          {
            'activity': 'E-Waste Collection',
            'city': 'City B',
            'collectionTime': '09:00 AM',
          },
          {
            'activity': 'Recyclable Waste Collection',
            'city': 'City B',
            'collectionTime': '11:00 AM',
          },
        ],
      },
      // Add more schedules similarly...
    ];

    for (var schedule in schedules) {
      await _firestore.collection('schedules').add(schedule);
    }

    log('Schedules with activities, cities, and collection times added successfully');
  }
}
