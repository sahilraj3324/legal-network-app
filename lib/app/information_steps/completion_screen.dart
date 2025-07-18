import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leagel_1/controller/information_controller.dart';

class CompletionScreen extends StatelessWidget {
  const CompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = InformationController.instance;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isSmallScreen = size.height < 700;
    
    return Padding(
      padding: EdgeInsets.all(isTablet ? 40.0 : 24.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: isSmallScreen ? 10 : 20),
                 ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Color.fromARGB(255, 12, 230, 27),
                        Color(0xFF000000),
                  ],
                  begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: const Text(
                  'Great! You’re Now All Set To Use Legal Network.',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                    letterSpacing: -1,
                  ),
                ),
              ),
                SizedBox(height: isSmallScreen ? 10 : 10),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 0),
                  child: Text(
                    'It may take sometime for us to approve your listing on expert vakeel website. We’ll be in touch in case required. ',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                      color: Colors.grey,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 20 : 50),
                // Success Icon
                Container(
                  width: isTablet ? 120 : (isSmallScreen ? 80 : 100),
                  height: isTablet ? 120 : (isSmallScreen ? 80 : 100),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: isTablet ? 70 : (isSmallScreen ? 50 : 60),
                    color: Colors.green.shade600,
                  ),
                ),
                
                
                // Title
                
                SizedBox(height: isSmallScreen ? 8 : 12),
                
                // Subtitle
                
                SizedBox(height: isSmallScreen ? 20 : 30),
                
                // Profile Summary Card
                
                
                SizedBox(height: isSmallScreen ? 40 : 80),
                
                // Action Buttons
                Column(
                  children: [
                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: isTablet ? 65 : (isSmallScreen ? 50 : 55),
                      child: ElevatedButton(
                        onPressed: () {
                          controller.completeRegistration();
                        },
                        style:ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 2,
                      ),
                        child: Text(
                          'Continue to Legal Network',
                          style: TextStyle(
                            fontSize: isTablet ? 20 : (isSmallScreen ? 16 : 18),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    
                    // Edit Profile Button
                    
                  ],
                ),
                
                SizedBox(height: isSmallScreen ? 20 : 40),
              ],
            ),
          );
        },
      ),
    );
  }
} 