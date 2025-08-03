import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../controller/chat_controller.dart';
import '../../model/chat_model.dart';
import '../../utils/fire_store_utils.dart';
import '../../utils/constant.dart';
import '../../widgets/profile_avatar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF51D5FF),
        
        elevation: 2,
        title: Obx(() => Row(
          children: [
            Obx(() => ProfileAvatar(
              user: controller.receiverUserModel.value,
              radius: 16,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 14,
            )),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.receiverUserModel.value.getDisplayName(),
                    style: GoogleFonts.instrumentSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                ],
              ),
            ),
          ],
        )),
        actions: [
          
          IconButton(
            onPressed: () {
              _showMoreOptions(context, controller);
            },
            icon: const Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1565C0)),
              ),
            )
          : Column(
              children: [
                // Messages list
                Expanded(
                  child: Container(
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
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FireStoreUtils.firestore
                          .collection(Constant.chat)
                          .doc(controller.senderUserModel.value.id.toString())
                          .collection(controller.receiverUserModel.value.id.toString())
                          .orderBy('timestamp', descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error loading messages',
                              style: GoogleFonts.instrumentSans(
                                color: Colors.red,
                                fontSize: 16,
                              ),
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
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Start a conversation',
                                  style: GoogleFonts.instrumentSans(
                                    fontSize: 18,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Send a message to begin chatting',
                                  style: GoogleFonts.instrumentSans(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        List<ChatModel> chatList = snapshot.data!.docs.map((doc) {
                          return ChatModel.fromJson(doc.data() as Map<String, dynamic>);
                        }).toList();

                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: chatList.length,
                          itemBuilder: (context, index) {
                            ChatModel chat = chatList[index];
                            bool isMe = chat.senderId == controller.senderUserModel.value.id;
                            
                            return _buildMessageBubble(chat, isMe);
                          },
                        );
                      },
                    ),
                  ),
                ),
                
                // Message input
                _buildMessageInput(controller),
              ],
            ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatModel chat, bool isMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
        
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 280),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFFE5FFEA) : Color(0xFFE4F9FF),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.message ?? '',
                    style: GoogleFonts.instrumentSans(
                      fontSize: 15,
                      color: isMe ? Colors.black : Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(chat.timestamp),
                        style: GoogleFonts.instrumentSans(
                          fontSize: 11,
                          color: isMe ? Colors.black.withOpacity(0.7) : Colors.grey.shade500,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          chat.seen == true ? Icons.done_all : Icons.done,
                          size: 14,
                          color: chat.seen == true ? Colors.blue.shade200 : Colors.white.withOpacity(0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(ChatController controller) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: controller.messageTextEditorController.value,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: GoogleFonts.instrumentSans(
                            color: Colors.grey.shade500,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.instrumentSans(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Add attachment functionality
                      },
                      icon: Icon(
                        Icons.attach_file,
                        color: Colors.grey.shade500,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1565C0),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  String message = controller.messageTextEditorController.value.text.trim();
                  if (message.isNotEmpty) {
                    controller.sendMessage(message);
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    
    if (dateTime.day == now.day && 
        dateTime.month == now.month && 
        dateTime.year == now.year) {
      // Today - show time only
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      // Other days - show date
      return '${dateTime.day}/${dateTime.month}';
    }
  }

void _showMoreOptions(BuildContext context, ChatController controller) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow full-screen scrolling
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,  // 60% of screen height initially
        maxChildSize: 0.9,      // Expand up to 90%
        minChildSize: 0.4,      // Minimum 40%
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ListView(
              controller: scrollController,
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'More Options',
                    style: GoogleFonts.instrumentSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // Options
                ListTile(
                  leading: const Icon(Icons.person, color: Color(0xFF1565C0)),
                  title: Text('View Profile',
                      style: GoogleFonts.instrumentSans(fontSize: 16)),
                  onTap: () {
                    Navigator.pop(context);
                    _viewProfile(context, controller);
                  },
                ),
                
                ListTile(
                  leading: const Icon(Icons.notifications_off, color: Colors.grey),
                  title: Text('Mute Notifications',
                      style: GoogleFonts.instrumentSans(fontSize: 16)),
                  onTap: () {
                    Navigator.pop(context);
                    _muteChat(context, controller);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: Text('Clear Chat History',
                      style: GoogleFonts.instrumentSans(
                          fontSize: 16, color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _clearChatHistory(context, controller);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.block, color: Colors.red),
                  title: Text('Block User',
                      style: GoogleFonts.instrumentSans(
                          fontSize: 16, color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _blockUser(context, controller);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.report, color: Colors.red),
                  title: Text('Report User',
                      style: GoogleFonts.instrumentSans(
                          fontSize: 16, color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _reportUser(context, controller);
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    },
  );
}

  void _viewProfile(BuildContext context, ChatController controller) {
    Get.snackbar(
      'Profile View',
      'Viewing ${controller.receiverUserModel.value.getDisplayName()}\'s profile',
      backgroundColor: const Color(0xFF1565C0),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    // TODO: Navigate to profile screen
  }

  void _muteChat(BuildContext context, ChatController controller) {
    Get.snackbar(
      'Chat Muted',
      'Notifications muted for this conversation',
      backgroundColor: Colors.grey.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    // TODO: Implement mute functionality
  }


  void _clearChatHistory(BuildContext context, ChatController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Clear Chat History',
            style: GoogleFonts.instrumentSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to clear all messages in this conversation? This action cannot be undone.',
            style: GoogleFonts.instrumentSans(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.instrumentSans(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.snackbar(
                  'Chat Cleared',
                  'Chat history clearing feature will be available soon',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
                // TODO: Implement clear chat history
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'Clear',
                style: GoogleFonts.instrumentSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _blockUser(BuildContext context, ChatController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Block User',
            style: GoogleFonts.instrumentSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to block ${controller.receiverUserModel.value.getDisplayName()}? They will no longer be able to send you messages.',
            style: GoogleFonts.instrumentSans(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.instrumentSans(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.snackbar(
                  'User Blocked',
                  '${controller.receiverUserModel.value.getDisplayName()} has been blocked',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
                // TODO: Implement block functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'Block',
                style: GoogleFonts.instrumentSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _reportUser(BuildContext context, ChatController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Report User',
            style: GoogleFonts.instrumentSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Report ${controller.receiverUserModel.value.getDisplayName()} for inappropriate behavior:',
                style: GoogleFonts.instrumentSans(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '• Harassment or abuse\n• Spam or scam\n• Inappropriate content\n• Professional misconduct\n• Other violations',
                style: GoogleFonts.instrumentSans(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.instrumentSans(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.snackbar(
                  'Report Submitted',
                  'Your report has been submitted for review',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
                // TODO: Implement report functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'Report',
                style: GoogleFonts.instrumentSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
} 