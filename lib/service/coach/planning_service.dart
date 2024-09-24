import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlanningService {
  final String coachId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, String>>> fetchPlanning(DateTime selectedDay) async {
    String dateString =
        '${selectedDay.year.toString().padLeft(4, '0')}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}';

    QuerySnapshot snapshot = await _firestore
        .collection('plannig')
        .where('coachID', isEqualTo: coachId)
        .where('date', isEqualTo: dateString)
        .get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'hour': doc['hour'] as String, // Assurez-vous que c'est une chaîne
      };
    }).toList();
  }

  Future<void> savePlanning(DateTime day, String timeRange) async {
    String dateString =
        '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

    await _firestore.collection('plannig').add({
      'coachID': coachId,
      'date': dateString,
      'hour': timeRange,
      'userID':
          'users/YOUR_USER_ID', // Remplacez par l'ID utilisateur approprié
    });
  }

  Future<void> updatePlanning(String id, String timeRange) async {
    await _firestore.collection('plannig').doc(id).update({
      'hour': timeRange,
    });
  }

  Future<void> deletePlanning(String id) async {
    await _firestore.collection('plannig').doc(id).delete();
  }
}
