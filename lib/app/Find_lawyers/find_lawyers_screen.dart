import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/user_model.dart';
import '../../utils/fire_store_utils.dart';
import '../../utils/constant.dart';
import '../../controller/lawyer_filter_controller.dart';
import '../chat/chat_screen.dart';

class FindLawyersScreen extends StatelessWidget {
  const FindLawyersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final filterController = Get.put(LawyerFilterController());
    
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
          Obx(() => Stack(
            children: [
              IconButton(
                onPressed: () {
                  _showFilterDialog(context, filterController);
                },
                icon: const Icon(Icons.filter_list, color: Colors.black),
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
          )),
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
            
            // Lawyers list
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
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
                      .where((user) => user.id != FireStoreUtils.getCurrentUid()) // Exclude current user
                      .where((user) => _matchesFilters(user, filterController))
                      .toList();

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: lawyers.length,
                    itemBuilder: (context, index) {
                      UserModel lawyer = lawyers[index];
                      return _buildLawyerCard(lawyer, context);
                    },
                  );
                },
              ),
            ),
          ],
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

  void _showFilterDialog(BuildContext context, LawyerFilterController filterController) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1565C0),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Filter Lawyers',
                        style: GoogleFonts.instrumentSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Obx(() => filterController.hasActiveFilters
                          ? TextButton(
                              onPressed: () {
                                filterController.clearAllFilters();
                              },
                              child: Text(
                                'Clear All',
                                style: GoogleFonts.instrumentSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : const SizedBox.shrink()),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                
                // Filter content
                Expanded(
                  child: DefaultTabController(
                    length: 7,
                    child: Column(
                      children: [
                        // Tab bar
                        Container(
                          color: Colors.grey.shade100,
                          child: TabBar(
                            isScrollable: true,
                            labelColor: const Color(0xFF1565C0),
                            unselectedLabelColor: Colors.grey.shade600,
                            indicatorColor: const Color(0xFF1565C0),
                            labelStyle: GoogleFonts.instrumentSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            tabs: const [
                              Tab(text: 'Specialization'),
                              Tab(text: 'Services'),
                              Tab(text: 'Location'),
                              Tab(text: 'Courts'),
                              Tab(text: 'Experience'),
                              Tab(text: 'Languages'),
                              Tab(text: 'Type'),
                            ],
                          ),
                        ),
                        
                        // Tab content
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildSpecializationTab(filterController),
                              _buildServicesTab(filterController),
                              _buildLocationTab(filterController),
                              _buildCourtsTab(filterController),
                              _buildExperienceTab(filterController),
                              _buildLanguagesTab(filterController),
                              _buildTypeTab(filterController),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Apply button
                Container(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Obx(() => Text(
                        filterController.hasActiveFilters 
                            ? 'Apply Filters (${filterController.activeFilterCount})'
                            : 'Apply Filters',
                        style: GoogleFonts.instrumentSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpecializationTab(LawyerFilterController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Legal Specializations',
            style: GoogleFonts.instrumentSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: controller.allSpecializations.length,
              itemBuilder: (context, index) {
                String specialization = controller.allSpecializations[index];
                
                return Obx(() {
                  bool isSelected = controller.selectedSpecializations.contains(specialization);
                  
                  return CheckboxListTile(
                    title: Text(
                      specialization,
                      style: GoogleFonts.instrumentSans(fontSize: 14),
                    ),
                    value: isSelected,
                    activeColor: const Color(0xFF1565C0),
                    onChanged: (value) {
                      controller.toggleSpecialization(specialization);
                    },
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesTab(LawyerFilterController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Legal Services',
            style: GoogleFonts.instrumentSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: controller.allServices.length,
              itemBuilder: (context, index) {
                String service = controller.allServices[index];
                
                return Obx(() {
                  bool isSelected = controller.selectedServices.contains(service);
                  
                  return CheckboxListTile(
                    title: Text(
                      service,
                      style: GoogleFonts.instrumentSans(fontSize: 14),
                    ),
                    value: isSelected,
                    activeColor: const Color(0xFF1565C0),
                    onChanged: (value) {
                      controller.toggleService(service);
                    },
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTab(LawyerFilterController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Cities/Locations',
            style: GoogleFonts.instrumentSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.majorCities.length,
              itemBuilder: (context, index) {
                String city = controller.majorCities[index];
                bool isSelected = controller.selectedCities.contains(city);
                
                return CheckboxListTile(
                  title: Text(
                    city,
                    style: GoogleFonts.instrumentSans(fontSize: 14),
                  ),
                  value: isSelected,
                  activeColor: const Color(0xFF1565C0),
                  onChanged: (value) {
                    controller.toggleCity(city);
                  },
                );
              },
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildCourtsTab(LawyerFilterController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Courts/Tribunals',
            style: GoogleFonts.instrumentSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.courtTypes.length,
              itemBuilder: (context, index) {
                String court = controller.courtTypes[index];
                bool isSelected = controller.selectedCourts.contains(court);
                
                return CheckboxListTile(
                  title: Text(
                    court,
                    style: GoogleFonts.instrumentSans(fontSize: 14),
                  ),
                  value: isSelected,
                  activeColor: const Color(0xFF1565C0),
                  onChanged: (value) {
                    controller.toggleCourt(court);
                  },
                );
              },
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceTab(LawyerFilterController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Years of Experience',
            style: GoogleFonts.instrumentSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.experienceLevels.length,
              itemBuilder: (context, index) {
                String experience = controller.experienceLevels[index];
                bool isSelected = controller.selectedExperience.value == experience;
                
                return RadioListTile<String>(
                  title: Text(
                    experience,
                    style: GoogleFonts.instrumentSans(fontSize: 14),
                  ),
                  value: experience,
                  groupValue: controller.selectedExperience.value,
                  activeColor: const Color(0xFF1565C0),
                  onChanged: (value) {
                    controller.setExperience(value ?? '');
                  },
                );
              },
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagesTab(LawyerFilterController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Languages Spoken',
            style: GoogleFonts.instrumentSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.languages.length,
              itemBuilder: (context, index) {
                String language = controller.languages[index];
                bool isSelected = controller.selectedLanguages.contains(language);
                
                return CheckboxListTile(
                  title: Text(
                    language,
                    style: GoogleFonts.instrumentSans(fontSize: 14),
                  ),
                  value: isSelected,
                  activeColor: const Color(0xFF1565C0),
                  onChanged: (value) {
                    controller.toggleLanguage(language);
                  },
                );
              },
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeTab(LawyerFilterController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lawyer Type',
            style: GoogleFonts.instrumentSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.userTypes.length,
              itemBuilder: (context, index) {
                String userType = controller.userTypes[index];
                String mappedType = userType == 'Individual Lawyer' ? 'individual' : 'law_firm';
                bool isSelected = controller.selectedUserTypes.contains(mappedType);
                
                return CheckboxListTile(
                  title: Text(
                    userType,
                    style: GoogleFonts.instrumentSans(fontSize: 14),
                  ),
                  value: isSelected,
                  activeColor: const Color(0xFF1565C0),
                  onChanged: (value) {
                    controller.toggleUserType(userType);
                  },
                );
              },
            )),
          ),
        ],
      ),
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
} 