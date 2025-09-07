import 'package:flutter/material.dart';
import '../../../Models/service_provider.dart';

class OrderDetailsScreen extends StatelessWidget {
  final ServiceProvider provider;

  const OrderDetailsScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Provider: ${provider.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Profession: ${provider.profession}'),
            Text('Rating: ${provider.rating}'),
            const SizedBox(height: 20),
            const Text('Service Address:', style: TextStyle(fontSize: 16)),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter your address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Preferred Date & Time:', style: TextStyle(fontSize: 16)),
            const TextField(
              decoration: InputDecoration(
                hintText: 'DD/MM/YYYY HH:MM',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order placed successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context); // Optionally return to previous screen
                },
                child: const Text('Confirm Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
