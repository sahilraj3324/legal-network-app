import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static String? _verificationId;

  // Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Send OTP to phone number
  static Future<void> sendOTP({
    required String phoneNumber,
    required VoidCallback onCodeSent,
    required Function(String) onError,
    required Function(UserCredential) onVerificationCompleted,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            UserCredential userCredential = await _auth.signInWithCredential(credential);
            onVerificationCompleted(userCredential);
          } catch (e) {
            onError('Auto-verification failed: ${e.toString()}');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          String errorMessage = 'Phone verification failed';
          
          switch (e.code) {
            case 'invalid-phone-number':
              errorMessage = 'Invalid phone number format';
              break;
            case 'quota-exceeded':
              errorMessage = 'Too many requests. Please try again later';
              break;
            case 'app-not-authorized':
              errorMessage = 'App not authorized for Firebase Auth';
              break;
            case 'network-request-failed':
              errorMessage = 'Network error. Please check your connection';
              break;
            default:
              errorMessage = e.message ?? 'Phone verification failed';
          }
          
          onError(errorMessage);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          onCodeSent();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      onError('Error sending OTP: ${e.toString()}');
    }
  }

  // Verify OTP
  static Future<UserCredential?> verifyOTP(String otp) async {
    try {
      if (_verificationId == null) {
        throw Exception('No verification ID found. Please request OTP again.');
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'OTP verification failed';
      
      switch (e.code) {
        case 'invalid-verification-code':
          errorMessage = 'Invalid OTP. Please check and try again';
          break;
        case 'invalid-verification-id':
          errorMessage = 'Verification expired. Please request new OTP';
          break;
        case 'session-expired':
          errorMessage = 'Session expired. Please request new OTP';
          break;
        case 'quota-exceeded':
          errorMessage = 'Too many attempts. Please try again later';
          break;
        default:
          errorMessage = e.message ?? 'OTP verification failed';
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('OTP verification failed: ${e.toString()}');
    }
  }

  // Get current user
  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign out
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Check if user is signed in
  static bool isSignedIn() {
    return _auth.currentUser != null;
  }
} 