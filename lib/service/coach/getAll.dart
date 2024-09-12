import 'package:cloud_firestore/cloud_firestore.dart';

class GetAllCoachService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode pour récupérer tous les profils de coachs filtrés par activityID
  Future<List<Map<String, dynamic>>> fetchAllProfiles(String activityID) async {
    try {
      final querySnapshot = await _firestore
          .collection('coaches')
          .where('activityIDs', arrayContains: activityID)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'fullname': data['fullName'] ?? 'Nom inconnu',
          'pricing': data['pricing'] ?? 0,
          'duration': data['duration'] ?? 'Durée inconnue',
          'certifications': data['certifications'] ?? 'Pas de certification',
          'city': data['city'] ?? 'Ville inconnue',
          'image': data['image'] ?? 'images/4.jpg',
          'email': data['email'] ?? 'email@example.com',
          'birthday':
              (data['birthday'] as Timestamp?)?.toDate().toLocal().toString() ??
                  'Date inconnue',
        };
      }).toList();
    } catch (e) {
      print('Erreur lors de la récupération des profils: $e');
      return [];
    }
  }

  // Méthode pour récupérer la ville du client
  Future<String> fetchClientCity(String userId) async {
    try {
      final userDoc = await _firestore.collection('clients').doc(userId).get();
      final data = userDoc.data();
      return data?['city'] ?? 'Ville inconnue';
    } catch (e) {
      print('Erreur lors de la récupération de la ville du client: $e');
      return 'Ville inconnue';
    }
  }

  // Méthode pour récupérer les profils de coachs filtrés par ville et terme de recherche
  Future<List<Map<String, dynamic>>> fetchProfilesByCity(
    String activityID,
    String city,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('coaches')
          .where('activityIDs', arrayContains: activityID)
          .where('city', isEqualTo: city)
          .get();

      print(
          'Query snapshot: ${querySnapshot.docs.map((doc) => doc.data()).toList()}');

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'fullname': data['fullName'] ?? 'Nom inconnu',
          'pricing': data['pricing'] ?? 0,
          'duration': data['duration'] ?? 'Durée inconnue',
          'certifications': data['certifications'] ?? 'Pas de certification',
          'city': data['city'] ?? 'Ville inconnue',
          'image': data['image'] ?? 'images/4.jpg',
          'email': data['email'] ?? 'email@example.com',
          'birthday':
              (data['birthday'] as Timestamp?)?.toDate().toLocal().toString() ??
                  'Date inconnue',
        };
      }).toList();
    } catch (e) {
      print('Erreur lors de la récupération des profils par ville: $e');
      return [];
    }
  }
}
