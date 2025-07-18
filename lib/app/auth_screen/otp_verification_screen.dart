import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:get/get.dart';
import '../../utils/firebase_service.dart';
import '../information_screen/information_screen.dart';
import '../hello_screen.dart';
import '../../model/user_model.dart';
import '../../utils/fire_store_utils.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final bool isSignUp;
  
  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.isSignUp,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  bool _isResending = false;
  int _resendTimer = 30;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _autoFetchOTP();
  }

  void _startResendTimer() {
    if (_isDisposed) return;
    
    Future.delayed(const Duration(seconds: 1), () {
      if (_resendTimer > 0 && mounted && !_isDisposed) {
        setState(() {
          _resendTimer--;
        });
        _startResendTimer();
      }
    });
  }

  void _autoFetchOTP() async {
    if (_isDisposed) return;
    
    try {
      // Listen for incoming SMS
      await SmsAutoFill().listenForCode();
      
      // Get the SMS code automatically
      final signature = await SmsAutoFill().getAppSignature;
      print('App signature: $signature');
      
      // Listen for OTP from SMS
      SmsAutoFill().code.listen((code) {
        if (code.isNotEmpty && code.length == 6 && mounted && !_isDisposed) {
          for (int i = 0; i < code.length; i++) {
            _otpControllers[i].text = code[i];
          }
          if (mounted) {
            setState(() {});
            // Auto-verify when OTP is received
            _verifyOTP();
          }
        }
      });
    } catch (e) {
      print('Auto-fetch OTP error: $e');
      // Fallback simulation for testing
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && !_isDisposed) {
          const simulatedOTP = '123456';
          for (int i = 0; i < simulatedOTP.length; i++) {
            _otpControllers[i].text = simulatedOTP[i];
          }
          if (mounted) {
            setState(() {});
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isSmallScreen = size.height < 700;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFBDEFFF),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(isTablet ? 40.0 : 20.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top section with logo and back button
                      Column(
                        children: [
                          // Header with back button and logo
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (mounted && !_isDisposed) {
                                    Get.back();
                                  }
                                },
                                icon: const Icon(Icons.arrow_back, color: Colors.black),
                              ),
                              Container(
                                width: isTablet ? 100 : (isSmallScreen ? 70 : 80),
                                height: isTablet ? 100 : (isSmallScreen ? 70 : 80),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.verified_user,
                                  size: isTablet ? 60 : (isSmallScreen ? 40 : 50),
                                  color: const Color(0xFF1565C0),
                                ),
                              ),
                              SizedBox(width: isTablet ? 56 : (isSmallScreen ? 44 : 48)), // Balance the back button
                            ],
                          ),
                          
                          SizedBox(height: isSmallScreen ? 15 : 30),
                          
                          Padding(
                          padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 0),
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF51D5FF),
                        Color(0xFF000000),
                      ],
                    ).createShader(bounds),
                        child:  Text(
                            'What’s The Code You Received From Us?',
                            style: GoogleFonts.instrumentSans(
                              fontSize: isTablet ? 32 : (isSmallScreen ? 22 : 28),
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                              letterSpacing: -1,
                              color: Colors.white,
                            ),
                          ),
                          ),
                          ),

                          SizedBox(height: isSmallScreen ? 5 : 10),
                          
                          // Subtitle
                          Text(
                            'We sent a 6-digit code to',
                            style: GoogleFonts.instrumentSans(
                              fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                              color: Colors.grey[600],
                            ),
                          ),
                          
                          SizedBox(height: isSmallScreen ? 3 : 5),
                          
                          // Phone number
                          Text(
                            widget.phoneNumber,
                            style: GoogleFonts.instrumentSans(
                              fontSize: isTablet ? 20 : (isSmallScreen ? 16 : 18),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1565C0),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: isSmallScreen ? 20 : 40),
                      
                      // Middle section with OTP input
                      Column(
                        children: [
                          // OTP Input fields
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(6, (index) {
                              return SizedBox(
                                width: isTablet ? 55 : (isSmallScreen ? 35 : 45),
                                height: isTablet ? 70 : (isSmallScreen ? 50 : 60),
                                child: TextFormField(
                                  controller: _otpControllers[index],
                                  focusNode: _otpFocusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  style: GoogleFonts.instrumentSans(
                                    fontSize: isTablet ? 28 : (isSmallScreen ? 18 : 24),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF1565C0),
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty && index < 5) {
                                      _otpFocusNodes[index + 1].requestFocus();
                                    } else if (value.isEmpty && index > 0) {
                                      _otpFocusNodes[index - 1].requestFocus();
                                    }
                                    
                                    // Auto-verify when all fields are filled
                                    if (index == 5 && value.isNotEmpty) {
                                      _verifyOTP();
                                    }
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              );
                            }),
                          ),
                          
                          SizedBox(height: isSmallScreen ? 20 : 30),
                          
                          // Resend section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Didn\'t receive the code? ',
                                style: GoogleFonts.instrumentSans(
                                  fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                                  color: Colors.grey[600],
                                ),
                              ),
                              GestureDetector(
                                onTap: _resendTimer == 0 && !_isResending ? _resendOTP : null,
                                child: Text(
                                  _resendTimer > 0 
                                      ? 'Resend in ${_resendTimer}s'
                                      : _isResending 
                                          ? 'Sending...'
                                          : 'Resend',
                                  style: GoogleFonts.instrumentSans(
                                    fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                                    fontWeight: FontWeight.w600,
                                    color: _resendTimer == 0 && !_isResending
                                        ? const Color(0xFF1565C0)
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: isSmallScreen ? 25 : 40),
                          
                          // Verify button
                          SizedBox(
                            width: double.infinity,
                            height: isTablet ? 65 : (isSmallScreen ? 50 : 55),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _verifyOTP,
                              style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 2,
                      ),
                              child: _isLoading
                                  ? SizedBox(
                                      width: isTablet ? 24 : (isSmallScreen ? 16 : 20),
                                      height: isTablet ? 24 : (isSmallScreen ? 16 : 20),
                                      child: const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Verify',
                                      style: GoogleFonts.instrumentSans(
                                        fontSize: isTablet ? 20 : (isSmallScreen ? 16 : 18),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: isSmallScreen ? 15 : 30),
                      
                      // Bottom section
                      Column(
                        children: [
                          Text(
                            'Enter the 6-digit code we sent to verify your number',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.instrumentSans(
                              fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _verifyOTP() {
    if (_isDisposed || !mounted) return;
    
    String otp = '';
    for (var controller in _otpControllers) {
      otp += controller.text;
    }
    
    if (otp.length != 6) {
      _showErrorSnackbar('Please enter complete 6-digit code');
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Verify OTP using Firebase
      FirebaseService.verifyOTP(otp).then((userCredential) {
        if (!mounted || _isDisposed) return;
        
        setState(() {
          _isLoading = false;
        });
        
        if (userCredential != null) {
          _showSuccessSnackbar('Phone verified successfully!');
          // Check if user exists in Firebase
          Future.delayed(const Duration(milliseconds: 500), () async {
            if (mounted && !_isDisposed) {
              await _checkUserExistsAndNavigate();
            }
          });
        } else {
          _showErrorSnackbar('Verification failed. Please try again.');
          _clearOTPFields();
        }
      }).catchError((e) {
        if (!mounted || _isDisposed) return;
        
        setState(() {
          _isLoading = false;
        });
        
        _showErrorSnackbar('Invalid OTP. Please try again.');
        _clearOTPFields();
      });
    } catch (e) {
      if (!mounted || _isDisposed) return;
      
      setState(() {
        _isLoading = false;
      });
      
      _showErrorSnackbar('Invalid OTP. Please try again.');
      _clearOTPFields();
    }
  }

  void _resendOTP() {
    if (_isDisposed || !mounted) return;
    
    setState(() {
      _isResending = true;
      _resendTimer = 30;
    });
    
    FirebaseService.sendOTP(
      phoneNumber: widget.phoneNumber,
      onCodeSent: () {
        if (!mounted || _isDisposed) return;
        setState(() {
          _isResending = false;
        });
        _showSuccessSnackbar('OTP sent successfully!');
        _startResendTimer();
        _autoFetchOTP(); // Listen for new OTP
      },
      onError: (error) {
        if (!mounted || _isDisposed) return;
        setState(() {
          _isResending = false;
        });
        _showErrorSnackbar('Failed to resend OTP: $error');
      },
      onVerificationCompleted: (userCredential) {
        if (!mounted || _isDisposed) return;
        setState(() {
          _isResending = false;
        });
        _showSuccessSnackbar('Phone verified successfully!');
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && !_isDisposed) {
            UserModel userModel = UserModel();
            userModel.phoneNumber = widget.phoneNumber;
            userModel.loginType = "phone";
            
            Get.offAll(() => const InformationScreen(), arguments: {
              'userModel': userModel,
            });
          }
        });
      },
    );
  }

  void _clearOTPFields() {
    if (_isDisposed) return;
    for (var controller in _otpControllers) {
      controller.clear();
    }
    if (_otpFocusNodes.isNotEmpty && _otpFocusNodes[0].canRequestFocus) {
      _otpFocusNodes[0].requestFocus();
    }
  }

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
        userModel.phoneNumber = widget.phoneNumber;
        userModel.loginType = "phone";
        
        Get.offAll(() => const InformationScreen(), arguments: {
          'userModel': userModel,
        });
      }
    } catch (e) {
      print('Error checking user existence: $e');
      // On error, proceed to information screen as fallback
      UserModel userModel = UserModel();
      userModel.phoneNumber = widget.phoneNumber;
      userModel.loginType = "phone";
      
      Get.offAll(() => const InformationScreen(), arguments: {
        'userModel': userModel,
      });
    }
  }

  void _showErrorSnackbar(String message) {
    if (!mounted || _isDisposed) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.instrumentSans(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    if (!mounted || _isDisposed) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.instrumentSans(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    
    try {
      SmsAutoFill().unregisterListener();
    } catch (e) {
      print('Error unregistering SMS listener: $e');
    }
    
    super.dispose();
  }
} 