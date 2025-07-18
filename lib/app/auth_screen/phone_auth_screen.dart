import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'otp_verification_screen.dart';
import '../../utils/firebase_service.dart';

class PhoneAuthScreen extends StatefulWidget {
  final bool isSignUp;
  
  const PhoneAuthScreen({super.key, required this.isSignUp});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _selectedCountryCode = '+91';

  final List<Map<String, String>> _countryCodes = [
    {'code': '+91', 'country': 'India'},
  ];

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
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back, color: Colors.black),
                              ),
                              Container(
                                width: isTablet ? 100 : (isSmallScreen ? 70 : 80),
                                height: isTablet ? 100 : (isSmallScreen ? 70 : 80),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'assets/images/Logo.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Icon(
                                          Icons.image,
                                          size: isTablet ? 50 : (isSmallScreen ? 35 : 40),
                                          color: Colors.grey.shade400,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isSmallScreen ? 10 : 20),
                          
                          // Title
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF51D5FF),
                                  Color(0xFF000000),
                                ],
                              ).createShader(bounds),
                              child: Text(
                                widget.isSignUp ? 'Let’s Setup Your Profile & Account Quickly!' : 'Welcome Back',
                                style: GoogleFonts.instrumentSans(
                                  fontSize: isTablet ? 36 : (isSmallScreen ? 24 : 32),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 8 : 16),
                          
                          // Subtitle
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Enter your phone number to ${widget.isSignUp ? 'create your account' : 'log in'} with OTP verification',
                              style: GoogleFonts.instrumentSans(
                                fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: isSmallScreen ? 20 : 40),
                      
                      // Middle section with phone input
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Country Code Dropdown
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 20 : (isSmallScreen ? 12 : 16),
                                vertical: isTablet ? 4 : 0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedCountryCode,
                                  isExpanded: true,
                                  style: GoogleFonts.instrumentSans(
                                    fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                                    color: Colors.black,
                                  ),
                                  items: _countryCodes.map((country) {
                                    return DropdownMenuItem<String>(
                                      value: country['code'],
                                      child: Text(
                                        '${country['code']} - ${country['country']}',
                                        style: GoogleFonts.instrumentSans(
                                          fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCountryCode = value!;
                                    });
                                  },
                                ),
                              ),
                              
                            ),
                            
                            
                            SizedBox(height: isSmallScreen ? 16 : 20),
                            
                            // Phone Number Input
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              style: GoogleFonts.instrumentSans(
                                fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                labelStyle: GoogleFonts.instrumentSans(
                                  color: Colors.grey[600],
                                  fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                                ),
                                hintText: '9876543210',
                                hintStyle: GoogleFonts.instrumentSans(
                                  color: Colors.grey[400],
                                  fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF1565C0),
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 20 : (isSmallScreen ? 12 : 16),
                                  vertical: isTablet ? 20 : (isSmallScreen ? 12 : 16),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                if (value.length < 10) {
                                  return 'Please enter a valid phone number';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: isSmallScreen ? 20 : 40),
                      
                      // Bottom section with button
                      Column(
                        children: [
                          // Continue Button
                          SizedBox(
                            width: double.infinity,
                            height: isTablet ? 65 : (isSmallScreen ? 50 : 55),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _sendOTP,
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
                                      'Continue',
                                      style: GoogleFonts.instrumentSans(
                                        fontSize: isTablet ? 20 : (isSmallScreen ? 16 : 18),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          
                          SizedBox(height: isSmallScreen ? 16 : 24),
                          
                          // Terms and Privacy
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: GoogleFonts.instrumentSans(
                                  fontSize: isTablet ? 14 : (isSmallScreen ? 11 : 12),
                                  color: Colors.grey[600],
                                ),
                                children: [
                                  const TextSpan(text: 'By continuing, you agree to our '),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: GoogleFonts.instrumentSans(
                                      fontSize: isTablet ? 14 : (isSmallScreen ? 11 : 12),
                                      color: const Color(0xFF1565C0),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: GoogleFonts.instrumentSans(
                                      fontSize: isTablet ? 14 : (isSmallScreen ? 11 : 12),
                                      color: const Color(0xFF1565C0),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
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

  void _sendOTP() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      final phoneNumber = _selectedCountryCode + _phoneController.text;
      
      FirebaseService.sendOTP(
        phoneNumber: phoneNumber,
        onCodeSent: () {
          setState(() {
            _isLoading = false;
          });
          
          // Navigate to OTP verification screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationScreen(
                phoneNumber: phoneNumber,
                isSignUp: widget.isSignUp,
              ),
            ),
          );
        },
        onError: (error) {
          setState(() {
            _isLoading = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error,
                style: GoogleFonts.instrumentSans(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        },
        onVerificationCompleted: (userCredential) {
          setState(() {
            _isLoading = false;
          });
          
          // Auto-verification completed, navigate to main app
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/main',
            (route) => false,
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
} 