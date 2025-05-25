import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authChanges => _firebaseAuth.authStateChanges();

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception("Failed to register: $e");
    }
  }

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception("Failed to sign in: $e");
    }
  }

  Future<void> updateDisplayName(String name) async {
    try {
      await currentUser?.updateDisplayName(name);
      await currentUser?.reload();
    } catch (e) {
      throw Exception("Failed to update display name: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception("Failed to sign out: $e");
    }
  }

  Future<String> saveRecipe({
    required String name,
    required String description,
    String? imageUrl,
    required List<Map<String, dynamic>> steps,
  }) async {
    if (currentUser == null) {
      throw Exception("No user signed in.");
    }

    final recipeData = {
      'name': name.trim(),
      'description': description.trim(),
      'imageUrl': imageUrl ?? '',
      'userId': currentUser!.uid,
      'steps': steps,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      final docRef = await _firestore.collection('recipes').add(recipeData);
      return docRef.id;
    } catch (e) {
      throw Exception("Failed to save recipe: $e");
    }
  }

  Future<void> updateRecipe({
    required String recipeId,
    required String name,
    required String description,
    String? imageUrl,
    required List<Map<String, dynamic>> steps,
  }) async {
    final updateData = {
      'name': name.trim(),
      'description': description.trim(),
      'steps': steps,
    };

    if (imageUrl != null) {
      updateData['imageUrl'] = imageUrl;
    }

    try {
      await _firestore.collection('recipes').doc(recipeId).update(updateData);
    } catch (e) {
      throw Exception("Failed to update recipe: $e");
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _firestore.collection('recipes').doc(recipeId).delete();
    } catch (e) {
      throw Exception("Failed to delete recipe: $e");
    }
  }
}
