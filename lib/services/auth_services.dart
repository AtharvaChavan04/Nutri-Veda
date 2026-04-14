import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutri_veda/models/doctor_user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
    required String role, // doctor / patient
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = credential.user!;

      UserModel userModel = UserModel(
        uid: user.uid,
        fullName: fullName,
        email: email,
        role: role,
        isActive: true,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    } catch (e) {
      throw 'Something went wrong during sign up';
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        throw 'PROFILE_NOT_FOUND';
      }

      return UserModel.fromMap(doc.data()!);
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code}');
      throw _mapAuthError(e);
    } catch (e) {
      print('General Exception: ${e.toString()}');
      throw e.toString();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user == null) return null;

    DocumentSnapshot doc =
        await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'User with this email already exists';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'weak-password':
        return 'Password is too weak';
      case 'user-not-found':
        return 'No account found with this email';
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'wrong-password':
        return 'Incorrect password. Please try again';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Check your internet connection';
      default:
        return e.message ?? 'Authentication failed';
    }
  }
}
