import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leagel_1/controller/information_controller.dart';
import 'package:leagel_1/app/widgets/searchable_city_dropdown.dart';
import 'package:leagel_1/app/widgets/searchable_court_dropdown.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    final controller = InformationController.instance;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
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
                  'It Won\'t Take More Than 2 Minutes. ',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                    letterSpacing: -1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please provide your personal details to complete your profile.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              
              // You Are Section
              const Text(
                'You Are',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Individual Lawyer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: Radio<String>(
                      value: 'individual',
                      groupValue: controller.selectedUserType.value,
                      onChanged: (String? value) {
                        if (value != null) {
                          controller.selectUserType(value);
                        }
                      },
                      activeColor: Colors.blue,
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Law Firm',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: Radio<String>(
                      value: 'law_firm',
                      groupValue: controller.selectedUserType.value,
                      onChanged: (String? value) {
                        if (value != null) {
                          controller.selectUserType(value);
                        }
                      },
                      activeColor: Colors.blue,
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 24),
              
              // Your Name
              const Text(
                'Your Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Adv.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: controller.fullNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Email
              const Text(
                'Email Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email address',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Phone Number (Verified)
              const Text(
                'Phone Number (Verified)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: TextFormField(
                      controller: controller.countryCodeController,
                      enabled: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: controller.phoneNumberController,
                      enabled: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        suffixIcon: const Icon(
                          Icons.verified,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Specialization
              const Text(
                'Specialization',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => _buildSpecializationSection(controller)),
              const SizedBox(height: 24),
              
              // Services - Only show if specializations are selected
              Obx(() => controller.selectedSpecializations.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Services (Select up to 10)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildServicesSection(controller),
                        const SizedBox(height: 24),
                      ],
                    )
                  : const SizedBox()),

              // City
              const Text(
                'City',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => SearchableCityDropdown(
                selectedCity: controller.selectedCity.value,
                onCitySelected: controller.onCitySelected,
                decoration: InputDecoration(
                  hintText: 'Search for your city...',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              )),
              const SizedBox(height: 24),
              
              // Courts
              const Text(
                'Courts',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => SearchableCourtDropdown(
                selectedCourt: controller.selectedCourt.value,
                onCourtSelected: controller.onCourtSelected,
                filterByState: controller.selectedCity.value?.state,
                decoration: InputDecoration(
                  hintText: 'Search for a court...',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              )),
              const SizedBox(height: 24),
              
                  
              
              // Complete Address
              const Text(
                'Complete Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.completeAddressController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter your complete address',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your complete address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Address Visibility Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Display Address Publicly',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Obx(() => Switch(
                    value: controller.isAddressPublic.value,
                    onChanged: (value) => controller.toggleAddressVisibility(),
                    activeColor: Colors.blue,
                  )),
                ],
              ),
              const SizedBox(height: 24),
              
              // Years of Experience
              const Text(
                'Years of Experience',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.yearsOfExperienceController,
                keyboardType: TextInputType.number,
                maxLength: 2,
                decoration: InputDecoration(
                  hintText: 'Enter years of experience',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your years of experience';
                  }
                  final int? years = int.tryParse(value);
                  if (years == null || years < 0 || years > 99) {
                    return 'Please enter a valid number (0-99)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Language Selection
              const Text(
                'Languages (Select up to 2)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => _buildLanguageSelection(controller)),
              const SizedBox(height: 24),
              
              // Bio
              const Text(
                'Bio (Optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.bioController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tell us about yourself...',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : () {
                    if (controller.formKey.currentState!.validate()) {
                      if (controller.validateFirstPage()) {
                        controller.nextPage();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 2,
                      ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 30,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                )),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecializationSection(InformationController controller) {
    final List<String> specializations = specializationServices.keys.toList();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select your specializations (you can select up to 3)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: specializations.map((specialization) {
                  final isSelected = controller.selectedSpecializations.contains(specialization);
                  final canSelect = controller.selectedSpecializations.length < 3 || isSelected;
                  return GestureDetector(
                    onTap: canSelect ? () => controller.toggleSpecialization(specialization) : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade50 : (canSelect ? Colors.white : Colors.grey.shade100),
                        border: Border.all(
                          color: isSelected ? Colors.blue : (canSelect ? Colors.grey.shade300 : Colors.grey.shade200),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        specialization,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.blue : (canSelect ? Colors.black : Colors.grey.shade400),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        if (controller.selectedSpecializations.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Please select at least one specialization',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildServicesSection(InformationController controller) {
    // Get all services for selected specializations
    List<String> availableServices = [];
    for (String specialization in controller.selectedSpecializations) {
      if (specializationServices.containsKey(specialization)) {
        availableServices.addAll(specializationServices[specialization]!);
      }
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select services for your selected specializations (up to 10) - ${controller.selectedServices.length}/10 selected',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              if (availableServices.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableServices.map((service) {
                    final isSelected = controller.selectedServices.contains(service);
                    final canSelect = controller.selectedServices.length < 10 || isSelected;
                    return GestureDetector(
                      onTap: canSelect ? () => controller.toggleService(service) : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green.shade50 : (canSelect ? Colors.white : Colors.grey.shade100),
                          border: Border.all(
                            color: isSelected ? Colors.green : (canSelect ? Colors.grey.shade300 : Colors.grey.shade200),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          service,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.green.shade700 : (canSelect ? Colors.black : Colors.grey.shade400),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )
              else
                const Text(
                  'Please select at least one specialization to view available services',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
        if (controller.selectedServices.isEmpty && controller.selectedSpecializations.isNotEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Please select at least one service',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLanguageSelection(InformationController controller) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select languages (you can select up to 2)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.popularLanguages.map((language) {
                  final isSelected = controller.selectedLanguages.contains(language);
                  final canSelect = controller.selectedLanguages.length < 2 || isSelected;
                  return GestureDetector(
                    onTap: canSelect ? () => controller.toggleLanguage(language) : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade50 : (canSelect ? Colors.white : Colors.grey.shade100),
                        border: Border.all(
                          color: isSelected ? Colors.blue : (canSelect ? Colors.grey.shade300 : Colors.grey.shade200),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        language,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.blue : (canSelect ? Colors.black : Colors.grey.shade400),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        if (controller.selectedLanguages.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Please select at least one language',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }
} 