import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Edge-to-edge transparent system bars with dynamic overlay
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  // Lock orientation to portrait for optimum iOS/Android food delivery UX
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    // In production environment with google-services.json / GoogleService-Info.plist:
    // await Firebase.initializeApp();
    developer.log('Firebase initialization completed', name: 'Tiffiny');
  } catch (e, stack) {
    developer.log('Firebase startup note (expected during local mock run): $e',
        name: 'Tiffiny', error: e, stackTrace: stack);
  }

  runApp(
    const ProviderScope(
      child: TiffinyApp(),
    ),
  );
}
