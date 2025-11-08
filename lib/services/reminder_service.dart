import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financing_app/models/reminder.dart';

class ReminderService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('reminders');

  Future<void> addReminder(Reminder reminder) async {
    await _collection.add(reminder.toMap());
  }

  Future<void> updateReminder(String id, Reminder reminder) async {
    await _collection.doc(id).update(reminder.toMap());
  }

  Future<void> deleteReminder(String id) async {
    await _collection.doc(id).delete();
  }

  Stream<List<Reminder>> getReminders() {
    return _collection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Reminder.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }
}