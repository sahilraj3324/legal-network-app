import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leagel_1/controller/information_controller.dart';

class ProfilePictureScreen extends StatelessWidget {
  const ProfilePictureScreen({super.key});

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
                SizedBox(height: isSmallScreen ? 20 : 40),
                ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Color(0xFF51D5FF),
                        Color(0xFF000000),
                  ],
                  begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: const Text(
                  'Final Step! Upload Your Profile Picture / Firm Logo ',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                    letterSpacing: -1,
                  ),
                ),
              ),
                SizedBox(height: isSmallScreen ? 4 : 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 0),
                  child: Text(
                    'Add a profile picture to help others recognize you.',
                    style: TextStyle(
                      fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 30 : 60),
                
                // Profile Picture Container
                Obx(() => GestureDetector(
                  onTap: () => controller.showImagePickerDialog(),
                  child: Container(
                    width: isTablet ? 220 : (isSmallScreen ? 150 : 180),
                    height: isTablet ? 220 : (isSmallScreen ? 150 : 180),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: controller.profileImage.value.isNotEmpty
                        ? ClipOval(
                            child: Image.file(
                              File(controller.profileImage.value),
                              fit: BoxFit.cover,
                              width: isTablet ? 220 : (isSmallScreen ? 150 : 180),
                              height: isTablet ? 220 : (isSmallScreen ? 150 : 180),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: isTablet ? 50 : (isSmallScreen ? 30 : 40),
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: isSmallScreen ? 4 : 8),
                              Text(
                                'Add Photo',
                                style: TextStyle(
                                  fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  ),
                )),
                
                SizedBox(height: isSmallScreen ? 20 : 40),
                
                // Info Text
                Container(
                  padding: EdgeInsets.all(isTablet ? 20 : (isSmallScreen ? 12 : 16)),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade600,
                        size: isTablet ? 24 : (isSmallScreen ? 16 : 20),
                      ),
                      SizedBox(width: isSmallScreen ? 8 : 12),
                      Expanded(
                        child: Text(
                          'Your profile picture will be visible to all users. You can change it later from your profile settings.',
                          style: TextStyle(
                            fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: isSmallScreen ? 40 : 80),
                
                // Buttons
                Column(
                  children: [
                    // Skip Button
                    Obx(() => controller.profileImage.value.isEmpty
                      ? Container(
                          width: double.infinity,
                          height: isTablet ? 65 : (isSmallScreen ? 50 : 55),
                          child: OutlinedButton(
                            onPressed: () => controller.nextPage(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade400),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Skip for now',
                              style: TextStyle(
                                fontSize: isTablet ? 20 : (isSmallScreen ? 16 : 18),
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink()),
                    
                    Obx(() => controller.profileImage.value.isEmpty
                      ? SizedBox(height: isSmallScreen ? 12 : 16)
                      : SizedBox.shrink()),
                    
                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: isTablet ? 65 : (isSmallScreen ? 50 : 55),
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.profileImage.value.isEmpty) {
                            controller.showImagePickerDialog();
                          } else {
                            controller.nextPage();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 2,
                      ),
                        child: Obx(() => Text(
                          controller.profileImage.value.isEmpty ? 'Add Photo' : 'Continue',
                          style: TextStyle(
                            fontSize: isTablet ? 20 : (isSmallScreen ? 16 : 18),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
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