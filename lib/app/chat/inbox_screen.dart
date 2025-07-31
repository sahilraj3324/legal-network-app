import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/inbox_model.dart';
import '../Profile/profile_screen.dart';
import '../../model/user_model.dart';
import '../../utils/fire_store_utils.dart';
import '../../utils/constant.dart';
import 'chat_screen.dart';
import '../Find_lawyers/find_lawyers_screen.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});
  

  @override
 Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50.withOpacity(0.3),
              Colors.white,
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        child: Column(
          children: [
            // ================= CUSTOM APP BAR =================
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                bottom: 16,
              ),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Row 1: Logo + Notification + Profile =====
                  Row(
                    children: [
                      // Logo + App Name
                      Flexible(
                        flex: 4,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/Logo.png',
                              height: screenWidth * 0.17,
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Notification Icon with Badge
                      Flexible(
                        flex: 2,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Get.to(() => const FindLawyersScreen());
                                },
                                icon: Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.grey.shade700,
                                  size: screenWidth * 0.05,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '2',
                                  style: GoogleFonts.instrumentSans(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.025,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Profile Image
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const ProfileScreen());
                        },
                        child: Container(
                          width: screenWidth * 0.1,
                          height: screenWidth * 0.1,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1565C0).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: const Color(0xFF1565C0).withOpacity(0.2),
                              width: 2,
                            ),
                            image: const DecorationImage(
                              image: AssetImage('assets/profile.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenWidth * 0.04),

                  // ===== Row 2: Search Bar + New Group =====
                  Row(
                    children: [
                      // Search Bar
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search Messages, People & More...',
                              hintStyle: GoogleFonts.instrumentSans(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              icon: Icon(Icons.search,
                                  color: Colors.grey.shade600),
                            ),
                          ),
                        ),
                      ),
                      // New Group Button
                    
                    ],
                  ),

                  SizedBox(height: screenWidth * 0.05),

                  // ===== Row 3: Title + Action Buttons =====
                  SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      Text(
        'Chats',
        style: GoogleFonts.instrumentSans(
          color: const Color.fromARGB(221, 54, 54, 54),
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(width: 12),

      // Upgrade To Pro Button
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: 12),
        ),
        onPressed: () {},
        child: Text(
          'Upgrade To Pro ⚡',
          style: GoogleFonts.instrumentSans(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(width: 8),

      // Find Profiles Button
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: 12),
        ),
        onPressed: () {
          Get.to(() => const FindLawyersScreen());
        },
        child: Text(
          'Find Profiles +',
          style: GoogleFonts.instrumentSans(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(width: 8),

      // Optional: Add more buttons if needed
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: 12),
        ),
        onPressed: () {},
        child: Text(
          'New Group +',
          style: GoogleFonts.instrumentSans(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  ),
)
                ],
              ),
            ),

            // ================= BODY CONTENT =================
            Expanded(
              child: _buildMessagesContent(),
            ),
          ],
        ),
      ),
    );
  }

  // Action Buttons Builder
  Widget _buildActionButton(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.instrumentSans(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  // Example Messages Content
 

     Widget _buildMessagesContent() {
     return Container(
       margin: const EdgeInsets.only(top: 8),
       child: StreamBuilder<QuerySnapshot>(
         stream: FireStoreUtils.firestore
             .collection(Constant.chat)
             .doc(FireStoreUtils.getCurrentUid())
             .collection('inbox')
             .orderBy('timestamp', descending: true)
             .snapshots(),
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
                      'Error loading conversations',
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
                      Icons.chat_bubble_outline,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No conversations yet',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 20,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start connecting with legal professionals',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.to(() => const FindLawyersScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      icon: const Icon(Icons.search, size: 18),
                      label: Text(
                        'Find Lawyers',
                        style: GoogleFonts.instrumentSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            List<InboxModel> inboxList = snapshot.data!.docs.map((doc) {
              return InboxModel.fromJson(doc.data() as Map<String, dynamic>);
            }).toList();

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: inboxList.length,
              itemBuilder: (context, index) {
                InboxModel inbox = inboxList[index];
                return _buildInboxTile(inbox);
              },
            );
          },
        ),
      );
  }

  Widget _buildInboxTile(InboxModel inbox) {
    String otherUserId = inbox.senderId == FireStoreUtils.getCurrentUid() 
        ? inbox.receiverId ?? '' 
        : inbox.senderId ?? '';
    
    return FutureBuilder<UserModel?>(
      future: _getUserById(otherUserId),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const SizedBox.shrink();
        }

        UserModel otherUser = userSnapshot.data!;
        bool isUnread = inbox.seen == false && inbox.senderId != FireStoreUtils.getCurrentUid();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            onTap: () {
              Get.to(() => const ChatScreen(), arguments: {
                'receiverModel': otherUser,
              });
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFF51D5FF).withOpacity(0.1),
                  child: Text(
                    otherUser.getDisplayName().isNotEmpty 
                        ? otherUser.getDisplayName()[0].toUpperCase()
                        : 'U',
                    style: GoogleFonts.instrumentSans(
                      color: const Color(0xFF1565C0),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (isUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFF51D5FF),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(
              otherUser.getDisplayName(),
              style: GoogleFonts.instrumentSans(
                fontSize: 16,
                fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (otherUser.specializations != null && otherUser.specializations!.isNotEmpty)
                  Text(
                    otherUser.specializations!.first,
                    style: GoogleFonts.instrumentSans(
                      fontSize: 12,
                      color: const Color(0xFF51D5FF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  inbox.lastMessage ?? '',
                  style: GoogleFonts.instrumentSans(
                    fontSize: 14,
                    color: isUnread ? Colors.black87 : Colors.grey.shade600,
                    fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(inbox.timestamp),
                  style: GoogleFonts.instrumentSans(
                    fontSize: 12,
                    color: isUnread ? const Color(0xFF51D5FF) : Colors.grey.shade500,
                    fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                if (isUnread) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF51D5FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'New',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<UserModel?> _getUserById(String userId) async {
    try {
      DocumentSnapshot userDoc = await FireStoreUtils.firestore
          .collection(Constant.users)
          .doc(userId)
          .get();
      
      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user by ID: $e');
      return null;
    }
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);
    
    if (difference.inDays == 0) {
      // Today - show time
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      // This week - show day name
      List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dateTime.weekday - 1];
    } else {
      // Older - show date
      return '${dateTime.day}/${dateTime.month}/${dateTime.year.toString().substring(2)}';
    }
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: Color(0xFF1565C0),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Search Conversations',
                          style: GoogleFonts.instrumentSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, color: Colors.grey),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Search field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search by lawyer name, specialization...',
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
                    
                    const SizedBox(height: 24),
                    
                    // Quick search options
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Search:',
                          style: GoogleFonts.instrumentSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                      ],
                    ),
                    
                    // Search button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: searchQuery.isEmpty ? null : () {
                          Navigator.of(context).pop();
                          _performSearch(searchQuery);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          'Search',
                          style: GoogleFonts.instrumentSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuickSearchChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1565C0).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1565C0).withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: GoogleFonts.instrumentSans(
            fontSize: 12,
            color: const Color(0xFF1565C0),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Search functionality methods
  void _performSearch(String query) {
    Get.snackbar(
      'Search',
      'Searching for "$query" in conversations...',
      backgroundColor: const Color(0xFF1565C0),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    // TODO: Implement full text search functionality
  }
  
  Widget _buildNotificationTile(String title, String subtitle, IconData icon, Color color, bool isUnread) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? color.withOpacity(0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnread ? color.withOpacity(0.1) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.instrumentSans(
                          fontSize: 14,
                          fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.instrumentSans(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  

} 