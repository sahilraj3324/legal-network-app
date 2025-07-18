import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseTest {
  static Future<bool> testFirebaseConnection() async {
    try {
      print('Testing Firebase connection...');
      
      // Check if user is authenticated
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('❌ No authenticated user found');
        return false;
      }
      
      print('✅ User authenticated with UID: ${user.uid}');
      
      // Test write permission
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'test': 'connection'}, SetOptions(merge: true));
      
      print('✅ Write permission successful');
      
      // Test read permission
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      if (doc.exists) {
        print('✅ Read permission successful');
        return true;
      } else {
        print('❌ Document does not exist after write');
        return false;
      }
      
    } catch (e) {
      print('❌ Firebase test failed: $e');
      
      if (e.toString().contains('permission-denied')) {
        print('');
        print('🔥 FIREBASE SECURITY RULES ISSUE:');
        print('You need to update your Firestore security rules.');
        print('');
        print('Go to Firebase Console → Firestore Database → Rules');
        print('And add these rules:');
        print('');
        print('rules_version = \'2\';');
        print('service cloud.firestore {');
        print('  match /databases/{database}/documents {');
        print('    match /users/{userId} {');
        print('      allow read, write: if request.auth != null && request.auth.uid == userId;');
        print('    }');
        print('  }');
        print('}');
        print('');
      }
      
      return false;
    }
  }
} 