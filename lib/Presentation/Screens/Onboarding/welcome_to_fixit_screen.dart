import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_images.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_text_style.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/Auth/login_screen.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/button_style_widget.dart';

class WelcomeToFixitScreen extends StatefulWidget {
  const WelcomeToFixitScreen({super.key});

  @override
  State<WelcomeToFixitScreen> createState() => _WelcomeToFixitState();
}

class _WelcomeToFixitState extends State<WelcomeToFixitScreen> {
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _pages = [
    const ItBoxWidget(
      img: AppImages.welcomeToFixItImg,
      title: 'welcome',
      text1: 'discover',
      text2: 'reliability',
      text3: 'serviceNee',
    ),
    const ItBoxWidget(
      img: AppImages.welcomeFindServiceImg,
      title: 'findService',
      text1: 'browse',
      text2: 'services',
      text3: 'appliance',
    ),
    const ItBoxWidget(
      img: AppImages.welcomeTo3Img,
      title: 'findService',
      text1: 'browse',
      text2: 'services',
      text3: 'appliance',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 56),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF004e99),
              Color(0xFF012951),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(_pages.length, (int index) {
                      return Container(
                        width: 10.0,
                        height: 10.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.grey,
                        ),
                      );
                    }).toList(),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'skip'.tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _pages[_currentPage],
            ),
            InkWell(
              onTap: () {
                setState(() {
                  if (_currentPage < 2) {
                    _currentPage++;
                  } else {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  }
                });
              },
              child: ButtonStyleWidget(
                title: 'next'.tr(),
                colors: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItBoxWidget extends StatelessWidget {
  final String img;
  final String title;
  final String text1;
  final String text2;
  final String text3;
  const ItBoxWidget({
    super.key,
    required this.img,
    required this.title,
    required this.text1,
    required this.text2,
    required this.text3,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 595,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: 277,
            child: Image(
              image: AssetImage(img),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            title.tr(),
            style: AppTextStyle.welcomeStyle,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            text1.tr(),
            style: AppTextStyle.welcomeSubStyle,
          ),
          Text(
            text2.tr(),
            style: AppTextStyle.welcomeSubStyle,
          ),
          Text(
            text3.tr(),
            style: AppTextStyle.welcomeSubStyle,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
