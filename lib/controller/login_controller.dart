import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../app/auth_screen/otp_verification_screen.dart';
import '../utils/show_toast_dialog.dart';

class LoginController extends GetxController {
  Rx<TextEditingController> phoneNumber = TextEditingController().obs;
  Rx<TextEditingController> countryCodeController = TextEditingController(text: "+91").obs;

  RxBool isLogin = false.obs;

  @override
  void onInit() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      isLogin.value = argumentData['isLogin'] ?? false;
    }
    super.onInit();
  }

  sendCode() async {
    ShowToastDialog.showLoader("Please wait...");
    await FirebaseAuth.instance
        .verifyPhoneNumber(
            phoneNumber: countryCodeController.value.text + phoneNumber.value.text,
            verificationCompleted: (PhoneAuthCredential credential) {},
            verificationFailed: (FirebaseAuthException e) {
              debugPrint("FirebaseAuthException--->${e.message}");
              ShowToastDialog.closeLoader();
              if (e.code == 'invalid-phone-number') {
                ShowToastDialog.showToast("Invalid phone number");
              } else {
                ShowToastDialog.showToast(e.message);
              }
            },
            codeSent: (String verificationId, int? resendToken) {
              ShowToastDialog.closeLoader();
              Get.to(() => OTPVerificationScreen(
                phoneNumber: countryCodeController.value.text + phoneNumber.value.text,
                isSignUp: !isLogin.value,
              ), arguments: {
                'countryCode': countryCodeController.value.text,
                'phoneNumber': phoneNumber.value.text,
                'verificationId': verificationId,
                'isSignUp': !isLogin.value,
              });
            },
            codeAutoRetrievalTimeout: (String verificationId) {})
        .catchError((error) {
      debugPrint("catchError--->$error");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Multiple requests detected. Please try again later.");
    });
  }

  @override
  void onClose() {
    phoneNumber.value.dispose();
    countryCodeController.value.dispose();
    super.onClose();
  }
} 