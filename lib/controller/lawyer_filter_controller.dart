import 'package:get/get.dart';
import '../model/city_model.dart';
import '../model/court_model.dart';

class LawyerFilterController extends GetxController {
  // Specializations and Services mapping
  static const Map<String, List<String>> specializationServices = {
    'CIVIL MATTERS': [
      'Property Disputes',
      'Family Property Disputes',
      'Partition Disputes',
      'Wrongful Possession Disputes',
      'Money Recovery Disputes',
      'Landlord Tenant Disputes',
      'Name Change',
      'Succession Certificate',
      'Consumer Complaints',
      'NRI property issues',
      'Illegal construction',
      'Builder Delay/Fraud',
      'Arbitration',
    ],
    'CRIMINAL MATTERS': [
      'Bail/Anticipatory Bail',
      'Bail Lawyer',
      'Corruption',
      'Defamation',
      'FIR filing/quashing',
      'Murder/Attempt to Murder',
      'Narcotic/Drugs',
      'Physical/Sexual Abuse',
      'Summons/Warrants',
      'Police Not filing FIR',
      'Theft/Robbery',
      'Threat/Injury',
      'Cyber Crimes',
      'Traffic Challans',
      'Dowry Death',
      'Arrest',
      'Criminal Complaints',
      'Cheque Bounce',
    ],
    'FAMILY MATTERS': [
      'Mutual Consent Divorce',
      'Divorce / Talaq',
      'Reply /sent legal notice for Divorce',
      'Appeal in Divorce Case',
      'Dowry Demand',
      'Domestic Violence',
      'Abuse',
      'Alimony',
      'Maintenance',
      'Child Custody',
      'NRI Divorce Matters',
      'Restitution of Conjugal Rights',
      'Complaint before CAW Cell',
      'Family Partition',
      'Will Drafting',
      'Adoption and Guardianship',
    ],
    'LABOUR/EMPLOYEE MATTERS': [
      'Sexual Harassment Complaints',
      'Payment of Bonus',
      'Maternity Benefits',
      'Illegal / Wrongful Termination',
      'Compensation/Claims',
      'Breach of Employment Contract',
      'Labour Union Matters',
      'Suspension and Termination from Central Govt/ State Govt /PSU Services',
      'Service matters',
    ],
    'TAXATION MATTERS': [
      'Income Tax filing',
      'Income Tax Refund',
      'Income Tax Scrutiny',
      'Income Tax Appeals',
      'Sales Tax and VAT Advices',
      'GST filing',
      'GST Registration',
      'GST Disputes',
    ],
    'DOCUMENTATION & REGISTRATION': [
      'Power of attorney',
      'Gift Deed Registration',
      'Sale Deed Registration',
      'Partition Deed Registration',
      'Will Registration',
      'Relinquishment Deed Registration',
      'Rent Agreement/ Lease Agreement',
      'Property Verification',
      'Court Marriage/Marriage Registration',
    ],
    'TRADEMARK & COPYRIGHT MATTERS': [
      'Filing defending of patent matters',
      'Filing defending of Copyright matters',
      'Filing defending of Trademark Matters',
      'Trademark Violations',
      'Patent Violations',
      'Copyright Violation',
    ],
    'HIGH COURT MATTERS': [
      'High Court case filing',
      'Appeals',
      'Writs',
      'Revision',
      'Review',
      'PIL',
      'Couple Protection',
    ],
    'SUPREME COURT MATTERS': [
      'Supreme Court case filing',
      'Appeals',
      'Writs',
      'Revision',
      'Review',
      'PIL',
      'Advocate on Record (AOR)',
    ],
    'FORUMS AND TRIBUNAL MATTERS': [
      'Consumer Complaints',
      'RERA',
      'Debt Recovery Tribunals',
      'Municipal Tribunals',
      'CLAT',
      'NCLT',
      'MACT',
    ],
    'BUSINESS MATTERS': [
      'Private Limited Company Registration',
      'LLP Company Registration',
      'Public Limited Company Registration',
      'One Person Company Registration',
      'Nidhi Company Registration',
      'Section 8 Company Registration',
      'GST Registration',
      'Trademark Registration',
      'ISO Certification',
      'FSSAI Registration',
      'Digital Signature Certificate',
      'IEC Registration',
    ],
  };

  // Selected filters
  RxList<String> selectedSpecializations = <String>[].obs;
  RxList<String> selectedServices = <String>[].obs;
  RxList<String> selectedCities = <String>[].obs;
  RxList<String> selectedCourts = <String>[].obs;
  RxList<String> selectedLanguages = <String>[].obs;
  RxList<String> selectedUserTypes = <String>[].obs;
  
  // Experience range
  RxString selectedExperience = ''.obs;
  
  // Search text
  RxString searchText = ''.obs;
  
