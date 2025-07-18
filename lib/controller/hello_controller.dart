import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/show_toast_dialog.dart';

class HelloController extends GetxController {
  RxBool isLoading = true.obs;
  RxString userName = ''.obs;
  RxString userEmail = ''.obs;
  RxString userPhone = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;
      
      // Get current user from Firebase Auth
      User? currentUser = FirebaseAuth.instance.currentUser;
      
      if (currentUser != null) {
        // First, try to get data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          
          // Set user data from Firestore
          String firstName = userData['firstName'] ?? '';
          String lastName = userData['lastName'] ?? '';
          userName.value = '$firstName $lastName'.trim();
          
          if (userName.value.isEmpty) {
            userName.value = userData['fullName'] ?? 'User';
          }
          
          userEmail.value = userData['email'] ?? currentUser.email ?? '';
          userPhone.value = userData['phoneNumber'] ?? currentUser.phoneNumber ?? '';
        } else {
          // Fallback to Firebase Auth data if Firestore document doesn't exist
          userName.value = currentUser.displayName ?? 'User';
          userEmail.value = currentUser.email ?? '';
          userPhone.value = currentUser.phoneNumber ?? '';
        }
      } else {
        // No authenticated user, set default values
        userName.value = 'User';
        userEmail.value = '';
        userPhone.value = '';
      }
      
      // Ensure we have at least a name
      if (userName.value.isEmpty) {
        userName.value = 'User';
      }
      
    } catch (e) {
      print('Error fetching user data: $e');
      ShowToastDialog.showToast('Failed to load user data: ${e.toString()}');
      
      // Set default values on error
      userName.value = 'User';
      userEmail.value = '';
      userPhone.value = '';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshUserData() async {
    await fetchUserData();
  }
} 