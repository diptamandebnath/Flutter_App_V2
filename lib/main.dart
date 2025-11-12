import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/Splash/splash_screen.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
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
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('bn'), Locale('hi')],
      path: 'translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      assetLoader: const RootBundleAssetLoader(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fixit',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
