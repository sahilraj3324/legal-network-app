import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leagel_1/model/user_model.dart';

class FireStoreUtils {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static String getCurrentUid() {
    return auth.currentUser?.uid ?? '';
  }

  static Future<bool> updateUser(UserModel userModel) async {
    try {
      String uid = getCurrentUid();
      if (uid.isEmpty) {
        print('❌ Error: No authenticated user found');
        return false;
      }
      
      print('📝 Saving user data to Firestore for UID: $uid');
      print('📋 User data keys: ${userModel.toJson().keys.toList()}');
      print('📋 Full user data: ${userModel.toJson()}');
      
      await firestore.collection('users').doc(uid).set(userModel.toJson(), SetOptions(merge: true));
      
      print('✅ User data saved successfully to Firestore');
      return true;
    } catch (e) {
      print('❌ Error updating user in Firestore: $e');
      if (e.toString().contains('permission-denied')) {
        print('🔒 Permission denied - Check your Firestore security rules');
        print('📋 Make sure your Firestore rules allow authenticated users to write to their own documents');
      } else if (e.toString().contains('network')) {
        print('🌐 Network error - Check your internet connection');
      }
      return false;
    }
  }

  static Future<UserModel?> getCurrentUser() async {
    try {
      DocumentSnapshot userDoc = await firestore.collection('users').doc(getCurrentUid()).get();
      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }
} 