  // Filter section visibility
  RxBool showFilters = false.obs;
  
  // Individual section expand/collapse states
  RxBool showSpecializations = false.obs;
  RxBool showServices = false.obs;
  RxBool showLocations = false.obs;
  RxBool showCourts = false.obs;
  RxBool showLanguages = false.obs;
  RxBool showExperience = false.obs;
  RxBool showUserTypes = false.obs;
  
  // City and Court selection
  Rx<City?> selectedCity = Rx<City?>(null);
  Rx<Court?> selectedCourt = Rx<Court?>(null);
  
  // Legal Specializations - Comprehensive list
  final List<String> allSpecializations = [
    // Civil Law
    'CIVIL MATTERS',
    'CRIMINAL MATTERS',
    'FAMILY MATTERS',
    'LABOUR/EMPLOYEE MATTERS',
    'TAXATION MATTERS',
    'DOCUMENTATION & REGISTRATION',
    'TRADEMARK & COPYRIGHT MATTERS',
    'HIGH COURT MATTERS',
    'SUPREME COURT MATTERS',
    'FORUMS AND TRIBUNAL MATTERS',
    'BUSINESS MATTERS',
  ];
      
  // Legal Services - Comprehensive list
  final List<String> allServices = [
    // Consultation Services
  'Private Limited Company Registration',
      'LLP Company Registration',
      'Public Limited Company Registration',
      'One Person Company Registration',
      'Nidhi Company Registration',
      'Section 8 Company Registration',
      'GST Registration',
      'Trademark Registration',
      'ISO Certification',
      'FSSAI Registration',
      'Digital Signature Certificate',
      'IEC Registration',

      'Consumer Complaints',
      'RERA',
      'Debt Recovery Tribunals',
      'Municipal Tribunals',
      'CLAT',
      'NCLT',
      'MACT',

      'Supreme Court case filing',
      'Appeals',
      'Writs',
      'Revision',
      'Review',
      'PIL',
      'Advocate on Record (AOR)',

      'High Court case filing',
      'Appeals',
      'Writs',
      'Revision',
      'Review',
      'PIL',
      'Couple Protection',

      'Filing defending of patent matters',
      'Filing defending of Copyright matters',
      'Filing defending of Trademark Matters',
      'Trademark Violations',
      'Patent Violations',
      'Copyright Violation',

      'Power of attorney',
      'Gift Deed Registration',
      'Sale Deed Registration',
      'Partition Deed Registration',
      'Will Registration',
      'Relinquishment Deed Registration',
      'Rent Agreement/ Lease Agreement',
      'Property Verification',
      'Court Marriage/Marriage Registration',

      'Income Tax filing',
      'Income Tax Refund',
      'Income Tax Scrutiny',
      'Income Tax Appeals',
      'Sales Tax and VAT Advices',
      'GST filing',
      'GST Registration',
      'GST Disputes',

      'Sexual Harassment Complaints',
      'Payment of Bonus',
      'Maternity Benefits',
      'Illegal / Wrongful Termination',
      'Compensation/Claims',
      'Breach of Employment Contract',
      'Labour Union Matters',
      'Suspension and Termination from Central Govt/ State Govt /PSU Services',
      'Service matters',

      'Mutual Consent Divorce',
      'Divorce / Talaq',
      'Reply /sent legal notice for Divorce',
      'Appeal in Divorce Case',
      'Dowry Demand',
      'Domestic Violence',
      'Abuse',
      'Alimony',
      'Maintenance',
      'Child Custody',
      'NRI Divorce Matters',
      'Restitution of Conjugal Rights',
      'Complaint before CAW Cell',
      'Family Partition',
      'Will Drafting',
      'Adoption and Guardianship',

      'Bail/Anticipatory Bail',
      'Bail Lawyer',
      'Corruption',
      'Defamation',
      'FIR filing/quashing',
      'Murder/Attempt to Murder',
      'Narcotic/Drugs',
      'Physical/Sexual Abuse',
      'Summons/Warrants',
      'Police Not filing FIR',
      'Theft/Robbery',
      'Threat/Injury',
      'Cyber Crimes',
      'Traffic Challans',
      'Dowry Death',
      'Arrest',
      'Criminal Complaints',
      'Cheque Bounce',

      'Property Disputes',
      'Family Property Disputes',
      'Partition Disputes',
      'Wrongful Possession Disputes',
      'Money Recovery Disputes',
      'Landlord Tenant Disputes',
      'Name Change',
      'Succession Certificate',
      'Consumer Complaints',
      'NRI property issues',
      'Illegal construction',
      'Builder Delay/Fraud',
      'Arbitration',
  ];
  
