import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leagel_1/utils/show_toast_dialog.dart';
import 'package:leagel_1/model/user_model.dart';
import '../app/main_navigation.dart';
import 'package:leagel_1/model/city_model.dart';
import 'package:leagel_1/model/court_model.dart';
import 'package:leagel_1/utils/fire_store_utils.dart';
import 'package:leagel_1/utils/notification_service.dart';
import 'package:leagel_1/utils/firebase_test.dart';

class InformationController extends GetxController {
  static InformationController get instance => Get.find();
  
  RxInt currentPage = 1.obs;

  // Use individual controllers without reactive wrappers to avoid conflicts
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController courtsController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController completeAddressController = TextEditingController();
  final TextEditingController yearsOfExperienceController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController(text: "+91");
  
  RxString loginType = "phone".obs;
  final ImagePicker _imagePicker = ImagePicker();
  RxString profileImage = "".obs;
  RxString selectedUserType = "individual".obs; // "individual" or "law_firm"
  RxList<String> selectedSpecializations = <String>[].obs;
  RxList<String> selectedServices = <String>[].obs; // List of selected services (max 10)
  RxBool isAddressPublic = true.obs;
  RxList<String> selectedLanguages = <String>[].obs; // List of selected languages (max 2)
  RxBool isLoading = false.obs;
  
