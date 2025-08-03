import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/hello_controller.dart';
import '../../controller/auth_controller.dart';

class HelloScreen extends StatelessWidget {
  const HelloScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HelloController());
    final authController = Get.find<AuthController>();
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isSmallScreen = size.height < 700;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Show logout confirmation dialog
              Get.dialog(
                AlertDialog(
                  title: Text(
                    'Logout',
                    style: GoogleFonts.instrumentSans(
                      fontSize: isTablet ? 20 : (isSmallScreen ? 16 : 18),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  content: Text(
                    'Are you sure you want to logout?',
                    style: GoogleFonts.instrumentSans(
                      fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.instrumentSans(
                          fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        authController.signOut();
                      },
                      child: Text(
                        'Logout',
                        style: GoogleFonts.instrumentSans(
                          fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(
              Icons.logout,
              color: const Color(0xFF1565C0),
              size: isTablet ? 28 : (isSmallScreen ? 20 : 24),
            ),
          ),
        ],
      ),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(height: isSmallScreen ? 40 : 80),
                          
                          // Welcome Icon
                          Container(
                            width: isTablet ? 140 : (isSmallScreen ? 100 : 120),
                            height: isTablet ? 140 : (isSmallScreen ? 100 : 120),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1565C0).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.waving_hand,
                              size: isTablet ? 70 : (isSmallScreen ? 50 : 60),
                              color: const Color(0xFF1565C0),
                            ),
                          ),
                          
                          SizedBox(height: isSmallScreen ? 20 : 40),
                          
                          // Welcome Text
                          Obx(() => Text(
                            controller.isLoading.value
                                ? 'Loading...'
                                : 'Hello, ${controller.userName.value}!',
                            style: GoogleFonts.instrumentSans(
                              fontSize: isTablet ? 36 : (isSmallScreen ? 24 : 32),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          )),
                          
                          SizedBox(height: isSmallScreen ? 8 : 16),
                          
                          // Welcome message
                          Text(
                            'Welcome to Legal Network',
                            style: GoogleFonts.instrumentSans(
                              fontSize: isTablet ? 24 : (isSmallScreen ? 18 : 20),
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1565C0),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          SizedBox(height: isSmallScreen ? 4 : 8),
                          
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 0),
                            child: Text(
                              'Your profile has been successfully created and you\'re ready to explore the legal network.',
                              style: GoogleFonts.instrumentSans(
                                fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                                color: Colors.grey[600],
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: isSmallScreen ? 30 : 60),
                      
                      // User Info Card
                      Obx(() => controller.isLoading.value
                          ? Container(
                              width: double.infinity,
                              height: isTablet ? 200 : (isSmallScreen ? 150 : 180),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: isTablet ? 40 : (isSmallScreen ? 24 : 32),
                                      height: isTablet ? 40 : (isSmallScreen ? 24 : 32),
                                      child: const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1565C0)),
                                      ),
                                    ),
                                    SizedBox(height: isSmallScreen ? 8 : 16),
                                    Text(
                                      'Loading profile...',
                                      style: GoogleFonts.instrumentSans(
                                        fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(isTablet ? 24 : (isSmallScreen ? 16 : 20)),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Profile Information',
                                    style: GoogleFonts.instrumentSans(
                                      fontSize: isTablet ? 22 : (isSmallScreen ? 16 : 18),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: isSmallScreen ? 12 : 16),
                                  
                                  // Name
                                  _buildInfoRow(
                                    Icons.person,
                                    'Name',
                                    controller.userName.value,
                                    isTablet,
                                    isSmallScreen,
                                  ),
                                  
                                  SizedBox(height: isSmallScreen ? 8 : 12),
                                  
                                  // Email
                                  if (controller.userEmail.value.isNotEmpty)
                                    _buildInfoRow(
                                      Icons.email,
                                      'Email',
                                      controller.userEmail.value,
                                      isTablet,
                                      isSmallScreen,
                                    ),
                                  
                                  SizedBox(height: isSmallScreen ? 8 : 12),
                                  
                                  // Phone
                                  if (controller.userPhone.value.isNotEmpty)
                                    _buildInfoRow(
                                      Icons.phone,
                                      'Phone',
                                      controller.userPhone.value,
                                      isTablet,
                                      isSmallScreen,
                                    ),
                                ],
                              ),
                            ),
                      ),
                      
                      SizedBox(height: isSmallScreen ? 20 : 40),
                      
                      // Continue Button
                      SizedBox(
                        width: double.infinity,
                        height: isTablet ? 65 : (isSmallScreen ? 50 : 55),
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Navigate to main app/dashboard
                            Get.snackbar(
                              'Success',
                              'Welcome to Legal Network! Ready to explore.',
                              backgroundColor: const Color(0xFF1565C0),
                              colorText: Colors.white,
                              snackPosition: SnackPosition.TOP,
                              duration: const Duration(seconds: 3),
                              titleText: Text(
                                'Success',
                                style: GoogleFonts.instrumentSans(
                                  fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              messageText: Text(
                                'Welcome to Legal Network! Ready to explore.',
                                style: GoogleFonts.instrumentSans(
                                  fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            'Continue to Legal Network',
                            style: GoogleFonts.instrumentSans(
                              fontSize: isTablet ? 20 : (isSmallScreen ? 16 : 18),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: isSmallScreen ? 10 : 20),
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

  Widget _buildInfoRow(IconData icon, String label, String value, bool isTablet, bool isSmallScreen) {
    return Row(
      children: [
        Icon(
          icon,
          size: isTablet ? 24 : (isSmallScreen ? 16 : 20),
          color: const Color(0xFF1565C0),
        ),
        SizedBox(width: isSmallScreen ? 8 : 12),
        Text(
          '$label: ',
          style: GoogleFonts.instrumentSans(
            fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.instrumentSans(
              fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
} 