import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_strings.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/Splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCxD2jQiarnYvRIjin6N2VhNSdibYH5wHc",
      authDomain: "flutterdatabase-f9224.firebaseapp.com",
      projectId: "flutterdatabase-f9224",
      storageBucket: "flutterdatabase-f9224.firebasestorage.app",
      messagingSenderId: "246236075627",
      appId: "1:246236075627:web:52d5d4ea9611f337f0432e",
      measurementId: "G-S52CFK8RVX",
    ),
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