  // New reactive variables for searchable dropdowns
  Rx<City?> selectedCity = Rx<City?>(null);
  Rx<Court?> selectedCourt = Rx<Court?>(null);

  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  void _initializeData() {
    try {
      dynamic argumentData = Get.arguments;
      if (argumentData != null && argumentData['userModel'] != null) {
        userModel.value = argumentData['userModel'];
        loginType.value = userModel.value.loginType ?? "phone";
        
        if (loginType.value == "phone") {
          phoneNumberController.text = userModel.value.phoneNumber ?? "";
          countryCodeController.text = userModel.value.countryCode ?? "+91";
        } else {
          emailController.text = userModel.value.email ?? "";
          fullNameController.text = userModel.value.fullName ?? "";
        }
        
        // Initialize new fields if they exist
        if (userModel.value.fullName != null) {
          fullNameController.text = userModel.value.fullName!;
        }
        if (userModel.value.specializations != null) {
          selectedSpecializations.value = userModel.value.specializations!;
        }
        if (userModel.value.services != null) {
          selectedServices.value = userModel.value.services!;
        }
        if (userModel.value.city != null) {
          cityController.text = userModel.value.city!;
        }
        if (userModel.value.completeAddress != null) {
          completeAddressController.text = userModel.value.completeAddress!;
        }
        if (userModel.value.yearsOfExperience != null) {
          yearsOfExperienceController.text = userModel.value.yearsOfExperience!;
        }
        if (userModel.value.userType != null) {
          selectedUserType.value = userModel.value.userType!;
        }
        if (userModel.value.languages != null) {
          selectedLanguages.value = userModel.value.languages!;
        }
        if (userModel.value.isAddressPublic != null) {
          isAddressPublic.value = userModel.value.isAddressPublic!;
        }
      }
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  void nextPage() {
    if (currentPage.value < 3) {
      // If going to completion screen (page 3), save data first
      if (currentPage.value == 2) {
        createAccount();
      } else {
        currentPage.value++;
        update();
      }
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      update();
    }
  }

  bool validateFirstPage() {
    if (fullNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneNumberController.text.trim().isEmpty ||
        selectedSpecializations.isEmpty ||
        selectedServices.isEmpty ||
        cityController.text.trim().isEmpty ||
        completeAddressController.text.trim().isEmpty ||
        yearsOfExperienceController.text.trim().isEmpty ||
        selectedLanguages.isEmpty) {
      ShowToastDialog.showToast("Please fill all required fields");
      return false;
    }
    
    if (!GetUtils.isEmail(emailController.text.trim())) {
      ShowToastDialog.showToast("Please enter a valid email address");
      return false;
    }
    
    if (selectedSpecializations.length > 3) {
      ShowToastDialog.showToast("You can select maximum 3 specializations");
      return false;
    }
    
    if (selectedLanguages.length > 2) {
      ShowToastDialog.showToast("You can select maximum 2 languages");
      return false;
    }
    
    // Validate years of experience
    final int? years = int.tryParse(yearsOfExperienceController.text.trim());
    if (years == null || years < 0 || years > 99) {
      ShowToastDialog.showToast("Please enter valid years of experience (0-99)");
      return false;
    }
    
    return true;
  }

  // Method for handling specialization selection (max 3)
  void toggleSpecialization(String specialization) {
    if (selectedSpecializations.contains(specialization)) {
      selectedSpecializations.remove(specialization);
      // Clear services when specialization is deselected
      selectedServices.clear();
    } else if (selectedSpecializations.length < 3) {
      selectedSpecializations.add(specialization);
    }
    update();
  }

  // Method for handling service selection (max 10)
  void toggleService(String service) {
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else if (selectedServices.length < 10) {
      selectedServices.add(service);
    }
    update();
  }

  // Method for handling user type selection
  void selectUserType(String userType) {
    selectedUserType.value = userType;
    update();
  }

  // Method for handling language selection (max 2)
  void toggleLanguage(String language) {
    if (selectedLanguages.contains(language)) {
      selectedLanguages.remove(language);
    } else if (selectedLanguages.length < 2) {
      selectedLanguages.add(language);
    }
    update();
  }

  // Popular languages list
  List<String> get popularLanguages => [
    'English',
    'Hindi',
    'Tamil',
    'Telugu',
    'Marathi',
    'Gujarati',
    'Kannada',
    'Bengali',
    'Malayalam',
    'Punjabi',
  ];

  // Method for toggling address visibility
  void toggleAddressVisibility() {
    isAddressPublic.value = !isAddressPublic.value;
    update();
  }

  Future<void> createAccount() async {
    if (isLoading.value) return;
    
    try {
      isLoading.value = true;
      update();
      
      ShowToastDialog.showLoader("Creating your account...");
      
      // Check if user is authenticated
      String currentUid = FireStoreUtils.getCurrentUid();
      if (currentUid.isEmpty) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("Authentication error. Please restart the app.");
        isLoading.value = false;
        return;
      }
      
      // Test Firebase connection and permissions
      print('Testing Firebase connection...');
      bool firebaseTest = await FirebaseTest.testFirebaseConnection();
      if (!firebaseTest) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("Firebase connection failed. Please check your internet connection and try again.");
        isLoading.value = false;
        return;
      }
      
      String fcmToken = await NotificationService.getToken();
      
      // Upload profile image if selected
      String profileImageUrl = "";
      if (profileImage.value.isNotEmpty) {
        try {
          profileImageUrl = await uploadUserImageToFireStorage(
            File(profileImage.value),
            "profileImage/$currentUid",
            File(profileImage.value).path.split('/').last,
          );
          
          if (profileImageUrl.isEmpty) {
            print('⚠️  Profile image upload failed, continuing without image');
          } else {
            print('✅ Profile image uploaded successfully: $profileImageUrl');
          }
        } catch (e) {
          print('❌ Error uploading profile image: $e');
          // Continue without profile image
        }
      }

      // Create user model with proper ID
      UserModel userModelData = UserModel(
        id: currentUid, // Use the current user's UID
        email: emailController.text.trim(),
        countryCode: countryCodeController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
        profilePic: profileImageUrl,
        fcmToken: fcmToken,
        createdAt: Timestamp.now(),
        isActive: true,
        isVerify: true,
        bio: bioController.text.trim(),
        walletAmount: "0.0",
        reviewSum: "0.0",
        reviewCount: "0",
        loginType: loginType.value,
        // New legal professional fields
        userType: selectedUserType.value,
        fullName: "Adv. ${fullNameController.text.trim()}",
        specializations: selectedSpecializations.toList(),
        services: selectedServices.toList(),
        courts: courtsController.text.trim().split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
        city: cityController.text.trim(),
        completeAddress: completeAddressController.text.trim(),
        isAddressPublic: isAddressPublic.value,
        yearsOfExperience: yearsOfExperienceController.text.trim(),
        languages: selectedLanguages.toList(),
      );

      print('Attempting to save user data for UID: $currentUid');
      bool success = await FireStoreUtils.updateUser(userModelData);
      
      ShowToastDialog.closeLoader();
      isLoading.value = false;
      
      if (success) {
        print('User data saved successfully');
        ShowToastDialog.showToast("Account created successfully!");
        currentPage.value = 3;
        update();
      } else {
        print('Failed to save user data');
        ShowToastDialog.showToast("Failed to create account. Please try again.");
      }
    } catch (e) {
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      print('Error creating account: $e');
      
      // Provide more specific error messages
      String errorMessage = "Failed to create account. Please try again.";
      if (e.toString().contains('permission-denied')) {
        errorMessage = "Permission denied. Please contact support.";
      } else if (e.toString().contains('network')) {
        errorMessage = "Network error. Please check your connection.";
      } else if (e.toString().contains('auth')) {
        errorMessage = "Authentication error. Please restart the app.";
      }
      
      ShowToastDialog.showToast(errorMessage);
      update();
    }
  }

