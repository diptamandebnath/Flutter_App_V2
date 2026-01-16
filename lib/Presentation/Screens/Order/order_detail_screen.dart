import 'package:flutter/material.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_colors.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/Order/mock_payment_screen.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailScreen({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              orderData['serviceName'] ?? 'N/A',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
                Icons.person, 'Worker', orderData['workerName'] ?? 'Not Assigned'),
            _buildDetailRow(
                Icons.calendar_today,
                'Date',
                orderData['timestamp'] != null
                    ? DateFormat.yMMMd()
                        .add_jm()
                        .format((orderData['timestamp']).toDate())
                    : 'N/A'),
            _buildDetailRow(
                Icons.price_change,
                'Price',
                orderData['acceptedPrice'] != null
                    ? '₹${orderData['acceptedPrice']}'
                    : 'Not Set'),
            _buildDetailRow(
                Icons.info, 'Status', orderData['status'] ?? 'Unknown'),
            const Spacer(),
            if (orderData['status'] == 'accepted')
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blueColors,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MockPaymentScreen(),
                      ),
                    );
                  },
                  child: const Text('Pay Now'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 16),
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
