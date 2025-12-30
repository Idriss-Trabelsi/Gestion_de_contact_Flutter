import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'services/user_storage.dart';
import 'services/contact_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize storage services
  await UserHive.init();
  await ContactHive.init();
  
  runApp(const MyApp());
}