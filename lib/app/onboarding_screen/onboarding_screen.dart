import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth_screen/auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: 'Connect & Collaborate With Advocates & Clients From All Over India!',
      subtitle: 'Apply filters and find the perfect advocate for your case.',
      imagePath: 'assets/images/Group3.png',
    ),
    OnboardingData(
      title: 'Get Daily Legal News & Judgments At One Place.',
      subtitle: 'All at your fingertips, get updated & notified anytime, anywhere!',
      imagePath: 'assets/images/onboarding2.png',
    ),
    OnboardingData(
      title: 'Ask and Answer Legal Queries — Put Your Expertise in the Spotlight!',
      subtitle: 'Boost your visibility & get your query resolved instantly.',
      imagePath: 'assets/images/tick.gif',
    ),
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
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return _buildOnboardingPage(
                _onboardingData[index],
                isTablet,
                isSmallScreen,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingData data, bool isTablet, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 40.0 : 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo at top right
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: isTablet ? 120 : (isSmallScreen ? 70 : 90),
              height: isTablet ? 120 : (isSmallScreen ? 70 : 90),
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
                        size: isTablet ? 60 : (isSmallScreen ? 35 : 45),
                        color: Colors.grey.shade400,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 0),
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
                data.title,
                style: GoogleFonts.instrumentSans(
                  fontSize: isTablet ? 28 : (isSmallScreen ? 20 : 24),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Subtitle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 0),
            child: Text(
              data.subtitle,
              style: GoogleFonts.instrumentSans(
                fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Image
          Expanded(
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 350 : (isSmallScreen ? 200 : 280),
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: Image.asset(
                  data.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.image,
                        size: isTablet ? 80 : (isSmallScreen ? 40 : 60),
                        color: Colors.grey.shade400,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Button
          Center(
            child: SizedBox(
              width: isTablet ? 200 : (isSmallScreen ? 160 : 280),
              height: isTablet ? 60 : (isSmallScreen ? 45 : 55),
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage < _onboardingData.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthScreen(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Continue',
                  style: GoogleFonts.instrumentSans(
                    fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 20),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String imagePath;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}
