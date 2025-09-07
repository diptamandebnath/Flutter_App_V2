import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';  // ✅ Import audioplayers

import 'package:flutter_home_service_provider_app_clone/AppUtils/app_colors.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_constants.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_images.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_strings.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_text_style.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/ServiceProvider/service_provider.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/Services/service_detail_screen.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/Services/service_screens.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/ServiceSeekerProfile/service_seeker_profile.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/Order/order_screens.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/service_card_widget.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/service_provider_card_widget.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/Services/api_service.dart';
import '../ServiceProvider/service_provider_detail_screen.dart';

class HomePageScreen extends StatefulWidget {
  final bool showLoginSuccessMessage;

  const HomePageScreen({super.key, this.showLoginSuccessMessage = true});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedIndex = 0;
  bool _snackShown = false;

  final List<Widget> _screens = [
    const HomeContent(),
    const OrderScreens(),
    const ServiceSeekerProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.showLoginSuccessMessage && !_snackShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully logged in or registered.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      });
      _snackShown = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.blueColors,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: AppStrings.order,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<String> recommendations = [];
  bool isLoading = true;
  bool showHeaderNotification = false;
  final AudioPlayer _audioPlayer = AudioPlayer();  // ✅ Audio player instance

  @override
  void initState() {
    super.initState();
    fetchRecommendations();

    // Show header notification after 5 seconds and play sound
    Timer(const Duration(seconds: 5), () async {
      setState(() {
        showHeaderNotification = true;
      });

      // ✅ Play sound when notification appears
      await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
    });
  }

  void fetchRecommendations() async {
    try {
      final result = await ApiService.getRecommendations('AC Repair');
      setState(() {
        recommendations = result;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
    }
  }

  void dismissNotification() {
    setState(() {
      showHeaderNotification = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          if (showHeaderNotification)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.notifications_active, color: AppColors.blueColors, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'New Service Request',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Order By: John Doe',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const Text(
                    'Time: 10:30 AM, 2025-09-06',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const Text(
                    'Service: AC Repair',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A53DF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: dismissNotification,
                        child: const Text('Accept', style: TextStyle(fontSize: 14, color: Colors.white)),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE34208),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: dismissNotification,
                        child: const Text('Reject', style: TextStyle(fontSize: 14, color: Colors.black)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Image.asset(AppImages.logofixitcolorImg),
                    ),
                    actions: const [
                      Icon(Icons.call, color: Colors.black),
                      SizedBox(width: 24),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 193,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 147,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.deepPurple, AppColors.blueColors],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.get30,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  AppStrings.just,
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 22,
                          child: Image.asset(AppImages.offerIconsImg, height: 150),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: Image.asset(AppImages.filterImg),
                              hintText: AppStrings.searchHere,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.popularServices, style: AppTextStyle.textStyle),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ServiceScreens()),
                          );
                        },
                        child: const Text(AppStrings.viewAll, style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ServiceDetailScreen(title: 'Plumbing'),
                              ),
                            );
                          },
                          child: const ServiceCardWidget(
                            title: AppStrings.plumbing,
                            imageUrl: AppImages.plumberImg,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ServiceDetailScreen(title: 'Electric Work'),
                              ),
                            );
                          },
                          child: const ServiceCardWidget(
                            title: AppStrings.electricwork,
                            imageUrl: AppImages.electricworkImg,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ServiceDetailScreen(title: 'Solar'),
                              ),
                            );
                          },
                          child: const ServiceCardWidget(
                            title: AppStrings.solar,
                            imageUrl: AppImages.solarenergyImg,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ServiceDetailScreen(title: 'Air Conditioner'),
                              ),
                            );
                          },
                          child: const ServiceCardWidget(
                            title: AppStrings.airConditenior,
                            imageUrl: AppImages.airconditeniorImg,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.servicesprovider, style: AppTextStyle.textStyle),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ServiceProviderScreens()),
                          );
                        },
                        child: const Text(AppStrings.viewAll, style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: AppConstants.serviceProvider.length,
                      itemBuilder: (context, index) {
                        final provider = AppConstants.serviceProvider[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ServiceProviderDetailScreen(provide: provider),
                              ),
                            );
                          },
                          child: ServiceProviderCardWidget(
                            name: provider.name.toString(),
                            profession: provider.profession.toString(),
                            rating: provider.rating.toString(),
                            imageUrl: provider.imageUrl.toString(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Categories', style: AppTextStyle.textStyle),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: const [
                        Chip(label: Text('Repair')),
                        SizedBox(width: 8),
                        Chip(label: Text('Cleaning')),
                        SizedBox(width: 8),
                        Chip(label: Text('Electrical')),
                        SizedBox(width: 8),
                        Chip(label: Text('Appliance')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: const [
                          Icon(Icons.verified_user, color: AppColors.blueColors),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Why choose us? Certified professionals, guaranteed service, and on-time arrival.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('What our users say', style: AppTextStyle.textStyle),
                  const SizedBox(height: 8),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        '⭐️⭐️⭐️⭐️⭐️ Great service and very professional!',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Recommended for you', style: AppTextStyle.textStyle),
                  const SizedBox(height: 12),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                    children: recommendations.map((item) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.recommend, color: AppColors.blueColors),
                          title: Text(item),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ServiceDetailScreen(title: item),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blueColors,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ServiceScreens()),
                        );
                      },
                      icon: const Icon(Icons.flash_on),
                      label: const Text('Quick Book Now'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
