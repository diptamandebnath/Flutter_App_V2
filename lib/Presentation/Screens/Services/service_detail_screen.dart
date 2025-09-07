import 'package:flutter/material.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_colors.dart';

class ServiceDetailScreen extends StatelessWidget {
  final String title;

  const ServiceDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Choose image based on service title
    final String imagePath = title.toLowerCase().contains("plumb")
        ? 'assets/images/plumber.png'
        : title.toLowerCase().contains("electric")
        ? 'assets/images/electricwork.png'
        : title.toLowerCase().contains("solar")
        ? 'assets/images/solarenergy.png'
        : 'assets/images/airconditenior.png';

    // Choose description based on service title
    final String description = title.toLowerCase().contains("plumb")
        ? "Our professional plumbing services include leak repair, pipe installation, bathroom fitting, and drainage solutions."
        : title.toLowerCase().contains("electric")
        ? "Certified electricians available for wiring, installations, repairs, switchboards, and full home safety checks."
        : title.toLowerCase().contains("solar")
        ? "Our solar experts help install, maintain, and optimize solar panel systems to reduce energy bills and carbon footprint."
        : "AC professionals for installation, servicing, gas refill, and maintenance to keep your cooling efficient and reliable.";

    // Choose service list based on service title
    final List<String> services = title.toLowerCase().contains("plumb")
        ? [
      "Leak detection & repair",
      "Bathroom fitting",
      "Water pipe installation",
      "Drainage solutions",
    ]
        : title.toLowerCase().contains("electric")
        ? [
      "House wiring",
      "Switchboard installation",
      "Appliance fitting",
      "Emergency repairs",
    ]
        : title.toLowerCase().contains("solar")
        ? [
      "Solar panel installation",
      "Inverter setup",
      "System diagnostics",
      "Efficiency monitoring",
    ]
        : [
      "AC installation",
      "Regular servicing",
      "Gas refill",
      "Coolant line maintenance",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('$title Service'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              imagePath,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "What's included:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...services.map(
                        (item) => Row(
                      children: [
                        const Icon(Icons.check_circle_outline,
                            color: AppColors.blueColors),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Booking $title service...'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blueColors,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Book Now",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
