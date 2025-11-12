import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_colors.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_images.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_text_style.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/bottom_navigation_bar_widget.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/button_style_widget.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/pricing_option_widget.dart';

class HowToCaseScreen extends StatefulWidget {
  const HowToCaseScreen({super.key});

  @override
  State<HowToCaseScreen> createState() => _HowToCaseState();
}

class _HowToCaseState extends State<HowToCaseScreen> {
  String _selectedPricingMethod = 'hourlyfee';
  final TextEditingController _hourlyFeeController = TextEditingController();
  final TextEditingController _flatFeeController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();

  Future navigateToAnotherScreen() {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const BottomNavigationBarWidget(),
      ),
    );
  }

  Future _showConfirmationDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.blueColors,
              size: 50,
            ),
            const SizedBox(height: 20),
            Text(
              'appReceived'.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'yourApp'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                navigateToAnotherScreen();
              },
              child: ButtonStyleWidget(
                title: 'home'.tr(),
                colors: AppColors.blueColors,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hourlyFeeController.dispose();
    _flatFeeController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

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
            AppImages.frame9Img,
          ),
          const SizedBox(
            width: 24,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 36, left: 24, right: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'pricingAndrate'.tr(),
                style: AppTextStyle.textStyle,
              ),
              const SizedBox(height: 20),
              Text(
                'howdoYoucost'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              PricingOptionWidget(
                title: 'hourlyfee'.tr(),
                imageUrl: AppImages.hourlyfeeImg,
                isSelected: _selectedPricingMethod == 'hourlyfee',
                controller: _hourlyFeeController,
                unit: '/h',
                onTap: () {
                  setState(() {
                    _selectedPricingMethod = 'hourlyfee';
                  });
                },
              ),
              PricingOptionWidget(
                title: 'flatfee'.tr(),
                imageUrl: AppImages.flatfeeImg,
                isSelected: _selectedPricingMethod == 'flatfee',
                controller: _flatFeeController,
                unit: '',
                onTap: () {
                  setState(() {
                    _selectedPricingMethod = 'flatfee';
                  });
                },
              ),
              const SizedBox(height: 20),
              Text(
                'moreinformation'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _additionalInfoController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'writeHere'.tr(),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: _showConfirmationDialog,
                child: ButtonStyleWidget(
                  title: 'submit'.tr(),
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
