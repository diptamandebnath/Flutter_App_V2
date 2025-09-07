import 'package:flutter/material.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_colors.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_strings.dart';

class MockPaymentScreen extends StatelessWidget {
  const MockPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Gateway'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Service: Plumbing\nProvider: Janavi\nDate: May 28, 2024\nAmount: ₹200.00',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            const Text(
              'Select Payment Method:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text("UPI - user@upi"),
              trailing: Icon(Icons.check_circle, color: AppColors.blueColors),
            ),
            const ListTile(
              leading: Icon(Icons.credit_card),
              title: Text("Credit Card - **** 1234"),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Payment Successful")),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Confirm Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