  Future<void> pickImageFromGallery() async {
    await _pickImage(ImageSource.gallery);
  }

  Future<void> pickImageFromCamera() async {
    await _pickImage(ImageSource.camera);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 500,
        maxHeight: 500,
      );
      
      if (image != null) {
        profileImage.value = image.path;
        update();
      }
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("Failed to pick image: ${e.message}");
    } catch (e) {
      ShowToastDialog.showToast("Failed to pick image: ${e.toString()}");
    }
  }

  void showImagePickerDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                pickImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  void completeRegistration() {
    try {
      print('Completing registration...');
      ShowToastDialog.showToast("Welcome to Legal Network! You can now explore the app.");
      
   
      Future.delayed(const Duration(milliseconds: 500), () {
        if (Get.context != null) {
          Get.offAll(() => const MainNavigationScreen());
        }
      });
    } catch (e) {
      print('Error completing registration: $e');
      ShowToastDialog.showToast("Registration completed successfully!");
      if (Get.context != null) {
        Get.offAll(() => const MainNavigationScreen());
      }
    }
  }

  // Firebase Storage upload function
  Future<String> uploadUserImageToFireStorage(File file, String path, String fileName) async {
    try {
      print('📤 Starting upload to Firebase Storage...');
      print('   File path: ${file.path}');
      print('   Storage path: $path');
      print('   File name: $fileName');
      
      // Get firebase_storage instance
      final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
      
      // Create a reference to the file location
      final firebase_storage.Reference ref = storage.ref().child(path).child(fileName);
      
      // Upload the file
      final firebase_storage.UploadTask uploadTask = ref.putFile(file);
      
      // Wait for upload to complete
      final firebase_storage.TaskSnapshot snapshot = await uploadTask;
      
      // Get the download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      print('✅ Upload successful! Download URL: $downloadUrl');
      return downloadUrl;
      
    } catch (e) {
      print('❌ Error uploading to Firebase Storage: $e');
      // Return empty string on error so we can handle it gracefully
      return '';
    }
  }

  // City selection methods
  void onCitySelected(City? city) {
    selectedCity.value = city;
    if (city != null) {
      cityController.text = city.city;
      // Clear selected court when city changes
      selectedCourt.value = null;
      courtsController.clear();
    } else {
      cityController.clear();
    }
  }

  // Court selection methods
  void onCourtSelected(Court? court) {
    selectedCourt.value = court;
    if (court != null) {
      courtsController.text = court.courtName;
      // Auto-select city if court is selected and city is not selected
      if (selectedCity.value == null) {
        // Since Court model only has state, we need to find a city from that state
        // For now, we'll just set the city controller to the state name
        cityController.text = court.state;
      }
    } else {
      courtsController.clear();
    }
  }



  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    courtsController.dispose();
    cityController.dispose();
    completeAddressController.dispose();
    yearsOfExperienceController.dispose();
    bioController.dispose();
    countryCodeController.dispose();
    super.onClose();
  }
} 