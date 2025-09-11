import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_colors.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_constants.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_images.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_strings.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/AccountSetUp/phone_number_code_screen.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/button_style_widget.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/phone_number_enter_widget.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumberScreen> {
  String selectedImagePath = AppImages.indiaImg;

  int selectedNumber = 91;
  TextEditingController numberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  final List<MenuItem> items = [
    MenuItem(
      name: AppStrings.afghanistan,
      imagePath: AppImages.afghanistanImg,
      number: 93,
    ),
    MenuItem(
      name: AppStrings.australia,
      imagePath: AppImages.australiaImg,
      number: 61,
    ),
    MenuItem(
      name: AppStrings.bahrain,
      imagePath: AppImages.bahrainImg,
      number: 973,
    ),
    MenuItem(
      name: AppStrings.bangladesh,
      imagePath: AppImages.bangladeshImg,
      number: 880,
    ),
    MenuItem(
      name: AppStrings.brazil,
      imagePath: AppImages.brazilImg,
      number: 55,
    ),
    MenuItem(
      name: AppStrings.canada,
      imagePath: AppImages.canadaImg,
      number: 1,
    ),
    MenuItem(
      name: AppStrings.china,
      imagePath: AppImages.chinaImg,
      number: 86,
    ),
    MenuItem(
      name: AppStrings.cuba,
      imagePath: AppImages.cubaImg,
      number: 53,
    ),
    MenuItem(
      name: AppStrings.india,
      imagePath: AppImages.indiaImg,
      number: 91,
    ),
    MenuItem(
      name: AppStrings.indonesia,
      imagePath: AppImages.indonesiaImg,
      number: 62,
    ),
    MenuItem(
      name: AppStrings.iran,
      imagePath: AppImages.iranImg,
      number: 98,
    ),
    MenuItem(
      name: AppStrings.japan,
      imagePath: AppImages.japanImg,
      number: 81,
    ),
    MenuItem(
      name: AppStrings.myanmar,
      imagePath: AppImages.myanmarImg,
      number: 95,
    ),
    MenuItem(
      name: AppStrings.newZealand,
      imagePath: AppImages.newzealandImg,
      number: 64,
    ),
    MenuItem(
      name: AppStrings.russia,
      imagePath: AppImages.russiaImg,
      number: 7,
    ),
    MenuItem(
      name: AppStrings.sriLanka,
      imagePath: AppImages.srilankaImg,
      number: 94,
    ),
    MenuItem(
      name: AppStrings.uK,
      imagePath: AppImages.ukImg,
      number: 44,
    ),
    MenuItem(
      name: AppStrings.uS,
      imagePath: AppImages.usImg,
      number: 1,
    ),
    MenuItem(
      name: AppStrings.zimbabwe,
      imagePath: AppImages.zimbabweImg,
      number: 263,
    ),
  ];
  @override
  void initState() {
    super.initState();
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
            AppImages.frame2Img,
          ),
          const SizedBox(
            width: 24,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 36, left: 24, right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.enteryourPhone,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 75,
            ),
            PhoneNumberEnterWidget(
              items: items,
              numberController: numberController,
            ),
            const SizedBox(
              height: 84,
            ),
            InkWell(
              onTap: () {
                auth.verifyPhoneNumber(
                    phoneNumber:
                        "+${AppConstants.selectedNumber}${numberController.text}",
                    verificationCompleted: (_) {},
                    verificationFailed: (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    },
                    codeSent: (String verificationId, int? token) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhoneNumberCodeScreen(
                            verificationId: verificationId,
                          ),
                        ),
                      );
                    },
                    codeAutoRetrievalTimeout: (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    });
              },
              child: const ButtonStyleWidget(
                title: AppStrings.sendCode,
                colors: AppColors.blueColors,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  final String name;
  final String imagePath;
  final int number;

  MenuItem({
    required this.name,
    required this.imagePath,
    required this.number,
  });
}
