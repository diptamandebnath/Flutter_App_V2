import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/Onboarding/welcome_to_fixit_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('select_language').tr(),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('English'),
            onTap: () {
              context.setLocale(const Locale('en'));
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeToFixitScreen(),
                  ),
                );
              });
            },
          ),
          ListTile(
            title: const Text('Bengali'),
            onTap: () {
              context.setLocale(const Locale('bn'));
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeToFixitScreen(),
                  ),
                );
              });
            },
          ),
          ListTile(
            title: const Text('Hindi'),
            onTap: () {
              context.setLocale(const Locale('hi'));
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeToFixitScreen(),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
