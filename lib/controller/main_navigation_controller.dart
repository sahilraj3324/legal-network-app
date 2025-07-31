import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  // Current selected index for bottom navigation
  RxInt currentIndex = 0.obs; // Chat opens first
  
  // Method to change the current index
  void changeIndex(int index) {
    currentIndex.value = index;
  }
  
  // Method to navigate to specific page
  void navigateToChat() {
    currentIndex.value = 0;
  }
  
  void navigateToLegalNews() {
    currentIndex.value = 1;
  }
  
  void navigateToJudgements() {
    currentIndex.value = 2;
  }
  
  void navigateToQueries() {
    currentIndex.value = 3;
  }
  
  void navigateToProfile() {
    currentIndex.value = 4;
  }
} 