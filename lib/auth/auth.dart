import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the current signed-in user
  User? get currentUser => _firebaseAuth.currentUser;

  // Listen to auth state changes
  Stream<User?> get authChanges => _firebaseAuth.authStateChanges();

  // Create a new user account with email and password
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

  // Sign in an existing user
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

  // Update the display name of the current user
  Future<void> updateDisplayName(String name) async {
    try {
      await currentUser?.updateDisplayName(name);
      await currentUser?.reload(); // Refresh user data
    } catch (e) {
      throw Exception("Failed to update display name: $e");
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception("Failed to sign out: $e");
    }
  }

  // Save a recipe to Firestore and return the document ID
  Future<String> saveRecipe({
    required String name,
    required String description,
    String? imageUrl,
  }) async {
    if (currentUser == null) {
      throw Exception("No user signed in.");
    }

    final recipeData = {
      'name': name.trim(),
      'description': description.trim(),
      'imageUrl': imageUrl ?? '',
      'userId': currentUser!.uid,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      final docRef = await _firestore.collection('recipes').add(recipeData);
      return docRef.id;
    } catch (e) {
      throw Exception("Failed to save recipe: $e");
    }
  }

  // Update a recipe using its ID
  Future<void> updateRecipe({
    required String recipeId,
    required String name,
    required String description,
    String? imageUrl, // optional: only update if provided
  }) async {
    final updateData = {
      'name': name.trim(),
      'description': description.trim(),
      'timestamp': FieldValue.serverTimestamp(),
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

  // Delete a recipe using its ID
  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _firestore.collection('recipes').doc(recipeId).delete();
    } catch (e) {
      throw Exception("Failed to delete recipe: $e");
    }
  }
}
