import 'package:flutter/material.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_text_style.dart';
import '../Order/order_details_screen.dart'; // Corrected import

class ServiceProviderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> provide;

  const ServiceProviderDetailScreen({super.key, required this.provide});

  // Mock descriptions based on name
  String getMockDescription(String name) {
    switch (name.toLowerCase()) {
      case 'pranab':
        return 'Pranab is a certified plumber with over 8 years of experience. He specializes in residential pipe fittings, leak repairs, and bathroom installations.';
      case 'rahul electrician':
        return 'Rahul is a licensed electrician known for quick diagnostics and safe electrical installations. He has over 5 years of field experience.';
      case 'anita solar expert':
        return 'Anita has 6+ years of experience in solar panel setup and maintenance. She’s known for optimizing energy usage and sustainable solutions.';
      case 'vikas ac technician':
        return 'Vikas offers expert air conditioner repair and installation. With 10 years of HVAC experience, he ensures quick and efficient service.';
      default:
        return 'Experienced professional offering reliable services with high customer satisfaction.';
    }
  }

  // Mock location based on name
  String getMockLocation(String name) {
    switch (name.toLowerCase()) {
      case 'pranab':
        return 'Delhi, India';
      case 'rahul electrician':
        return 'Mumbai, India';
      case 'anita solar expert':
        return 'Bangalore, India';
      case 'vikas ac technician':
        return 'Hyderabad, India';
      default:
        return 'India';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = provide['name'] ?? 'N/A';
    final String profession = provide['service'] ?? 'N/A';
    final String imageUrl = provide['img'] ?? '';
    final String rating = '4.5'; // This is hardcoded in the home screen

    final String description = getMockDescription(name);
    final String location = getMockLocation(name);

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Icon(Icons.person, size: 80, color: Colors.grey),
                    ),
            ),
            const SizedBox(height: 20),

            // Name
            Text(
              name,
              style: AppTextStyle.textStyle.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 8),

            // Profession
            Row(
              children: [
                const Icon(Icons.work, size: 20, color: Colors.grey),
                const SizedBox(width: 6),
                Text(profession, style: AppTextStyle.textStyle),
              ],
            ),
            const SizedBox(height: 8),

            // Rating
            Row(
              children: [
                const Icon(Icons.star, size: 20, color: Colors.amber),
                const SizedBox(width: 6),
                Text('Rating: $rating', style: AppTextStyle.textStyle),
              ],
            ),
            const SizedBox(height: 8),

            // Location
            Row(
              children: [
                const Icon(Icons.location_on, size: 20, color: Colors.red),
                const SizedBox(width: 6),
                Text(location, style: AppTextStyle.textStyle),
              ],
            ),
            const SizedBox(height: 20),

            // About Provider
            const Text(
              "About Provider",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 80), // for spacing above the button
          ],
        ),
      ),

      // Book Now Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderDetailsScreen(provider: provide), // Corrected Navigation
              ),
            );
          },
          icon: const Icon(Icons.book_online_outlined),
          label: const Text('Book Now', style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: const TextStyle(fontSize: 16, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
