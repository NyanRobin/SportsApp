import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'shared/services/firebase_options.dart';
import 'shared/services/service_locator.dart';
import 'core/config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Supabase
  await SupabaseConfig.initialize();
  
  final serviceLocator = ServiceLocator();
  runApp(
    MultiProvider(
      providers: [
        ...serviceLocator.providers,
      ],
      child: App(),
    ),
  );
}
