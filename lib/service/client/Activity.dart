import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference activitesCollection =
      FirebaseFirestore.instance.collection('activity');

  // Fonction pour récupérer toutes les activités
  Stream<QuerySnapshot> getActivites() {
    return activitesCollection.snapshots();
  }

  // Fonction pour ajouter une nouvelle activité
  Future<DocumentReference<Object?>> addActivite(
      String nom, String description) async {
    return await activitesCollection.add({
      'nom': nom,
      'description': description,
    });
  }

  // Fonction pour mettre à jour une activité
  Future<void> updateActivite(String id, String nom, String description) async {
    return await activitesCollection.doc(id).update({
      'nom': nom,
      'description': description,
    });
  }

  // Fonction pour supprimer une activité
  Future<void> deleteActivite(String id) async {
    return await activitesCollection.doc(id).delete();
  }
}
