import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../controller/chat_controller.dart';
import '../../model/chat_model.dart';
import '../../utils/fire_store_utils.dart';
import '../../utils/constant.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 2,
        title: Obx(() => Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Text(
                controller.receiverUserModel.value.getDisplayName().isNotEmpty 
                    ? controller.receiverUserModel.value.getDisplayName()[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
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
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Legal Professional',
                    style: GoogleFonts.instrumentSans(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
        actions: [
          IconButton(
            onPressed: () {
              _showCallOptions(context, controller);
            },
            icon: const Icon(Icons.call, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              _showMoreOptions(context, controller);
            },
            icon: const Icon(Icons.more_vert, color: Colors.white),
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
          if (!isMe) ...[
            CircleAvatar(
              radius: 12,
              backgroundColor: const Color(0xFF1565C0).withOpacity(0.1),
              child: const Icon(
                Icons.person,
                size: 16,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 280),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF1565C0) : Colors.white,
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
                      color: isMe ? Colors.white : Colors.black87,
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
                          color: isMe ? Colors.white.withOpacity(0.7) : Colors.grey.shade500,
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
          
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 12,
              backgroundColor: const Color(0xFF1565C0),
              child: const Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
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

  void _showCallOptions(BuildContext context, ChatController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFF1565C0).withOpacity(0.1),
                      child: Text(
                        controller.receiverUserModel.value.getDisplayName().isNotEmpty 
                            ? controller.receiverUserModel.value.getDisplayName()[0].toUpperCase()
                            : 'U',
                        style: GoogleFonts.instrumentSans(
                          color: const Color(0xFF1565C0),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.receiverUserModel.value.getDisplayName(),
                            style: GoogleFonts.instrumentSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Legal Professional',
                            style: GoogleFonts.instrumentSans(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Call options
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.call,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                title: Text(
                  'Voice Call',
                  style: GoogleFonts.instrumentSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Start a voice consultation',
                  style: GoogleFonts.instrumentSans(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _initiateCall(context, controller, 'voice');
                },
              ),
              
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.videocam,
                    color: Color(0xFF1565C0),
                    size: 20,
                  ),
                ),
                title: Text(
                  'Video Call',
                  style: GoogleFonts.instrumentSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Start a video consultation',
                  style: GoogleFonts.instrumentSans(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _initiateCall(context, controller, 'video');
                },
              ),
              
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.schedule,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
                title: Text(
                  'Schedule Appointment',
                  style: GoogleFonts.instrumentSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Book a consultation slot',
                  style: GoogleFonts.instrumentSans(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _scheduleAppointment(context, controller);
                },
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showMoreOptions(BuildContext context, ChatController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                title: Text(
                  'View Profile',
                  style: GoogleFonts.instrumentSans(fontSize: 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _viewProfile(context, controller);
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.star_border, color: Colors.orange),
                title: Text(
                  'Rate & Review',
                  style: GoogleFonts.instrumentSans(fontSize: 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _rateAndReview(context, controller);
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.notifications_off, color: Colors.grey),
                title: Text(
                  'Mute Notifications',
                  style: GoogleFonts.instrumentSans(fontSize: 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _muteChat(context, controller);
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.file_download, color: Colors.blue),
                title: Text(
                  'Export Chat',
                  style: GoogleFonts.instrumentSans(fontSize: 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _exportChat(context, controller);
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.share, color: Colors.green),
                title: Text(
                  'Share Contact',
                  style: GoogleFonts.instrumentSans(fontSize: 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _shareContact(context, controller);
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: Text(
                  'Clear Chat History',
                  style: GoogleFonts.instrumentSans(fontSize: 16, color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _clearChatHistory(context, controller);
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: Text(
                  'Block User',
                  style: GoogleFonts.instrumentSans(fontSize: 16, color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(context, controller);
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.report, color: Colors.red),
                title: Text(
                  'Report User',
                  style: GoogleFonts.instrumentSans(fontSize: 16, color: Colors.red),
                ),
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
  }

  void _initiateCall(BuildContext context, ChatController controller, String callType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '${callType == 'voice' ? 'Voice' : 'Video'} Call',
            style: GoogleFonts.instrumentSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                callType == 'voice' ? Icons.call : Icons.videocam,
                size: 48,
                color: const Color(0xFF1565C0),
              ),
              const SizedBox(height: 16),
              Text(
                'Initiating ${callType == 'voice' ? 'voice' : 'video'} call with ${controller.receiverUserModel.value.getDisplayName()}',
                style: GoogleFonts.instrumentSans(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Note: Call functionality requires integration with calling services like Agora, Twilio, or Jitsi Meet.',
                style: GoogleFonts.instrumentSans(
                  fontSize: 12,
                  color: Colors.orange.shade700,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
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
                // TODO: Integrate with calling service
                Get.snackbar(
                  'Call Started',
                  '${callType == 'voice' ? 'Voice' : 'Video'} call initiated with ${controller.receiverUserModel.value.getDisplayName()}',
                  backgroundColor: const Color(0xFF1565C0),
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
              ),
              child: Text(
                'Call',
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

  void _scheduleAppointment(BuildContext context, ChatController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Schedule Appointment',
            style: GoogleFonts.instrumentSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.schedule,
                size: 48,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              Text(
                'Schedule a consultation with ${controller.receiverUserModel.value.getDisplayName()}',
                style: GoogleFonts.instrumentSans(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'You will be redirected to the appointment booking system.',
                style: GoogleFonts.instrumentSans(
                  fontSize: 12,
                  color: Colors.blue.shade700,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Later',
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
                  'Appointment Booking',
                  'Appointment booking feature will be available soon',
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: Text(
                'Book Now',
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

  void _rateAndReview(BuildContext context, ChatController controller) {
    Get.snackbar(
      'Rate & Review',
      'Rating system will be available soon',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    // TODO: Open rating dialog
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

  void _exportChat(BuildContext context, ChatController controller) {
    Get.snackbar(
      'Export Chat',
      'Chat export feature will be available soon',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    // TODO: Implement chat export
  }

  void _shareContact(BuildContext context, ChatController controller) {
    Get.snackbar(
      'Share Contact',
      'Contact sharing feature will be available soon',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    // TODO: Implement contact sharing
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