  // Experience levels
  final List<String> experienceLevels = [
    'Less than 1 year',
    '1-3 years',
    '3-5 years',
    '5-10 years',
    '10-15 years',
    '15-20 years',
    '20+ years',
  ];
  
  // User types
  final List<String> userTypes = [
    'Individual Lawyer',
    'Law Firm',
  ];
  
  // Languages commonly spoken by lawyers
  final List<String> languages = [
    'English',
    'Hindi',
    'Bengali',
    'Telugu',
    'Marathi',
    'Tamil',
    'Gujarati',
    'Urdu',
    'Kannada',
    'Odia',
    'Malayalam',
    'Punjabi',
    'Assamese',
    'Nepali',
    'Sanskrit',
    'Arabic',
    'French',
    'German',
    'Spanish',
    'Portuguese',
  ];
  
  // Major cities where lawyers practice
  final List<String> majorCities = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Hyderabad',
    'Chennai',
    'Kolkata',
    'Pune',
    'Ahmedabad',
    'Surat',
    'Jaipur',
    'Lucknow',
    'Kanpur',
    'Nagpur',
    'Indore',
    'Bhopal',
    'Visakhapatnam',
    'Pimpri-Chinchwad',
    'Patna',
    'Vadodara',
    'Ghaziabad',
    'Ludhiana',
    'Agra',
    'Nashik',
    'Faridabad',
    'Meerut',
    'Rajkot',
    'Kalyan-Dombivali',
    'Vasai-Virar',
    'Varanasi',
    'Srinagar',
    'Aurangabad',
    'Dhanbad',
    'Amritsar',
    'Navi Mumbai',
    'Allahabad',
    'Ranchi',
    'Howrah',
    'Coimbatore',
    'Jabalpur',
    'Gwalior',
    'Vijayawada',
    'Jodhpur',
    'Madurai',
    'Raipur',
    'Kota',
    'Chandigarh',
    'Guwahati',
    'Solapur',
    'Hubballi-Dharwad',
    'Tiruchirappalli',
    'Bareilly',
    'Mysore',
    'Tiruppur',
    'Gurgaon',
    'Aligarh',
    'Jalandhar',
    'Bhubaneswar',
    'Salem',
    'Warangal',
    'Guntur',
    'Bhiwandi',
    'Saharanpur',
    'Gorakhpur',
    'Bikaner',
    'Amravati',
    'Noida',
    'Jamshedpur',
    'Bhilai',
    'Cuttack',
    'Firozabad',
    'Kochi',
    'Nellore',
    'Bhavnagar',
    'Dehradun',
    'Durgapur',
    'Asansol',
    'Rourkela',
    'Nanded',
    'Kolhapur',
    'Ajmer',
    'Akola',
    'Gulbarga',
    'Jamnagar',
    'Ujjain',
    'Loni',
    'Siliguri',
    'Jhansi',
    'Ulhasnagar',
    'Jammu',
    'Sangli-Miraj & Kupwad',
    'Mangalore',
    'Erode',
    'Belgaum',
    'Ambattur',
    'Tirunelveli',
    'Malegaon',
    'Gaya',
    'Jalgaon',
    'Udaipur',
    'Maheshtala',
  ];
  
  // Court types
  final List<String> courtTypes = [
    'Supreme Court of India',
    'High Court',
    'District Court',
    'Session Court',
    'Magistrate Court',
    'Family Court',
    'Commercial Court',
    'Labour Court',
    'Consumer Court',
    'Revenue Court',
    'Tribunal',
    'Appellate Tribunal',
    'Tax Tribunal',
    'Company Law Tribunal',
    'Securities Tribunal',
    'Telecom Tribunal',
    'Environment Tribunal',
    'Debt Recovery Tribunal',
    'Administrative Tribunal',
    'Arbitration Center',
    'Lok Adalat',
    'Permanent Lok Adalat',
    'Motor Accident Claims Tribunal',
    'Special Courts',
    'Fast Track Courts',
    'Juvenile Justice Board',
    'Women\'s Court',
    'Senior Citizens Court',
    'E-Courts',
    'Virtual Courts',
  ];

  // Filter methods
  void toggleSpecialization(String specialization) {
    if (selectedSpecializations.contains(specialization)) {
      selectedSpecializations.remove(specialization);
      // Clear services that are no longer available
      _clearInvalidServices();
    } else {
      selectedSpecializations.add(specialization);
    }
    update();
  }
  
  void toggleService(String service) {
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      selectedServices.add(service);
    }
    update();
  }
  
  void toggleCity(String city) {
    if (selectedCities.contains(city)) {
      selectedCities.remove(city);
      // Clear courts that are no longer available
      _clearInvalidCourts();
    } else {
      selectedCities.add(city);
    }
    update();
  }
  
  void toggleCourt(String court) {
    if (selectedCourts.contains(court)) {
      selectedCourts.remove(court);
    } else {
      selectedCourts.add(court);
    }
    update();
  }
  
  void toggleLanguage(String language) {
    if (selectedLanguages.contains(language)) {
      selectedLanguages.remove(language);
    } else {
      selectedLanguages.add(language);
    }
    update();
  }
  
  void toggleUserType(String userType) {
    String mappedType = userType == 'Individual Lawyer' ? 'individual' : 'law_firm';
    if (selectedUserTypes.contains(mappedType)) {
      selectedUserTypes.remove(mappedType);
    } else {
      selectedUserTypes.add(mappedType);
    }
    update();
  }
  
  void setExperience(String experience) {
    selectedExperience.value = experience;
    update();
  }
  
  void setSearchText(String text) {
    searchText.value = text;
    update();
  }
  
  void clearAllFilters() {
    selectedSpecializations.clear();
    selectedServices.clear();
    selectedCities.clear();
    selectedCourts.clear();
    selectedLanguages.clear();
    selectedUserTypes.clear();
    selectedExperience.value = '';
    searchText.value = '';
    selectedCity.value = null;
    selectedCourt.value = null;
    update();
  }

  void toggleFilters() {
    showFilters.value = !showFilters.value;
    update();
  }

  // Individual section toggles
  void toggleSpecializations() {
    showSpecializations.value = !showSpecializations.value;
    update();
  }

  void toggleServices() {
    showServices.value = !showServices.value;
    update();
  }

  void toggleLocations() {
    showLocations.value = !showLocations.value;
    update();
  }

  void toggleCourts() {
    showCourts.value = !showCourts.value;
    update();
  }

  void toggleLanguages() {
    showLanguages.value = !showLanguages.value;
    update();
  }

  void toggleExperience() {
    showExperience.value = !showExperience.value;
    update();
  }

  void toggleUserTypes() {
    showUserTypes.value = !showUserTypes.value;
    update();
  }

  // City and Court selection methods (from information_controller.dart)
  void onCitySelected(City? city) {
    selectedCity.value = city;
    if (city != null) {
      // Add city to selected cities if not already there
      if (!selectedCities.contains(city.city)) {
        selectedCities.add(city.city);
      }
      // Clear selected court when city changes
      selectedCourt.value = null;
    }
    update();
  }

  void onCourtSelected(Court? court) {
    selectedCourt.value = court;
    if (court != null) {
      // Add court to selected courts if not already there
      if (!selectedCourts.contains(court.courtName)) {
        selectedCourts.add(court.courtName);
      }
    }
    update();
  }
  
  bool get hasActiveFilters {
    return selectedSpecializations.isNotEmpty ||
           selectedServices.isNotEmpty ||
           selectedCities.isNotEmpty ||
           selectedCourts.isNotEmpty ||
           selectedLanguages.isNotEmpty ||
           selectedUserTypes.isNotEmpty ||
           selectedExperience.value.isNotEmpty ||
           searchText.value.isNotEmpty;
  }
  
  int get activeFilterCount {
    int count = 0;
    if (selectedSpecializations.isNotEmpty) count++;
    if (selectedServices.isNotEmpty) count++;
    if (selectedCities.isNotEmpty) count++;
    if (selectedCourts.isNotEmpty) count++;
    if (selectedLanguages.isNotEmpty) count++;
    if (selectedUserTypes.isNotEmpty) count++;
    if (selectedExperience.value.isNotEmpty) count++;
    if (searchText.value.isNotEmpty) count++;
    return count;
  }

  // Get available services based on selected specializations
  List<String> get availableServices {
    if (selectedSpecializations.isEmpty) {
      return allServices; // Show all services if no specializations selected
    }
    
    List<String> services = [];
    for (String specialization in selectedSpecializations) {
      if (specializationServices.containsKey(specialization)) {
        services.addAll(specializationServices[specialization]!);
      }
    }
    return services.toSet().toList(); // Remove duplicates
  }

  // Get available courts based on selected cities (filter by state)
  List<String> get availableCourts {
    if (selectedCities.isEmpty) {
      return courtTypes; // Show all courts if no cities selected
    }
    
    // For now, return all courts. In a real implementation, you would:
    // 1. Map cities to their states
    // 2. Filter courts by state
    // Since we don't have city-state mapping in the current structure,
    // we'll return all courts for now
    return courtTypes;
  }



  // Helper method to clear services that are no longer valid
  void _clearInvalidServices() {
    List<String> validServices = availableServices;
    selectedServices.removeWhere((service) => !validServices.contains(service));
  }

  // Helper method to clear courts that are no longer valid
  void _clearInvalidCourts() {
    List<String> validCourts = availableCourts;
    selectedCourts.removeWhere((court) => !validCourts.contains(court));
  }
} 