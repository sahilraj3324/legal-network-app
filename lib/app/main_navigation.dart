import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/main_navigation_controller.dart';
import 'chat/inbox_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainNavigationController());
    
    return Scaffold(
      body: Obx(() => _getPage(controller.currentIndex.value)),
      bottomNavigationBar: Obx(() => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1565C0),
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: GoogleFonts.instrumentSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.instrumentSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: controller.currentIndex.value == 0 
                      ? const Color(0xFF1565C0).withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  controller.currentIndex.value == 0 
                      ? Icons.chat 
                      : Icons.chat_outlined,
                  size: 24,
                ),
              ),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: controller.currentIndex.value == 1 
                      ? const Color(0xFF1565C0).withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  controller.currentIndex.value == 1 
                      ? Icons.article 
                      : Icons.article_outlined,
                  size: 24,
                ),
              ),
              label: 'Legal News',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: controller.currentIndex.value == 2 
                      ? const Color(0xFF1565C0).withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  controller.currentIndex.value == 2 
                      ? Icons.gavel 
                      : Icons.gavel_outlined,
                  size: 24,
                ),
              ),
              label: 'Judgements',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: controller.currentIndex.value == 3 
                      ? const Color(0xFF1565C0).withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  controller.currentIndex.value == 3 
                      ? Icons.help 
                      : Icons.help_outline,
                  size: 24,
                ),
              ),
              label: 'Queries',
            ),
            
          ],
        ),
      )),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const InboxScreen();
      case 1:
        return _buildLegalNewsScreen();
      case 2:
        return _buildLegalJudgementsScreen();
      case 3:
        return _buildQueriesScreen();
      case 4:
        return _buildProfileScreen();
      default:
        return const InboxScreen();
    }
  }

  Widget _buildLegalNewsScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        title: Text(
          'Legal News',
          style: GoogleFonts.instrumentSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              'Legal News',
              style: GoogleFonts.instrumentSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Stay updated with latest legal developments',
              style: GoogleFonts.instrumentSans(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Coming Soon...',
              style: GoogleFonts.instrumentSans(
                fontSize: 14,
                color: const Color(0xFF1565C0),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalJudgementsScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        title: Text(
          'Legal Judgements',
          style: GoogleFonts.instrumentSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.gavel,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              'Legal Judgements',
              style: GoogleFonts.instrumentSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Access comprehensive legal judgements database',
              style: GoogleFonts.instrumentSans(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Coming Soon...',
              style: GoogleFonts.instrumentSans(
                fontSize: 14,
                color: const Color(0xFF1565C0),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueriesScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        title: Text(
          'Legal Queries',
          style: GoogleFonts.instrumentSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.help,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              'Legal Queries',
              style: GoogleFonts.instrumentSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ask questions and get expert legal advice',
              style: GoogleFonts.instrumentSans(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Coming Soon...',
              style: GoogleFonts.instrumentSans(
                fontSize: 14,
                color: const Color(0xFF1565C0),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        title: Text(
          'My Profile',
          style: GoogleFonts.instrumentSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFF1565C0).withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 50,
                color: const Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'My Profile',
              style: GoogleFonts.instrumentSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'View and manage your profile information',
              style: GoogleFonts.instrumentSans(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Coming Soon...',
              style: GoogleFonts.instrumentSans(
                fontSize: 14,
                color: const Color(0xFF1565C0),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 