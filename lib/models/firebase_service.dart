import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<User?> signInWithGooglePatient(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final doc = await _firestore.collection('patients').doc(user.uid).get();
        if (!doc.exists) {
          await _firestore.collection('patients').doc(user.uid).set({
            'uid': user.uid,
            'email': user.email,
            'displayName': user.displayName,
            'photoURL': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'userType': 'patient',
            'consentToShare': false,
            'demographics': null,
          });
        }
        return user;
      }
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing in: ${e.toString()}')),
      );
      return null;
    }
  }

  static Future<User?> signInWithGoogleDoctor(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final doc = await _firestore.collection('doctors').doc(user.uid).get();
        if (!doc.exists) {
          await _firestore.collection('doctors').doc(user.uid).set({
            'uid': user.uid,
            'email': user.email,
            'displayName': user.displayName,
            'photoURL': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'userType': 'doctor',
            'specialisation': '',
            'contact': '',
            'bookingDetails': '',
          });
        }
        return user;
      }
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing in: ${e.toString()}')),
      );
      return null;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  static Stream<QuerySnapshot> getPatientReports(String doctorId) {
    return _firestore
        .collection('patients')
        .where('doctorId', isEqualTo: doctorId)
        .snapshots();
  }

  static Future<void> updateConsent(String userId, bool consent) async {
    await _firestore.collection('patients').doc(userId).update({
      'consentToShare': consent,
    });
  }

  static Future<DocumentSnapshot> getPatientData(String userId) async {
    return await _firestore.collection('patients').doc(userId).get();
  }

  static Future<void> saveDemographics(
      String userId, Map<String, dynamic> data) async {
    final docSnapshot =
        await _firestore.collection('patients').doc(userId).get();
    if (docSnapshot.exists) {
      await _firestore.collection('patients').doc(userId).update({
        'demographics': data,
      });
    } else {
      await _firestore.collection('patients').doc(userId).set({
        'uid': userId,
        'demographics': data,
      });
    }
  }
}
