import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/user_model.dart';

class ProfileAvatar extends StatelessWidget {
  final UserModel user;
  final double radius;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final bool showBorder;
  final Color borderColor;
  final double borderWidth;

  const ProfileAvatar({
    super.key,
    required this.user,
    this.radius = 24,
    this.backgroundColor = const Color(0xFF51D5FF),
    this.textColor = const Color(0xFF1565C0),
    this.fontSize = 18,
    this.showBorder = false,
    this.borderColor = const Color(0xFF1565C0),
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    // Check if user has a profile picture
    final bool hasProfilePic = user.profilePic != null && user.profilePic!.isNotEmpty;
    
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder 
            ? Border.all(color: borderColor.withOpacity(0.3), width: borderWidth)
            : null,
      ),
      child: hasProfilePic
          ? _buildProfileImage()
          : _buildInitialsAvatar(),
    );
  }

  Widget _buildProfileImage() {
    final String imageUrl = user.profilePic!;
    final bool isNetworkImage = imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    final bool isFileImage = imageUrl.startsWith('file://') || imageUrl.startsWith('/');
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: _buildImageWidget(imageUrl, isNetworkImage, isFileImage),
    );
  }

  Widget _buildImageWidget(String imageUrl, bool isNetworkImage, bool isFileImage) {
    if (isNetworkImage) {
      return Image.network(
        imageUrl,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingAvatar();
        },
        errorBuilder: (context, error, stackTrace) => _buildInitialsAvatar(),
      );
    } else if (isFileImage) {
      // Handle local file paths
      String filePath = imageUrl;
      if (filePath.startsWith('file://')) {
        filePath = filePath.substring(7); // Remove 'file://' prefix
      }
      
      return Image.file(
        File(filePath),
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildInitialsAvatar(),
      );
    } else {
      return _buildInitialsAvatar();
    }
  }

  Widget _buildLoadingAvatar() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor.withOpacity(0.1),
      child: SizedBox(
        width: radius * 0.6,
        height: radius * 0.6,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor.withOpacity(0.5)),
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor.withOpacity(0.1),
      child: Text(
        user.getDisplayName().isNotEmpty 
            ? user.getDisplayName()[0].toUpperCase()
            : 'U',
        style: GoogleFonts.instrumentSans(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }
}