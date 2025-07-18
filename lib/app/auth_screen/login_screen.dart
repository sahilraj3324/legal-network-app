import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isSmallScreen = size.height < 700;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: isTablet ? 22 : (isSmallScreen ? 16 : 18),
          ),
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(isTablet ? 40.0 : 20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: isSmallScreen ? 20 : 40),
                    
                    Text(
                      'Enter your phone number',
                      style: GoogleFonts.inter(
                        fontSize: isTablet ? 28 : (isSmallScreen ? 20 : 24),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1565C0),
                      ),
                    ),
                    
                    SizedBox(height: isSmallScreen ? 4 : 8),
                    
                    Text(
                      'We\'ll send you a verification code',
                      style: GoogleFonts.inter(
                        fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                        color: Colors.grey[600],
                      ),
                    ),
                    
                    SizedBox(height: isSmallScreen ? 20 : 40),
                    
                    // Country Code and Phone Number Row
                    Row(
                      children: [
                        // Country Code Field
                        Container(
                          width: isTablet ? 100 : (isSmallScreen ? 70 : 80),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextFormField(
                            controller: controller.countryCodeController.value,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: isTablet ? 20 : (isSmallScreen ? 12 : 16),
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(width: isSmallScreen ? 8 : 12),
                        
                        // Phone Number Field
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                              controller: controller.phoneNumber.value,
                              keyboardType: TextInputType.phone,
                              style: GoogleFonts.inter(
                                fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Phone Number',
                                hintStyle: GoogleFonts.inter(
                                  color: Colors.grey[500],
                                  fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 20 : (isSmallScreen ? 12 : 16),
                                  vertical: isTablet ? 20 : (isSmallScreen ? 12 : 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: isSmallScreen ? 16 : 20),
                    
                    // Send OTP Button
                    SizedBox(
                      width: double.infinity,
                      height: isTablet ? 65 : (isSmallScreen ? 50 : 55),
                      child: ElevatedButton(
                        onPressed: () {
                          controller.sendCode();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'Send OTP',
                          style: GoogleFonts.inter(
                            fontSize: isTablet ? 20 : (isSmallScreen ? 16 : 18),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: isSmallScreen ? 16 : 20),
                    
                    // Clear Button
                    TextButton(
                      onPressed: () {
                        controller.phoneNumber.value.clear();
                        controller.countryCodeController.value.text = "+91";
                      },
                      child: Text(
                        'Clear',
                        style: GoogleFonts.inter(
                          fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    
                    // Add flexible spacing
                    SizedBox(height: isSmallScreen ? 20 : 40),
                    
                    // Info Container
                    Container(
                      padding: EdgeInsets.all(isTablet ? 20 : (isSmallScreen ? 12 : 16)),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.grey[600],
                            size: isTablet ? 24 : (isSmallScreen ? 18 : 20),
                          ),
                          SizedBox(height: isSmallScreen ? 4 : 8),
                          Text(
                            'We\'ll send you a verification code to verify your phone number. Standard messaging rates may apply.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 