import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_colors.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_images.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/ServiceProviderProfile/service_provider_profile.dart';

class WorkerHomePage extends StatefulWidget {
  const WorkerHomePage({super.key});

  @override
  State<WorkerHomePage> createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  bool isAvailable = true;
  bool showHeaderNotification = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () async {
      if (mounted) {
        setState(() {
          showHeaderNotification = true;
        });
        await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
      }
    });
  }

  void dismissNotification() {
    setState(() {
      showHeaderNotification = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                AppImages.logofixitImg,
                height: 40,
              ),
            ),
            title: const Text("Worker Dashboard"),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServiceProviderProfile(),
                    ),
                  );
                },
                icon: const Icon(Icons.person),
              )
            ],
            pinned: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage(AppImages.kalpeshImg), // Placeholder
                          ),
                          const SizedBox(width: 16),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome, Diptaman!", // Placeholder
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "Electrician", // Placeholder
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              Text(
                                isAvailable ? "Available" : "Unavailable",
                                style: TextStyle(
                                    color: isAvailable
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              Switch(
                                value: isAvailable,
                                onChanged: (value) {
                                  setState(() {
                                    isAvailable = value;
                                  });
                                },
                                activeTrackColor: AppColors.blueColor,
                                activeThumbColor: AppColors.whiteColor,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                if (showHeaderNotification)
                  Container(
                    width: double.infinity,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                            Icon(Icons.notifications_active,
                                color: AppColors.blueColor, size: 28),
                            SizedBox(width: 8),
                            Text(
                              'New Service Request',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Order By: John Doe',
                          style:
                              TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const Text(
                          'Time: 10:30 AM, 2025-09-06',
                          style:
                              TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const Text(
                          'Service: AC Repair',
                          style:
                              TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0A53DF),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                              onPressed: dismissNotification,
                              child: const Text('Accept',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white)),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE34208),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                              onPressed: dismissNotification,
                              child: const Text('Reject',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "New Job Requests",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5, // Placeholder
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              leading: const Icon(
                                Icons.work,
                                color: AppColors.blueColor,
                              ),
                              title: Text(
                                  "Job Request #${index + 1}"), // Placeholder
                              subtitle: const Text(
                                  "Fix wiring issues in the living room."), // Placeholder
                              trailing: TextButton(
                                onPressed: () {
                                  // TODO: Navigate to job details screen
                                },
                                child: const Text(
                                  "View Details",
                                  style:
                                      TextStyle(color: AppColors.blueColor),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
