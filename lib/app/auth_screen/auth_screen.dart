import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'phone_auth_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

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
                      // Top section with logo
                      Column(
                        children: [
                          // Logo positioned at top right
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: isTablet ? 120 : (isSmallScreen ? 80 : 100),
                                height: isTablet ? 120 : (isSmallScreen ? 80 : 100),
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
                                          size: isTablet ? 60 : (isSmallScreen ? 40 : 50),
                                          color: Colors.grey.shade400,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                         
                          
                          // Welcome text
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
                                'Take a Step Closer to Advancing Your Legal Career',
                                style: GoogleFonts.instrumentSans(
                                  fontSize: isTablet ? 40 : (isSmallScreen ? 24 : 32),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.3,
                                  letterSpacing: -1,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 8 : 16),
                          
                          // Subtitle
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Let’s Set Up Things For Better.',
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
                      
                      // Middle section with illustration
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: size.height * 0.4,
                          maxWidth: isTablet ? 300 : 200,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(isTablet ? 30 : 20),
                          
                           child: Center(
                  child: Image.asset(
                    'assets/images/onboarding2.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        
                        child: Icon(
                          Icons.image,
                          size: isTablet ? 80 : (isSmallScreen ? 50 : 60),
                          color: Colors.grey.shade400,
                        ),
                      );
                    },
                  ),
                ),



                        ),
                      ),
                      
                      SizedBox(height: isSmallScreen ? 20 : 40),
                      
                      // Bottom section with buttons
                      Column(
                        children: [
                          // Sign Up Button
                          SizedBox(
                            width: double.infinity,
                            height: isTablet ? 65 : (isSmallScreen ? 50 : 55),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PhoneAuthScreen(isSignUp: true),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 2,
                      ),
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.instrumentSans(
                                  fontSize: isTablet ? 20 : (isSmallScreen ? 16 : 18),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: isSmallScreen ? 12 : 16),
                          
                          // Log In Button
                          SizedBox(
                            width: double.infinity,
                            height: isTablet ? 65 : (isSmallScreen ? 50 : 55),
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PhoneAuthScreen(isSignUp: false),
                                  ),
                                );
                              },
                             
                              child: Text(
                                'Log In',
                                style: GoogleFonts.instrumentSans(
                                  fontSize: isTablet ? 20 : (isSmallScreen ? 16 : 18),
                                  
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: isSmallScreen ? 16 : 24),
                          
                          // Terms and Privacy
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 20),
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
} 