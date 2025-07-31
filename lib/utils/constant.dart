import 'package:uuid/uuid.dart';

class Constant {
  static const String chat = "chat";
  static const String users = "users";

  static String getUuid() {
    return const Uuid().v4();
  }
} 