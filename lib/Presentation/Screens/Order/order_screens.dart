import 'package:flutter/material.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_colors.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_images.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_strings.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_text_style.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/paid_box_style_widget.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/schedule_widget.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/text_container_widget.dart';
import 'mock_payment_screen.dart';

class OrderScreens extends StatefulWidget {
  const OrderScreens({super.key});

  @override
  State<OrderScreens> createState() => _OrderScreensState();
}

class _OrderScreensState extends State<OrderScreens> {
  bool unpaid = true;
  bool paid = false;
  bool schedule = false;

  Widget orderBody() {
    if (unpaid) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.youHave, style: AppTextStyle.textStyle),
          const SizedBox(height: 8),
          const PaidBoxStyleWidget(
            pay: true,
            icons: AppImages.plumbericonImg,
            title: AppStrings.plumbing,
            amount: 200.00,
            date: 'May 28, 2024',
            name: 'Janavi',
          ),
        ],
      );
    } else if (paid) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.paidServices, style: AppTextStyle.textStyle),
          const SizedBox(height: 7),
          const PaidBoxStyleWidget(
            pay: false,
            icons: AppImages.plumbericonImg,
            title: AppStrings.plumbing,
            amount: 300.00,
            date: 'May 25, 2024',
            name: 'Janavi',
          ),
          const PaidBoxStyleWidget(
            pay: false,
            icons: AppImages.paintericonImg,
            title: AppStrings.painter,
            amount: 500.00,
            date: 'May 24, 2024',
            name: 'Varun',
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.upcoming, style: AppTextStyle.textStyle),
          const SizedBox(height: 7),
          const ScheduleStyleWidget(
            icons: AppImages.plumbericonImg,
            title: AppStrings.plumbing,
            amount: 200.00,
            date: "May 28, 2024",
            time: '10:00 AM',
            name: "Janavi",
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.myProfile,
          style: TextStyle(
            color: AppColors.blueColors,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Image.asset(AppImages.logofixitImg),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 214, 226, 236),
                      blurRadius: 3,
                      spreadRadius: 1,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          unpaid = true;
                          paid = false;
                          schedule = false;
                        });
                      },
                      child: TextContainerWidget(
                        select: unpaid,
                        title: AppStrings.unpaid,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          unpaid = false;
                          paid = true;
                          schedule = false;
                        });
                      },
                      child: TextContainerWidget(
                        select: paid,
                        title: AppStrings.paid,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          unpaid = false;
                          paid = false;
                          schedule = true;
                        });
                      },
                      child: TextContainerWidget(
                        select: schedule,
                        title: AppStrings.schedule,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            orderBody(),
            if (unpaid)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MockPaymentScreen(),
                        ),
                      );
                    },
                    child: const Text("PAY ALL"),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
