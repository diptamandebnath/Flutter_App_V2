import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_colors.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_images.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_strings.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/Order/order_detail_screen.dart';
import 'package:intl/intl.dart';

class OrderScreens extends StatefulWidget {
  const OrderScreens({super.key});

  @override
  State<OrderScreens> createState() => _OrderScreensState();
}

class _OrderScreensState extends State<OrderScreens> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.mybooking,
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('service_requests')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
                child: Text('An error occurred while fetching your bookings.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('You have no bookings yet.'));
          }

          final bookings = snapshot.data!.docs;
          bookings.sort((a, b) {
            var aData = a.data() as Map<String, dynamic>;
            var bData = b.data() as Map<String, dynamic>;
            Timestamp? aTimestamp = aData['timestamp'];
            Timestamp? bTimestamp = bData['timestamp'];
            if (aTimestamp == null && bTimestamp == null) return 0;
            if (aTimestamp == null) return 1;
            if (bTimestamp == null) return -1;
            return bTimestamp.compareTo(aTimestamp);
          });

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final data = booking.data() as Map<String, dynamic>;
              final negotiationHistory =
                  data['negotiationHistory'] as List<dynamic>? ?? [];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderDetailScreen(orderData: data),
                    ),
                  );
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data['serviceName'] ?? 'N/A',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            _buildStatusChip(data['status']),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              data['workerName'] ?? 'Not Assigned',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              data['timestamp'] != null
                                  ? DateFormat.yMMMd().add_jm().format(
                                      (data['timestamp'] as Timestamp).toDate(),
                                    )
                                  : 'N/A',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        if (data['acceptedPrice'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Final Price: ₹${data['acceptedPrice']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.blueColors,
                              ),
                            ),
                          ),
                        const Divider(height: 24),
                        if (negotiationHistory.isNotEmpty)
                          _buildNegotiationHistory(negotiationHistory),
                        if (data['status'] == 'pending' ||
                            data['status'] == 'negotiating')
                          _buildActionButtons(booking.id, data),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    Color chipColor;
    String chipText = status ?? 'Unknown';

    switch (status) {
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'accepted':
        chipColor = Colors.green;
        break;
      case 'rejected':
        chipColor = Colors.red;
        break;
      case 'canceled':
        chipColor = Colors.grey;
        break;
      case 'negotiating':
        chipColor = Colors.blue;
        break;
      default:
        chipColor = Colors.black;
    }

    return Chip(
      label: Text(
        chipText,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }

  Widget _buildNegotiationHistory(List<dynamic> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Negotiation History',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...history.map((negotiation) {
          final proposer = negotiation['proposer'] == 'user' ? 'You' : 'Worker';
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$proposer: ₹${negotiation['price']}'),
                Text(
                  DateFormat.jm()
                      .format((negotiation['timestamp'] as Timestamp).toDate()),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        }).toList(),
        const Divider(height: 24),
      ],
    );
  }

  Widget _buildActionButtons(
      String bookingId, Map<String, dynamic> bookingData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () {
            _showRenegotiateDialog(bookingId, bookingData);
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.blueColors,
            side: const BorderSide(color: AppColors.blueColors),
          ),
          child: const Text('Renegotiate'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            _cancelBooking(bookingId);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  void _showRenegotiateDialog(
      String bookingId, Map<String, dynamic> bookingData) {
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Renegotiate Price'),
          content: TextFormField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Enter your new price',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newPrice = double.tryParse(priceController.text);
                if (newPrice != null) {
                  _renegotiatePrice(bookingId, newPrice);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid price.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _renegotiatePrice(String bookingId, double newPrice) async {
    final firestore = FirebaseFirestore.instance;
    final serviceRequestRef =
        firestore.collection('service_requests').doc(bookingId);

    try {
      await firestore.runTransaction((transaction) async {
        transaction.update(serviceRequestRef, {
          'negotiationHistory': FieldValue.arrayUnion([
            {
              'price': newPrice,
              'proposer': 'user',
              'timestamp': FieldValue.serverTimestamp(),
            }
          ]),
          'status': 'negotiating',
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your new price has been submitted to the worker.'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while renegotiating.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _cancelBooking(String bookingId) async {
    await FirebaseFirestore.instance
        .collection('service_requests')
        .doc(bookingId)
        .update({'status': 'canceled'});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking Canceled'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
