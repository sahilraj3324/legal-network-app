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
      imagePath: 'assets/images/onboarding2.png',
    ),
    OnboardingData(
      title: 'Get Daily Legal News & Judgments At One Place.',
      subtitle: 'All at your fingertips, get updated & notified anytime, anywhere!',
      imagePath: 'assets/images/onboarding2.png',
    ),
    OnboardingData(
      title: 'Ask and Answer Legal Queries — Put Your Expertise in the Spotlight!',
      subtitle: 'Boost your visibility & get your query resolved instantly.',
      imagePath: 'assets/images/onboarding3.png',
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_onboardingData[index], constraints, isTablet, isSmallScreen);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingData data, BoxConstraints constraints, bool isTablet, bool isSmallScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isTablet ? 40.0 : 20.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: constraints.maxHeight,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top section with logo and title
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
                
                // Title
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
                    child: Text(
                      data.title,
                      style: GoogleFonts.instrumentSans(
                        fontSize: isTablet ? 32 : (isSmallScreen ? 24 : 28),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                        letterSpacing: -1,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                

                
                // Subtitle
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 0),
                  child: Text(
                    data.subtitle,
                    style: GoogleFonts.instrumentSans(
                      fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                      color: Colors.grey[600],
                      height: 1.5,
                      letterSpacing: -1,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            
       
            // Middle section with image
            Container(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * 0.4,
                maxWidth: isTablet ? 400 : 300,
              ),
              child: Container(
                padding: EdgeInsets.all(isTablet ? 40 : 20),
                decoration: BoxDecoration(
                  
                  borderRadius: BorderRadius.circular(20),
                
                ),


                child: Center(
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
            
            // Bottom section with indicators and buttons
            Column(
              children: [
                // Page indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => Container(
                      width: isTablet ? 12 : (isSmallScreen ? 8 : 10),
                      height: isTablet ? 12 : (isSmallScreen ? 8 : 10),
                      margin: EdgeInsets.symmetric(horizontal: isTablet ? 8 : 4),
                      decoration: BoxDecoration(
                        color: index == _currentPage
                            ? const Color(0xFF1565C0)
                            : Colors.grey.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: isSmallScreen ? 20 : 40),
                
                // Continue Button
                Center(
                  child: SizedBox(
                    width: isTablet ? 200 : (isSmallScreen ? 160 : 180),
                    height: isTablet ? 60 : (isSmallScreen ? 50 : 55),
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
                          fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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