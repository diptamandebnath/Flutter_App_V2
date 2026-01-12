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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User profile info
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(AppImages.kalpeshImg), // Placeholder
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome, Kalpesh!", // Placeholder
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
                          color: isAvailable ? Colors.green : Colors.red,
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
                      activeColor: AppColors.whiteColor,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),

            // Job listings
            const Text(
              "New Job Requests",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
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
                      title: Text("Job Request #${index + 1}"), // Placeholder
                      subtitle: const Text(
                          "Fix wiring issues in the living room."), // Placeholder
                      trailing: TextButton(
                        onPressed: () {
                          // TODO: Navigate to job details screen
                        },
                        child: const Text(
                          "View Details",
                          style: TextStyle(color: AppColors.blueColor),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
