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
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign in an existing user
  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Update the display name of the current user
  Future<void> updateDisplayName(String name) async {
    await currentUser?.updateDisplayName(name);
    await currentUser?.reload(); // Refresh user data
  }

  // Sign out the current user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Save a recipe to Firestore
  Future<void> saveRecipe({
    required String name,
    required String description,
    String? imageUrl,
  }) async {
    if (currentUser == null) {
      throw Exception("No user signed in.");
    }

    final recipeData = {
      'name': name,
      'description': description,
      'imageUrl': imageUrl ?? '', // Store an empty string if no image
      'userId': currentUser!.uid, // Store the user ID
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('recipes').add(recipeData);
  }
}
