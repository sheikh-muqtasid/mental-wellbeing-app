import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mental_wellbeing/models/firebase_service.dart';
import 'package:logger/logger.dart';

class UserData {
  static String? userId;
  static Map<String, dynamic>? currentUserData;

  static var logger = Logger();

  static Future<void> initialize() async {
    userId ??= FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      try {
        var documentSnapshot = await FirebaseService.getPatientData(userId!);

        if (documentSnapshot.exists) {
          currentUserData = documentSnapshot.data() as Map<String, dynamic>;
          logger.i('User data fetched successfully.');
        } else {
          logger.w('No user data found for this user.');
        }
      } catch (e) {
        logger.e('Error fetching user data: $e');
      }
    } else {
      logger.w('User not logged in.');
    }
  }

  static Future<void> saveDemographics(Map<String, String> data) async {
    if (_ensureUserIdInitialized()) {
      try {
        await FirebaseService.saveDemographics(userId!, data);
        logger.i('Demographics saved successfully.');
      } catch (e) {
        logger.e('Error saving demographics: $e');
      }
    } else {
      logger.e('Error: Cannot save demographics without user ID');
    }
  }

  static Future<void> updateConsent(bool consent) async {
    if (_ensureUserIdInitialized()) {
      try {
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(userId)
            .update({'consentToShare': consent});
        logger.i('Consent updated successfully');
      } catch (e) {
        logger.e('Error updating consent: $e');
      }
    } else {
      logger.w('User not logged in.');
    }
  }

  static bool _ensureUserIdInitialized() {
    userId ??= FirebaseAuth.instance.currentUser?.uid;
    return userId != null;
  }

  static Future<void> addDiaryEntry(int sessionNumber, String text) async {
    if (_ensureUserIdInitialized()) {
      try {
        await FirebaseFirestore.instance
            .collection('diaryEntries')
            .doc(userId)
            .collection('sessions')
            .doc(sessionNumber.toString())
            .set({
          'text': text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        logger.i('Diary entry added for session $sessionNumber');
      } catch (e) {
        logger.e('Error adding diary entry for session $sessionNumber: $e');
      }
    }
  }

  static Future<void> editDiaryEntry(int sessionNumber, String newText) async {
    if (_ensureUserIdInitialized()) {
      try {
        await FirebaseFirestore.instance
            .collection('diaryEntries')
            .doc(userId)
            .collection('sessions')
            .doc(sessionNumber.toString())
            .update({
          'text': newText,
          'timestamp': FieldValue.serverTimestamp(),
        });
        logger.i('Diary entry edited for session $sessionNumber');
      } catch (e) {
        logger.e('Error editing diary entry for session $sessionNumber: $e');
      }
    }
  }

  static Future<void> deleteDiaryEntry(int sessionNumber) async {
    if (_ensureUserIdInitialized()) {
      try {
        await FirebaseFirestore.instance
            .collection('diaryEntries')
            .doc(userId)
            .collection('sessions')
            .doc(sessionNumber.toString())
            .delete();
        logger.i('Diary entry deleted for session $sessionNumber');
      } catch (e) {
        logger.e('Error deleting diary entry for session $sessionNumber: $e');
      }
    }
  }

  static Future<String?> getDiaryEntry(int sessionNumber) async {
    if (_ensureUserIdInitialized()) {
      try {
        var docSnapshot = await FirebaseFirestore.instance
            .collection('diaryEntries')
            .doc(userId)
            .collection('sessions')
            .doc(sessionNumber.toString())
            .get();
        if (docSnapshot.exists) {
          var diaryData = docSnapshot.data();
          return diaryData?['text'] ?? '';
        } else {
          logger.w('No diary entry found for session $sessionNumber');
          return null;
        }
      } catch (e) {
        logger.e('Error retrieving diary entry for session $sessionNumber: $e');
        return null;
      }
    }
    return null;
  }

  static void saveNegativeBeliefs(List<Map<String, dynamic>> beliefs) {
    logger.i('Negative beliefs saved');
  }
}
