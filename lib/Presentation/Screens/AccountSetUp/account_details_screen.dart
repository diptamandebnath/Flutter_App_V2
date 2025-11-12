import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_colors.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_images.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_text_style.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/AccountSetUp/how_to_case_screen.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/button_style_widget.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/textfromfield_widget.dart';

class AccountDetailScreen extends StatefulWidget {
  const AccountDetailScreen({super.key});

  @override
  State<AccountDetailScreen> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetailScreen> {
  TextEditingController ownerControllerName = TextEditingController();
  TextEditingController nicNumberController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController nicExpiryController = TextEditingController();
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
            AppImages.frame8Img,
          ),
          const SizedBox(
            width: 24,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 36, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'selectPaymentMethod'.tr(),
              style: AppTextStyle.textStyle,
            ),
            const SizedBox(height: 20),
            TextFromFieldWidget(
              controller: ownerControllerName,
              hintText: 'ownerName'.tr(),
              colors: Colors.black,
            ),
            const SizedBox(height: 16),
            TextFromFieldWidget(
              controller: nicNumberController,
              hintText: 'nICNumber'.tr(),
              colors: Colors.black,
            ),
            const SizedBox(height: 16),
            TextFromFieldWidget(
              controller: phonenumberController,
              hintText: 'phoneNumber'.tr(),
              colors: Colors.black,
            ),
            const SizedBox(height: 16),
            Text(
              'nICExpirydate'.tr(),
              style: AppTextStyle.textStyle
                  .copyWith(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            TextFromFieldWidget(
              controller: nicExpiryController,
              hintText: 'dateFormat'.tr(),
              colors: Colors.black,
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HowToCaseScreen()),
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
    );
  }
}
