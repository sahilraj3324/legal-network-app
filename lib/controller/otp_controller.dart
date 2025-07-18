import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/show_toast_dialog.dart';
import '../app/information_screen/information_screen.dart';
import '../app/hello_screen.dart';
import '../model/user_model.dart';
import '../utils/fire_store_utils.dart';

class OtpController extends GetxController {
  Rx<TextEditingController> otpController = TextEditingController().obs;
  RxString countryCode = "".obs;
  RxString phoneNumber = "".obs;
  RxString verificationId = "".obs;
  RxInt resendToken = 0.obs;
  RxBool isLoading = true.obs;
  RxBool isSignUp = false.obs;
  RxBool isVerifying = false.obs;

  @override
  void onInit() {
    getArguments();
    super.onInit();
  }

  // Get arguments passed from previous screen
  getArguments() {
    try {
      dynamic argumentData = Get.arguments;
      if (argumentData != null) {
        countryCode.value = argumentData['countryCode'] ?? '';
        phoneNumber.value = argumentData['phoneNumber'] ?? '';
        verificationId.value = argumentData['verificationId'] ?? '';
        isSignUp.value = argumentData['isSignUp'] ?? false;
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('Error getting arguments: $e');
    }
  }

  // Send OTP without visible CAPTCHA
  Future<bool> sendOTP() async {
    try {
      ShowToastDialog.showLoader("Sending OTP...");
      
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "${countryCode.value}${phoneNumber.value}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto sign-in on Android without CAPTCHA
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);
            ShowToastDialog.closeLoader();
            _handleSuccessfulAuth();
          } catch (e) {
            ShowToastDialog.closeLoader();
            ShowToastDialog.showToast("Authentication failed. Please try again.");
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          ShowToastDialog.closeLoader();
          String errorMessage = "Verification failed";
          
          if (e.code == 'invalid-phone-number') {
            errorMessage = "Invalid phone number format";
          } else if (e.code == 'too-many-requests') {
            errorMessage = "Too many requests. Please try again later.";
          } else if (e.message != null) {
            errorMessage = e.message!;
          }
          
          ShowToastDialog.showToast(errorMessage);
        },
        codeSent: (String verificationId0, int? resendToken0) async {
          ShowToastDialog.closeLoader();
          verificationId.value = verificationId0;
          resendToken.value = resendToken0 ?? 0;
          ShowToastDialog.showToast("OTP sent successfully!");
        },
        timeout: const Duration(seconds: 25),
        forceResendingToken: resendToken.value == 0 ? null : resendToken.value,
        codeAutoRetrievalTimeout: (String verificationId0) {
          verificationId.value = verificationId0;
        },
      );
      return true;
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Failed to send OTP. Please try again.");
      return false;
    }
  }

  // Verify OTP manually
  Future<void> verifyOtp() async {
    if (otpController.value.text.trim().isEmpty) {
      ShowToastDialog.showToast("Please enter the OTP");
      return;
    }

    if (otpController.value.text.trim().length != 6) {
      ShowToastDialog.showToast("Please enter a valid 6-digit OTP");
      return;
    }

    if (isVerifying.value) return;

    try {
      isVerifying.value = true;
      update();
      
      ShowToastDialog.showLoader("Verifying OTP...");
      
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otpController.value.text.trim(),
      );
      
      await FirebaseAuth.instance.signInWithCredential(credential);
      ShowToastDialog.closeLoader();
      _handleSuccessfulAuth();
      
    } catch (e) {
      ShowToastDialog.closeLoader();
      isVerifying.value = false;
      update();
      
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-verification-code':
            ShowToastDialog.showToast("Invalid OTP. Please check and try again.");
            break;
          case 'session-expired':
            ShowToastDialog.showToast("OTP has expired. Please request a new one.");
            break;
          default:
            ShowToastDialog.showToast("Verification failed. Please try again.");
        }
      } else {
        ShowToastDialog.showToast("Something went wrong. Please try again.");
      }
    }
  }

  // Handle successful authentication
  void _handleSuccessfulAuth() {
    try {
      // Clear the OTP field
      otpController.value.clear();
      isVerifying.value = false;
      
      String message = isSignUp.value 
          ? "Phone number verified successfully! Navigation test." 
          : "Welcome back! Navigation test.";
      
      ShowToastDialog.showToast(message);
      
      // Small delay to ensure toast is shown
      Future.delayed(const Duration(milliseconds: 500), () async {
        // Check if user exists and navigate accordingly
        await _checkUserExistsAndNavigate();
      });
    } catch (e) {
      isVerifying.value = false;
      ShowToastDialog.showToast("Navigation error: ${e.toString()}");
      print('Navigation error: $e');
    }
  }

  // Check if user exists and navigate accordingly
  Future<void> _checkUserExistsAndNavigate() async {
    try {
      // Check if user exists in Firebase
      UserModel? existingUser = await FireStoreUtils.getCurrentUser();
      
      if (existingUser != null && 
          existingUser.fullName != null && 
          existingUser.fullName!.isNotEmpty) {
        // User exists and has completed profile - go to hello screen
        print('User already exists, navigating to hello screen');
        Get.offAll(() => const HelloScreen());
      } else {
        // User doesn't exist or hasn't completed profile - go to information screen
        print('User doesn\'t exist, navigating to information screen');
        UserModel userModel = UserModel();
        userModel.phoneNumber = "${countryCode.value}${phoneNumber.value}";
        userModel.loginType = "phone";
        
        Get.offAll(() => const InformationScreen(), arguments: {
          'userModel': userModel,
        });
      }
    } catch (e) {
      print('Error checking user existence: $e');
      // On error, proceed to information screen as fallback
      UserModel userModel = UserModel();
      userModel.phoneNumber = "${countryCode.value}${phoneNumber.value}";
      userModel.loginType = "phone";
      
      Get.offAll(() => const InformationScreen(), arguments: {
        'userModel': userModel,
      });
    }
  }

  // Resend OTP
  Future<void> resendOTP() async {
    await sendOTP();
  }

  // Clear OTP input
  void clearOTP() {
    otpController.value.clear();
  }

  @override
  void onClose() {
    otpController.value.dispose();
    super.onClose();
  }
} 