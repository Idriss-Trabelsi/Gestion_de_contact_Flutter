import 'package:hive/hive.dart';
import '../models/user.dart';

class UserHive {
  static const String boxName = "usersBox";

  static Future<void> init() async {
    Hive.registerAdapter(UserAdapter());
    await Hive.openBox<User>(boxName);
  }

  static Future<void> saveUser(User user) async {
    final box = Hive.box<User>(boxName);
    await box.put(user.username, user);
  }

  static User? getUser(String username) {
    final box = Hive.box<User>(boxName);
    return box.get(username);
  }

  static bool login(String username, String password) {
    final user = getUser(username);
    return user != null && user.password == password;
  }
}