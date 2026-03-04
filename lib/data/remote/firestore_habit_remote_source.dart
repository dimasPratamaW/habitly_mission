import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitly_mission/data/remote/i_habit_remote_source.dart';
import 'package:habitly_mission/data/models/habit_model.dart';

class FirestoreHabitRemoteSource implements IHabitRemoteSource {
  final FirebaseFirestore _firestore;
  FirestoreHabitRemoteSource(this._firestore);

  CollectionReference _habitCollection(String uid) =>
      _firestore.collection('users').doc(uid).collection('habits');

  @override
  Stream<List<HabitModel>> getHabits(String uid) {
    return _habitCollection(uid).snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) =>
                HabitModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList(),
    );
  }

  @override
  Future<void> addHabit(HabitModel habit) async{
    await _habitCollection(habit.uid).add(habit.toMap());
  }

  @override
  Future<void> deleteHabit(String uid, String habitId) async{
    await _habitCollection(uid).doc(habitId).delete();
  }

}
