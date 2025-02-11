// lib/services/firestore_service.dart

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/schedule.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all schedules
  Future<List<Schedule>> getAllSchedules() async {
    try {
      QuerySnapshot snapshot = await _db.collection('schedules').get();
      return snapshot.docs.map((doc) => Schedule.fromDocument(doc)).toList();
    } catch (e) {
      log('Error fetching schedules: $e');
      return [];
    }
  }

  // Fetch schedules for a specific date
  Future<List<Schedule>> getSchedulesForDate(DateTime date) async {
    try {
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));

      QuerySnapshot snapshot = await _db
          .collection('schedules')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      return snapshot.docs.map((doc) => Schedule.fromDocument(doc)).toList();
    } catch (e) {
      log('Error fetching schedules for date: $e');
      return [];
    }
  }

  // Add a new schedule with multiple activities
  Future<void> addSchedule(Schedule schedule) async {
    try {
      await _db.collection('schedules').add(schedule.toMap());
      log('Schedule added successfully');
    } catch (e) {
      log('Error adding schedule: $e');
    }
  }

  // Update an existing schedule
  Future<void> updateSchedule(String id, Schedule schedule) async {
    try {
      await _db.collection('schedules').doc(id).update(schedule.toMap());
      log('Schedule updated successfully');
    } catch (e) {
      log('Error updating schedule: $e');
    }
  }

  // Delete a schedule by id
  Future<void> deleteSchedule(String id) async {
    try {
      await _db.collection('schedules').doc(id).delete();
      log('Schedule deleted successfully');
    } catch (e) {
      log('Error deleting schedule: $e');
    }
  }

  // Stream of schedules for real-time updates
  Stream<List<Schedule>> getAllSchedulesStream() {
    return _db.collection('schedules').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Schedule.fromDocument(doc)).toList();
    });
  }
}
