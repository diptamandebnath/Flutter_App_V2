import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_colors.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_images.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_text_style.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/AccountSetUp/service_working_hours_screen.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/button_style_widget.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/dropdown_menu_box_widget.dart';

class AboutServiceScreen extends StatefulWidget {
  const AboutServiceScreen({super.key});

  @override
  State<AboutServiceScreen> createState() => _AboutServiceState();
}

class _AboutServiceState extends State<AboutServiceScreen> {
  List<String> services = [
    'acService',
    'carService',
    'busService',
    'plumberService',
    'electricianService',
    'cleaningService',
    'carpenterService',
    'gardeningService',
    'pestControlService',
    'paintingService'
  ];
  List<String> experience = [
    'noExp',
    'lessExp',
    'oneyearExp',
    'twoExp',
    'threeExp',
    'fourExp',
    'fievExp',
    'tenExp',
  ];
  List<String> area = [
    'bhat',
    'hansol',
    'maninagar',
    'naroda',
    'navrangpura',
    'nikol',
    'vasna',
    'vastral',
    'vastrapur',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Image.asset(
            AppImages.logofixitImg,
          ),
        ),
        actions: [
          Image.asset(
            AppImages.frame5Img,
          ),
          const SizedBox(
            width: 24,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 36, left: 24, right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'selectaService'.tr(),
                style: AppTextStyle.textStyle,
              ),
              const SizedBox(
                height: 30,
              ),
              DropdownMenuBoxWidget(
                itemList: services,
                hintText: 'selectaService'.tr(),
              ),
              const SizedBox(
                height: 16,
              ),
              DropdownMenuBoxWidget(
                itemList: experience,
                hintText: 'selectYourExperience'.tr(),
              ),
              const SizedBox(
                height: 16,
              ),
              DropdownMenuBoxWidget(
                itemList: area,
                hintText: 'selectServiceArea'.tr(),
              ),
              const SizedBox(
                height: 126,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServiceWorkingHoursScreen(),
                    ),
                  );
                },
                child: ButtonStyleWidget(
                  title: 'next'.tr(),
                  colors: AppColors.blueColors,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
