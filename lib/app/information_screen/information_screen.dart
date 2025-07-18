import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leagel_1/controller/information_controller.dart';
import 'package:leagel_1/app/information_steps/personal_info_screen.dart';
import 'package:leagel_1/app/information_steps/profile_picture_screen.dart';
import 'package:leagel_1/app/information_steps/completion_screen.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InformationController(), permanent: false);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isSmallScreen = size.height < 700;
    
    return PopScope(
      canPop: controller.currentPage.value <= 1,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop && controller.currentPage.value > 1) {
          controller.previousPage();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Obx(() => controller.currentPage.value > 1
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: isTablet ? 28 : (isSmallScreen ? 20 : 24),
                  ),
                  onPressed: () => controller.previousPage(),
                )
              : const SizedBox()),
          title: Obx(() => Text(
            'Step ${controller.currentPage.value} of 3',
            style: TextStyle(
              color: Colors.black,
              fontSize: isTablet ? 22 : (isSmallScreen ? 16 : 18),
              fontWeight: FontWeight.w600,
            ),
          )),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Progress indicator
            Obx(() => Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 40.0 : 40.0),
              child: LinearProgressIndicator(
                value: controller.currentPage.value / 3,
                backgroundColor: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 2, 255, 27)),
                minHeight: isTablet ? 6 : (isSmallScreen ? 5 : 10),
              ),
            )),
            
            // Content based on current page
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Obx(() {
                        switch (controller.currentPage.value) {
                          case 1:
                            return const PersonalInfoScreen();
                          case 2:
                            return const ProfilePictureScreen();
                          case 3:
                            return const CompletionScreen();
                          default:
                            return const PersonalInfoScreen();
                        }
                      }),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 