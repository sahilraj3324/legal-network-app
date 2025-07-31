import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/fire_store_utils.dart';
import '../model/user_model.dart';
import '../app/main_navigation.dart';
import '../app/onboarding_screen/onboarding_screen.dart';

class AuthController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool isAuthenticated = false.obs;
  RxBool _isNavigating = false.obs; // Navigation guard
  
  @override
  void onInit() {
    super.onInit();
    // Add a small delay to prevent immediate navigation conflicts
    Future.delayed(const Duration(milliseconds: 100), () {
      _checkAuthState();
    });
  }

  Future<void> _checkAuthState() async {
    try {
      isLoading.value = true;
      
      // Check if already navigating to prevent race conditions
      if (_isNavigating.value) {
        print('Navigation already in progress, skipping...');
        isLoading.value = false;
        return;
      }
      
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
          print('User profile is complete');
          _navigateToScreen(() => const MainNavigationScreen());
        } else {
          // User is authenticated but hasn't completed profile
          isAuthenticated.value = false;
          print('User profile is incomplete, navigating to onboarding');
          _navigateToScreen(() => const OnboardingScreen());
        }
      } else {
        // User is not authenticated
        isAuthenticated.value = false;
        print('User is not authenticated, navigating to onboarding');
        _navigateToScreen(() => const OnboardingScreen());
      }
    } catch (e) {
      print('Error checking auth state: $e');
      isAuthenticated.value = false;
      _navigateToScreen(() => const OnboardingScreen());
    } finally {
      isLoading.value = false;
    }
  }

  // Safe navigation method with guards
  void _navigateToScreen(Widget Function() screenBuilder) {
    if (_isNavigating.value) {
      print('Navigation already in progress, ignoring request');
      return;
    }
    
    _isNavigating.value = true;
    
    // Use a small delay to ensure UI is ready and prevent conflicts
    Future.delayed(const Duration(milliseconds: 200), () {
      try {
        if (Get.context != null) {
          Get.offAll(screenBuilder);
        }
      } catch (e) {
        print('Navigation error: $e');
      } finally {
        // Reset navigation flag after a delay
        Future.delayed(const Duration(milliseconds: 500), () {
          _isNavigating.value = false;
        });
      }
    });
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      isAuthenticated.value = false;
      _navigateToScreen(() => const OnboardingScreen());
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> refreshAuthState() async {
    // Only refresh if not currently navigating
    if (!_isNavigating.value) {
      await _checkAuthState();
    }
  }
} 