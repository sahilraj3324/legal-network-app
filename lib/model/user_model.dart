import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? email;
  String? loginType;
  String? profilePic;
  String? fcmToken;
  String? countryCode;
  String? phoneNumber;
  String? walletAmount;
  bool? isActive;
  bool? isVerify;
  TravelPreferenceModel? travelPreference;
  Timestamp? createdAt;
  String? reviewCount;
  String? reviewSum;
  String? bio;
  
  // New legal professional fields
  String? userType; // "individual" or "law_firm"
  String? fullName; // Name with "Adv." prefix
  List<String>? specializations; // Multiple specializations
  List<String>? services; // Services offered
  List<String>? courts; // Courts they practice in
  String? city;
  String? completeAddress;
  bool? isAddressPublic; // true for public, false for private
  String? yearsOfExperience;
  String? language; // "hindi" or "english"

  UserModel({
    this.id,
    this.email,
    this.loginType,
    this.profilePic,
    this.fcmToken,
    this.countryCode,
    this.phoneNumber,
    this.walletAmount,
    this.isActive,
    this.isVerify,
    this.travelPreference,
    this.createdAt,
    this.reviewCount,
    this.reviewSum,
    this.bio,
    this.userType,
    this.fullName,
    this.specializations,
    this.services,
    this.courts,
    this.city,
    this.completeAddress,
    this.isAddressPublic,
    this.yearsOfExperience,
    this.language,
  });

  String getDisplayName() {
    return fullName ?? 'User';
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    loginType = json['loginType'];
    profilePic = json['profilePic'];
    fcmToken = json['fcmToken'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    walletAmount = json['walletAmount'] ?? "0.0";
    createdAt = json['createdAt'];
    isActive = json['isActive'];
    isVerify = json['isVerify'];
    bio = json['bio'] ?? '';
    travelPreference = json['travelPreference'] != null ? TravelPreferenceModel.fromJson(json['travelPreference']) : null;
    reviewSum = json['reviewSum'] ?? '0.0';
    reviewCount = json['reviewCount'] ?? '0.0';
    
    // New legal professional fields
    userType = json['userType'];
    fullName = json['fullName'];
    specializations = json['specializations'] != null ? List<String>.from(json['specializations']) : null;
    services = json['services'] != null ? List<String>.from(json['services']) : null;
    courts = json['courts'] != null ? List<String>.from(json['courts']) : null;
    city = json['city'];
    completeAddress = json['completeAddress'];
    isAddressPublic = json['isAddressPublic'];
    yearsOfExperience = json['yearsOfExperience'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    if (travelPreference != null) {
      data['travelPreference'] = travelPreference!.toJson();
    }
    data['loginType'] = loginType;
    data['profilePic'] = profilePic;
    data['fcmToken'] = fcmToken;
    data['countryCode'] = countryCode;
    data['phoneNumber'] = phoneNumber;
    data['walletAmount'] = walletAmount;
    data['createdAt'] = createdAt;
    data['isActive'] = isActive;
    data['isVerify'] = isVerify;
    data['bio'] = bio;
    data['reviewSum'] = reviewSum;
    data['reviewCount'] = reviewCount;
    
    // New legal professional fields
    data['userType'] = userType;
    data['fullName'] = fullName;
    data['specializations'] = specializations;
    data['services'] = services;
    data['courts'] = courts;
    data['city'] = city;
    data['completeAddress'] = completeAddress;
    data['isAddressPublic'] = isAddressPublic;
    data['yearsOfExperience'] = yearsOfExperience;
    data['language'] = language;
    
    return data;
  }
}

class TravelPreferenceModel {
  String? chattiness;
  String? smoking;
  String? music;
  String? pets;

  TravelPreferenceModel({this.chattiness, this.smoking, this.music, this.pets});

  TravelPreferenceModel.fromJson(Map<String, dynamic> json) {
    chattiness = json['chattiness'];
    smoking = json['smoking'];
    music = json['music'];
    pets = json['pets'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chattiness'] = chattiness;
    data['smoking'] = smoking;
    data['music'] = music;
    data['pets'] = pets;
    return data;
  }
} 