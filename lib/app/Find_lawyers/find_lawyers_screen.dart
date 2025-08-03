import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/user_model.dart';
import '../../utils/fire_store_utils.dart';
import '../../utils/constant.dart';
import '../../controller/lawyer_filter_controller.dart';
import '../chat/chat_screen.dart';
import '../widgets/searchable_city_dropdown.dart';
import '../widgets/searchable_court_dropdown.dart';

class FindLawyersScreen extends StatelessWidget {
  const FindLawyersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LawyerFilterController>(
      init: LawyerFilterController(),
      builder: (filterController) => _buildScaffold(context, filterController),
    );
  }

  Widget _buildScaffold(BuildContext context, LawyerFilterController filterController) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
        title: Text(
          'Find Profiles',
          style: GoogleFonts.instrumentSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  filterController.toggleFilters();
                },
                icon: Icon(
                  filterController.showFilters.value ? Icons.close : Icons.filter_list,
                  color: Colors.black,
                ),
              ),
              if (filterController.hasActiveFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${filterController.activeFilterCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),



      body: Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.grey.shade50,
        Colors.white,
      ],
    ),
  ),
  child: SafeArea(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          children: [
            // Search bar
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  filterController.setSearchText(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search by specialization, name, or location...',
                  hintStyle: GoogleFonts.instrumentSans(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade500,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                style: GoogleFonts.instrumentSans(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),

            // Expandable Filter Section
            if (filterController.showFilters.value) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.33,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _buildInlineFilters(filterController),
              ),
              const SizedBox(height: 16),
            ],

            // Lawyers list (not expanded, just part of the scrollable column)
            StreamBuilder<QuerySnapshot>(
              stream: _buildFilteredQuery(filterController),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading lawyers',
                          style: GoogleFonts.instrumentSans(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1565C0)),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_search,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No lawyers found',
                          style: GoogleFonts.instrumentSans(
                            fontSize: 20,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Check back later for more legal professionals',
                          style: GoogleFonts.instrumentSans(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                List<UserModel> lawyers = snapshot.data!.docs
                    .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
                    .where((user) => user.id != FireStoreUtils.getCurrentUid())
                    .where((user) => _matchesFilters(user, filterController))
                    .toList();

                return ListView.builder(
                  shrinkWrap: true, // Important for embedding inside SingleChildScrollView!
                  physics: const NeverScrollableScrollPhysics(), // Disable inner scroll
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: lawyers.length,
                  itemBuilder: (context, index) {
                    UserModel lawyer = lawyers[index];
                    return _buildLawyerCard(lawyer, context);
                  },
                );
              },
            ),
          ],
        ),
      ),
    ),
  ),
),



    );
  }




  Widget _buildLawyerCard(UserModel lawyer, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF1565C0).withOpacity(0.1),
                  child: Text(
                    lawyer.getDisplayName().isNotEmpty 
                        ? lawyer.getDisplayName()[0].toUpperCase()
                        : 'L',
                    style: GoogleFonts.instrumentSans(
                      color: const Color(0xFF1565C0),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Name and basic info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lawyer.getDisplayName(),
                        style: GoogleFonts.instrumentSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      if (lawyer.city != null && lawyer.city!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              lawyer.city!,
                              style: GoogleFonts.instrumentSans(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Chat button
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF51D5FF),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Get.to(() => const ChatScreen(), arguments: {
                        'receiverModel': lawyer,
                      });
                    },
                   
                    icon: const Icon(
                      Icons.chat,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            
            // Specializations
            if (lawyer.specializations != null && lawyer.specializations!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Specializations:',
                style: GoogleFonts.instrumentSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: lawyer.specializations!.take(3).map((specialization) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1565C0).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      specialization,
                      style: GoogleFonts.instrumentSans(
                        fontSize: 12,
                        color: const Color(0xFF1565C0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            
            // Services
            if (lawyer.services != null && lawyer.services!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Services: ${lawyer.services!.take(2).join(", ")}${lawyer.services!.length > 2 ? "..." : ""}',
                style: GoogleFonts.instrumentSans(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }




  Widget _buildInlineFilters(LawyerFilterController controller) {
  return Column(
    children: [
      // Fixed header (you can keep or remove this)
      Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Text(
              'Apply Filter',
              style: GoogleFonts.instrumentSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(221, 70, 70, 70),
              ),
            ),
            const Spacer(),
            if (controller.hasActiveFilters)
              TextButton(
                onPressed: controller.clearAllFilters,
                child: Text(
                  'Clear All (${controller.activeFilterCount})',
                  style: GoogleFonts.instrumentSans(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),

      // Inline filters: wraps into new lines when needed
      Expanded(
        child: Scrollbar(
          thumbVisibility: true,
          radius: const Radius.circular(8),
          thickness: 4,
          child: SingleChildScrollView(
            
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child:Wrap(
  spacing: 9,    // horizontal gap between pills
  runSpacing: 12, // vertical gap when wrapping
  children: [
    _buildExpandableSection(
      title: 'Specialization',
      subtitle: '${controller.selectedSpecializations.length} selected',
      isExpanded: controller.showSpecializations.value,
      onToggle: controller.toggleSpecializations,
      child: _buildSpecializationContent(controller),
    ),
    // Only show Services if Specialization is selected
    if (controller.selectedSpecializations.isNotEmpty)
      _buildExpandableSection(
        title: 'Services',
        subtitle: '${controller.selectedServices.length} selected',
        isExpanded: controller.showServices.value,
        onToggle: controller.toggleServices,
        child: _buildServicesContent(controller),
      ),
    _buildExpandableSection(
      title: 'Cities',
      subtitle: '${controller.selectedCities.length} selected',
      isExpanded: controller.showLocations.value,
      onToggle: controller.toggleLocations,
      child: _buildLocationContent(controller),
    ),
    _buildExpandableSection(
      title: 'Courts',
      subtitle: '${controller.selectedCourts.length} selected',
      isExpanded: controller.showCourts.value,
      onToggle: controller.toggleCourts,
      child: _buildCourtsContent(controller),
    ),
    _buildExpandableSection(
      title: 'Languages',
      subtitle: '${controller.selectedLanguages.length} selected',
      isExpanded: controller.showLanguages.value,
      onToggle: controller.toggleLanguages,
      child: _buildLanguagesContent(controller),
    ),
    _buildExpandableSection(
      title: 'Experience',
      subtitle: controller.selectedExperience.value.isEmpty ? 'Any' : controller.selectedExperience.value,
      isExpanded: controller.showExperience.value,
      onToggle: controller.toggleExperience,
      child: _buildExperienceContent(controller),
    ),
    _buildExpandableSection(
      title: 'Lawyer Type',
      subtitle: '${controller.selectedUserTypes.length} selected',
      isExpanded: controller.showUserTypes.value,
      onToggle: controller.toggleUserTypes,
      child: _buildUserTypeContent(controller),
    ),
    // add more inline filters here as needed...
  ],
)
          ),
        ),
      ),
      // Bottom fade indicator (optional)
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.0),
              Colors.grey.shade100.withOpacity(0.8),
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
    ],
  );
}




  Stream<QuerySnapshot> _buildFilteredQuery(LawyerFilterController filterController) {
    // Create base query for legal professionals
    Query query = FireStoreUtils.firestore
        .collection(Constant.users)
        .where('userType', whereIn: ['individual', 'law_firm']);
    
    return query.snapshots();
  }

  bool _matchesFilters(UserModel user, LawyerFilterController filterController) {
    // Search text filter
    if (filterController.searchText.value.isNotEmpty) {
      String searchLower = filterController.searchText.value.toLowerCase();
      bool matchesSearch = false;
      
      // Check name
      if (user.getDisplayName().toLowerCase().contains(searchLower)) {
        matchesSearch = true;
      }
      
      // Check specializations
      if (user.specializations != null) {
        for (String spec in user.specializations!) {
          if (spec.toLowerCase().contains(searchLower)) {
            matchesSearch = true;
            break;
          }
        }
      }
      
      // Check city
      if (user.city != null && user.city!.toLowerCase().contains(searchLower)) {
        matchesSearch = true;
      }
      
      // Check services
      if (user.services != null) {
        for (String service in user.services!) {
          if (service.toLowerCase().contains(searchLower)) {
            matchesSearch = true;
            break;
          }
        }
      }
      
      if (!matchesSearch) return false;
    }
    
    // Specialization filter
    if (filterController.selectedSpecializations.isNotEmpty) {
      if (user.specializations == null || user.specializations!.isEmpty) {
        return false;
      }
      
      bool hasMatchingSpec = false;
      for (String selectedSpec in filterController.selectedSpecializations) {
        if (user.specializations!.contains(selectedSpec)) {
          hasMatchingSpec = true;
          break;
        }
      }
      if (!hasMatchingSpec) return false;
    }
    
    // Services filter
    if (filterController.selectedServices.isNotEmpty) {
      if (user.services == null || user.services!.isEmpty) {
        return false;
      }
      
      bool hasMatchingService = false;
      for (String selectedService in filterController.selectedServices) {
        if (user.services!.contains(selectedService)) {
          hasMatchingService = true;
          break;
        }
      }
      if (!hasMatchingService) return false;
    }
    
    // City filter
    if (filterController.selectedCities.isNotEmpty) {
      if (user.city == null || !filterController.selectedCities.contains(user.city!)) {
        return false;
      }
    }
    
    // Courts filter
    if (filterController.selectedCourts.isNotEmpty) {
      if (user.courts == null || user.courts!.isEmpty) {
        return false;
      }
      
      bool hasMatchingCourt = false;
      for (String selectedCourt in filterController.selectedCourts) {
        if (user.courts!.contains(selectedCourt)) {
          hasMatchingCourt = true;
          break;
        }
      }
      if (!hasMatchingCourt) return false;
    }
    
    // Languages filter
    if (filterController.selectedLanguages.isNotEmpty) {
      if (user.languages == null || user.languages!.isEmpty) {
        return false;
      }
      
      bool hasMatchingLanguage = false;
      for (String selectedLanguage in filterController.selectedLanguages) {
        if (user.languages!.contains(selectedLanguage)) {
          hasMatchingLanguage = true;
          break;
        }
      }
      if (!hasMatchingLanguage) return false;
    }
    
    // Experience filter
    if (filterController.selectedExperience.value.isNotEmpty) {
      if (user.yearsOfExperience == null) {
        return false;
      }
      
      // Convert experience to number for comparison
      String userExp = user.yearsOfExperience!;
      String selectedExp = filterController.selectedExperience.value;
      
      // Simple matching - in a real app, you'd want more sophisticated matching
      if (!_matchesExperience(userExp, selectedExp)) {
        return false;
      }
    }
    
    // User type filter
    if (filterController.selectedUserTypes.isNotEmpty) {
      if (user.userType == null || !filterController.selectedUserTypes.contains(user.userType!)) {
        return false;
      }
    }
    
    return true;
  }
  
  bool _matchesExperience(String userExp, String selectedExp) {
    // Simple experience matching logic
    // You can make this more sophisticated based on your needs
    try {
      int userYears = int.tryParse(userExp) ?? 0;
      
      switch (selectedExp) {
        case 'Less than 1 year':
          return userYears < 1;
        case '1-3 years':
          return userYears >= 1 && userYears <= 3;
        case '3-5 years':
          return userYears >= 3 && userYears <= 5;
        case '5-10 years':
          return userYears >= 5 && userYears <= 10;
        case '10-15 years':
          return userYears >= 10 && userYears <= 15;
        case '15-20 years':
          return userYears >= 15 && userYears <= 20;
        case '20+ years':
          return userYears >= 20;
        default:
          return true;
      }
    } catch (e) {
      return true; // If we can't parse, include in results
    }
  }

  // New expandable section builder
Widget _buildExpandableSection({
  required String title,
  required String subtitle,
  required bool isExpanded,
  required VoidCallback onToggle,
  required Widget child,
}) {
  return IntrinsicWidth(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header button with close 'X' icon at far right
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.instrumentSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      subtitle,
                      style: GoogleFonts.instrumentSans(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Spacer pushes the X to the right edge
                    const Spacer(),
                    if (isExpanded)
                      GestureDetector(
                        onTap: () {
                          onToggle(); // Collapse on X tap
                        },
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Expandable content
          if (isExpanded)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10,
                ),
                child: child,
              ),
            ),
        ],
      ),
    ),
  );
}



  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: GoogleFonts.instrumentSans(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecializationContent(LawyerFilterController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select legal specializations you want to filter by:',
          style: GoogleFonts.instrumentSans(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.allSpecializations.map((specialization) {
            final isSelected = controller.selectedSpecializations.contains(specialization);
            final serviceCount = LawyerFilterController.specializationServices[specialization]?.length ?? 0;
            return GestureDetector(
              onTap: () => controller.toggleSpecialization(specialization),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade50 : Colors.grey.shade50,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      specialization,
                      style: GoogleFonts.instrumentSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.blue : Colors.black87,
                      ),
                    ),
                    Text(
                      '$serviceCount services',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 10,
                        color: isSelected ? Colors.blue.shade600 : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildServicesContent(LawyerFilterController controller) {
    List<String> availableServices = controller.availableServices;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services for: ${controller.selectedSpecializations.join(", ")}',
          style: GoogleFonts.instrumentSans(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        if (availableServices.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableServices.map((service) {
              final isSelected = controller.selectedServices.contains(service);
              return GestureDetector(
                onTap: () => controller.toggleService(service),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green.shade50 : Colors.grey.shade50,
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    service,
                    style: GoogleFonts.instrumentSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.green.shade700 : Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          )
        else
          Text(
            'No services available for selected specializations',
            style: GoogleFonts.instrumentSans(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }

  Widget _buildLocationContent(LawyerFilterController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search and select cities:',
          style: GoogleFonts.instrumentSans(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        SearchableCityDropdown(
          selectedCity: controller.selectedCity.value,
          onCitySelected: controller.onCitySelected,
          decoration: InputDecoration(
            hintText: 'Search for a city...',
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
              borderSide: const BorderSide(color: Color(0xFF1565C0)),
            ),
            prefixIcon: const Icon(
              Icons.location_on,
              color: Color(0xFF1565C0),
            ),
          ),
        ),
        
        // Display selected cities
        if (controller.selectedCities.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Selected cities:',
            style: GoogleFonts.instrumentSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.selectedCities.map((city) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  border: Border.all(color: Colors.orange.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      city,
                      style: GoogleFonts.instrumentSans(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => controller.toggleCity(city),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildCourtsContent(LawyerFilterController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search and select courts:',
          style: GoogleFonts.instrumentSans(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        SearchableCourtDropdown(
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
              borderSide: const BorderSide(color: Color(0xFF1565C0)),
            ),
            prefixIcon: const Icon(
              Icons.account_balance,
              color: Color(0xFF1565C0),
            ),
          ),
        ),
        
        // Display selected courts
        if (controller.selectedCourts.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Selected courts:',
            style: GoogleFonts.instrumentSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
  spacing: 8,
  runSpacing: 8,
  children: controller.selectedCourts.map((court) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 120), // Set your max width here
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        border: Border.all(color: Colors.indigo.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              court,
              style: GoogleFonts.instrumentSans(
                fontSize: 12,
                color: Colors.indigo.shade700,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,     // Allow up to 2 lines
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => controller.toggleCourt(court),
            child: Icon(
              Icons.close,
              size: 16,
              color: Colors.indigo.shade700,
            ),
          ),
        ],
      ),
    );
  }).toList(),
)

        ],
      ],
    );
  }

  Widget _buildLanguagesContent(LawyerFilterController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select languages:',
          style: GoogleFonts.instrumentSans(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.languages.map((language) {
            final isSelected = controller.selectedLanguages.contains(language);
            return GestureDetector(
              onTap: () => controller.toggleLanguage(language),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.purple.shade50 : Colors.grey.shade50,
                  border: Border.all(
                    color: isSelected ? Colors.purple : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  language,
                  style: GoogleFonts.instrumentSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.purple : Colors.black87,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExperienceContent(LawyerFilterController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select experience level:',
          style: GoogleFonts.instrumentSans(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        ...controller.experienceLevels.map((experience) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: controller.selectedExperience.value == experience 
                  ? Colors.teal.shade50 
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: controller.selectedExperience.value == experience 
                    ? Colors.teal 
                    : Colors.grey.shade300,
              ),
            ),
            child: RadioListTile<String>(
              dense: true,
              title: Text(
                experience,
                style: GoogleFonts.instrumentSans(
                  fontSize: 14,
                  color: controller.selectedExperience.value == experience 
                      ? Colors.teal.shade700 
                      : Colors.black87,
                ),
              ),
              value: experience,
              groupValue: controller.selectedExperience.value,
              activeColor: Colors.teal,
              onChanged: (value) {
                controller.setExperience(value ?? '');
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildUserTypeContent(LawyerFilterController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select lawyer type:',
          style: GoogleFonts.instrumentSans(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        ...controller.userTypes.map((userType) {
          String mappedType = userType == 'Individual Lawyer' ? 'individual' : 'law_firm';
          bool isSelected = controller.selectedUserTypes.contains(mappedType);
          
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.amber.shade50 : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.amber : Colors.grey.shade300,
              ),
            ),
            child: CheckboxListTile(
              dense: true,
              title: Text(
                userType,
                style: GoogleFonts.instrumentSans(
                  fontSize: 14,
                  color: isSelected ? Colors.amber.shade700 : Colors.black87,
                ),
              ),
              value: isSelected,
              activeColor: Colors.amber.shade600,
              onChanged: (value) {
                controller.toggleUserType(userType);
              },
            ),
          );
        }).toList(),
      ],
    );
  }
} 