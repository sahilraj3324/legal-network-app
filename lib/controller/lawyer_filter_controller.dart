import 'package:get/get.dart';

class LawyerFilterController extends GetxController {
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
  
  // Legal Specializations - Comprehensive list
  final List<String> allSpecializations = [
    // Civil Law
    'Civil Litigation',
    'Contract Law',
    'Property Law',
    'Tort Law',
    'Personal Injury',
    'Employment Law',
    'Consumer Protection',
    'Debt Recovery',
    'Partnership Disputes',
    
    // Criminal Law
    'Criminal Defense',
    'White Collar Crime',
    'Cyber Crime',
    'Economic Offences',
    'Narcotics Cases',
    'Domestic Violence',
    'Bail Applications',
    'Appeals',
    
    // Corporate & Commercial
    'Corporate Law',
    'Mergers & Acquisitions',
    'Securities Law',
    'Banking Law',
    'Insurance Law',
    'Competition Law',
    'International Trade',
    'Joint Ventures',
    'Compliance',
    
    // Family Law
    'Divorce',
    'Child Custody',
    'Adoption',
    'Domestic Relations',
    'Maintenance',
    'Property Settlement',
    'Pre-nuptial Agreements',
    
    // Real Estate
    'Property Transactions',
    'Construction Law',
    'Land Disputes',
    'RERA Matters',
    'Title Verification',
    'Lease Agreements',
    'Property Development',
    
    // Intellectual Property
    'Patent Law',
    'Trademark Law',
    'Copyright Law',
    'Trade Secrets',
    'IP Licensing',
    'Domain Disputes',
    'Design Rights',
    
    // Constitutional & Administrative
    'Constitutional Law',
    'Administrative Law',
    'Public Interest Litigation',
    'Fundamental Rights',
    'Government Relations',
    'Regulatory Matters',
    'Judicial Review',
    
    // Tax Law
    'Income Tax',
    'GST',
    'Corporate Tax',
    'International Tax',
    'Tax Appeals',
    'Transfer Pricing',
    'Customs Law',
    
    // Labour & Employment
    'Industrial Disputes',
    'Labour Compliance',
    'Employee Benefits',
    'Workplace Harassment',
    'Termination Issues',
    'Trade Union Matters',
    
    // Environmental Law
    'Environmental Compliance',
    'Pollution Control',
    'Environmental Impact',
    'Green Regulations',
    'Climate Law',
    
    // Technology & IT
    'IT Law',
    'Data Privacy',
    'E-commerce Law',
    'Software Licensing',
    'Technology Contracts',
    'GDPR Compliance',
    
    // International Law
    'International Arbitration',
    'Cross-border Transactions',
    'International Contracts',
    'Foreign Investment',
    'Immigration Law',
    
    // Specialized Areas
    'Aviation Law',
    'Maritime Law',
    'Entertainment Law',
    'Sports Law',
    'Media Law',
    'Healthcare Law',
    'Education Law',
    'Energy Law',
    'Mining Law',
    'Agricultural Law',
    'Tribal Law',
    'Human Rights',
    'Animal Rights',
    'Election Law',
    'Arbitration',
    'Mediation',
    'Insolvency & Bankruptcy',
    'Wills & Succession',
  ];
  
  // Legal Services - Comprehensive list
  final List<String> allServices = [
    // Consultation Services
    'Legal Consultation',
    'Legal Advice',
    'Opinion Letters',
    'Risk Assessment',
    'Compliance Review',
    
    // Documentation Services
    'Contract Drafting',
    'Agreement Review',
    'Legal Documentation',
    'Due Diligence',
    'Document Verification',
    'Notarization Services',
    
    // Litigation Services
    'Court Representation',
    'Case Filing',
    'Appeal Services',
    'Bail Applications',
    'Interim Relief',
    'Execution Proceedings',
    'Evidence Collection',
    
    // Corporate Services
    'Company Formation',
    'Board Meetings',
    'Shareholder Agreements',
    'Regulatory Filings',
    'Licensing Applications',
    'Audit Support',
    'Merger Documentation',
    
    // Property Services
    'Title Search',
    'Property Registration',
    'Mutation Services',
    'NOC Applications',
    'Development Approvals',
    'Lease Drafting',
    
    // Family Services
    'Divorce Proceedings',
    'Custody Applications',
    'Maintenance Claims',
    'Adoption Procedures',
    'Marriage Registration',
    'Succession Planning',
    
    // Criminal Services
    'Bail Representation',
    'Trial Defense',
    'Police Station Assistance',
    'Anticipatory Bail',
    'Quashing Petitions',
    'Criminal Appeals',
    
    // Tax Services
    'Tax Returns',
    'Tax Planning',
    'Appeal Representation',
    'Notice Replies',
    'Refund Claims',
    'GST Registration',
    
    // IP Services
    'Patent Filing',
    'Trademark Registration',
    'Copyright Registration',
    'IP Search',
    'Infringement Actions',
    'Licensing Agreements',
    
    // Alternative Dispute Resolution
    'Arbitration Services',
    'Mediation Services',
    'Conciliation',
    'Settlement Negotiations',
    
    // Specialized Services
    'Immigration Applications',
    'Visa Assistance',
    'Work Permits',
    'Deportation Defense',
    'Asylum Applications',
    'Legal Translation',
    'Process Serving',
    'Legal Research',
    'Training & Workshops',
    'Legal Audit',
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
    } else {
      selectedSpecializations.add(specialization);
    }
  }
  
  void toggleService(String service) {
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      selectedServices.add(service);
    }
  }
  
  void toggleCity(String city) {
    if (selectedCities.contains(city)) {
      selectedCities.remove(city);
    } else {
      selectedCities.add(city);
    }
  }
  
  void toggleCourt(String court) {
    if (selectedCourts.contains(court)) {
      selectedCourts.remove(court);
    } else {
      selectedCourts.add(court);
    }
  }
  
  void toggleLanguage(String language) {
    if (selectedLanguages.contains(language)) {
      selectedLanguages.remove(language);
    } else {
      selectedLanguages.add(language);
    }
  }
  
  void toggleUserType(String userType) {
    String mappedType = userType == 'Individual Lawyer' ? 'individual' : 'law_firm';
    if (selectedUserTypes.contains(mappedType)) {
      selectedUserTypes.remove(mappedType);
    } else {
      selectedUserTypes.add(mappedType);
    }
  }
  
  void setExperience(String experience) {
    selectedExperience.value = experience;
  }
  
  void setSearchText(String text) {
    searchText.value = text;
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
} 