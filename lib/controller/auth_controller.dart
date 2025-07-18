import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/fire_store_utils.dart';
import '../model/user_model.dart';
import '../app/hello_screen.dart';
import '../app/onboarding_screen/onboarding_screen.dart';

class AuthController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool isAuthenticated = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    try {
      isLoading.value = true;
      
      // Check if user is signed in
      User? currentUser = FirebaseAuth.instance.currentUser;
      
      if (currentUser != null) {
        print('User is authenticated: ${currentUser.uid}');
        
        // Check if user has completed profile
        UserModel? userModel = await FireStoreUtils.getCurrentUser();
        
        if (userModel != null && 
            userModel.fullName != null && 
            userModel.fullName!.isNotEmpty) {
          // User is authenticated and has completed profile
          isAuthenticated.value = true;
          print('User profile is complete, navigating to hello screen');
          Get.offAll(() => const HelloScreen());
        } else {
          // User is authenticated but hasn't completed profile
          isAuthenticated.value = false;
          print('User profile is incomplete, navigating to onboarding');
          Get.offAll(() => const OnboardingScreen());
        }
      } else {
        // User is not authenticated
        isAuthenticated.value = false;
        print('User is not authenticated, navigating to onboarding');
        Get.offAll(() => const OnboardingScreen());
      }
    } catch (e) {
      print('Error checking auth state: $e');
      isAuthenticated.value = false;
      Get.offAll(() => const OnboardingScreen());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      isAuthenticated.value = false;
      Get.offAll(() => const OnboardingScreen());
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> refreshAuthState() async {
    await _checkAuthState();
  }
} 