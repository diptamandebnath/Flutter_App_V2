import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> provider;

  const OrderDetailsScreen({super.key, required this.provider});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final _addressController = TextEditingController();
  final _dateTimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _confirmOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to place an order.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Safely get the provider ID
    final providerId = widget.provider['aadhar_no'];
    if (providerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not identify the service provider. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('service_requests').add({
        'serviceName': widget.provider['service'] ?? 'N/A',
        'providerId': providerId,
        'providerName': widget.provider['name'] ?? 'N/A',
        'userId': user.uid,
        'userName': user.displayName ?? 'Anonymous',
        'address': _addressController.text,
        'dateTime': _dateTimeController.text,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
        'price': widget.provider['price'] ?? 150.0 // Default price if not available
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully! The provider has been notified.'),
          backgroundColor: Colors.green,
        ),
      );
      // Pop twice to go back to the home screen
      Navigator.of(context).pop();
      Navigator.of(context).pop();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Service'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Provider: ${widget.provider['name'] ?? 'N/A'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('Service: ${widget.provider['service'] ?? 'N/A'}'),
              const SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Service Address',
                  hintText: 'Enter your full address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dateTimeController,
                 decoration: const InputDecoration(
                  labelText: 'Preferred Date & Time',
                  hintText: 'e.g., Tomorrow at 2 PM',
                  border: OutlineInputBorder(),
                ),
                 validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a date and time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _confirmOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text('Confirm Booking', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
