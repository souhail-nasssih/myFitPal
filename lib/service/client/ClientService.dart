import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClientService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> getClientData() async {
    String userId = _auth.currentUser?.uid ?? '';

    if (userId.isNotEmpty) {
      try {
        DocumentSnapshot documentSnapshot =
            await _firestore.collection('clients').doc(userId).get();

        if (documentSnapshot.exists) {
          return documentSnapshot.data() as Map<String, dynamic>;
        } else {
          return {}; // No data found
        }
      } catch (e) {
        throw 'Error fetching user data: $e';
      }
    }
    return {};
  }

  Future<void> updateClientData(Map<String, dynamic> data) async {
    String userId = _auth.currentUser?.uid ?? '';

    if (userId.isNotEmpty) {
      try {
        await _firestore.collection('clients').doc(userId).update(data);
      } catch (e) {
        throw 'Error updating user data: $e';
      }
    } else {
      throw 'User ID is empty';
    }
  }

  // Nouvelle méthode pour gérer les données d'édition
  Future<void> editClientData(Map<String, dynamic> newData) async {
    await updateClientData(newData);
  }
}
