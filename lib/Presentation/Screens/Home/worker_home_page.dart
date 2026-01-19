import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_colors.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_images.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/ServiceProviderProfile/service_provider_profile.dart';

class WorkerHomePage extends StatefulWidget {
  final String aadharNo;
  const WorkerHomePage({super.key, required this.aadharNo});

  @override
  State<WorkerHomePage> createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  bool isAvailable = true;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Map<String, dynamic>? _workerData;
  bool _isLoading = true;
  bool showHeaderNotification = false;
  DocumentSnapshot? _latestRequest;
  StreamSubscription? _serviceRequestSubscription;

  @override
  void initState() {
    super.initState();
    _fetchWorkerData().then((_) {
      if (_workerData != null) {
        _listenForServiceRequests();
      }
    });
  }

  @override
  void dispose() {
    _serviceRequestSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _listenForServiceRequests() {
    if (_workerData?['service'] == null) return;

    final query = FirebaseFirestore.instance
        .collection('service_requests')
        .where('serviceName', isEqualTo: _workerData!['service'])
        .where('status', isEqualTo: 'pending')
        .orderBy('timestamp', descending: true)
        .limit(1);

    _serviceRequestSubscription = query.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final newRequest = snapshot.docs.first;
        if (!showHeaderNotification || (_latestRequest?.id != newRequest.id)) {
          setState(() {
            _latestRequest = newRequest;
            showHeaderNotification = true;
          });
          _audioPlayer.play(AssetSource('sounds/notification.mp3'));
        }
      }
    });
  }

  void dismissNotification() {
    setState(() {
      showHeaderNotification = false;
    });
  }

  Future<void> _fetchWorkerData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .where('aadhar_no', isEqualTo: widget.aadharNo)
          .limit(1)
          .get();

      if (mounted && querySnapshot.docs.isNotEmpty) {
        setState(() {
          _workerData = querySnapshot.docs.first.data();
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _isLoading = false;
        });
        print('Worker not found');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Error fetching worker data: $e');
    }
  }

  Future<void> _confirmBooking(
      String serviceRequestId, Map<String, dynamic> requestData, double? price) async {
    final firestore = FirebaseFirestore.instance;
    final acceptedPrice = price ?? requestData['price'];

    try {
      await firestore.runTransaction((transaction) async {
        final serviceRequestRef =
            firestore.collection('service_requests').doc(serviceRequestId);
        final bookingRef = firestore.collection('bookings').doc();
        final notificationRef = firestore.collection('notifications').doc();

        final serviceRequestSnapshot = await transaction.get(serviceRequestRef);
        if (!serviceRequestSnapshot.exists ||
            serviceRequestSnapshot.data()!['status'] != 'pending') {
          throw Exception('This job is no longer available.');
        }

        transaction.update(serviceRequestRef, {
          'status': 'accepted',
          'acceptedBy': widget.aadharNo,
          'workerName': _workerData?['name'] ?? 'N/A',
          'acceptedPrice': acceptedPrice,
        });

        transaction.set(bookingRef, {
          'workerId': widget.aadharNo,
          'workerName': _workerData?['name'] ?? 'N/A',
          'userId': requestData['userId'],
          'serviceRequestId': serviceRequestId,
          'serviceName': requestData['serviceName'],
          'status': 'accepted',
          'regularPrice': requestData['price'],
          'acceptedPrice': acceptedPrice,
          'timestamp': FieldValue.serverTimestamp(),
        });

        transaction.set(notificationRef, {
          'userId': requestData['userId'],
          'message':
              'Your request for ${requestData['serviceName']} has been accepted by ${_workerData?['name'] ?? 'a worker'}.',
          'timestamp': FieldValue.serverTimestamp(),
          'isRead': false,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking confirmed and user notified!'),
          backgroundColor: Colors.green,
        ),
      );
      dismissNotification();
    } catch (e) {
      print('Error confirming booking: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _rejectRequest(String serviceRequestId, Map<String, dynamic> requestData) async {
    final firestore = FirebaseFirestore.instance;
    final serviceRequestRef = firestore.collection('service_requests').doc(serviceRequestId);
    final notificationRef = firestore.collection('notifications').doc();

    try {
      await firestore.runTransaction((transaction) async {
        final serviceRequestSnapshot = await transaction.get(serviceRequestRef);
        if (!serviceRequestSnapshot.exists || serviceRequestSnapshot.data()!['status'] != 'pending') {
          throw Exception('This job is no longer available.');
        }

        transaction.update(serviceRequestRef, {'status': 'rejected'});

        transaction.set(notificationRef, {
          'userId': requestData['userId'],
          'message': 'Your request for ${requestData['serviceName']} was declined.',
          'timestamp': FieldValue.serverTimestamp(),
          'isRead': false,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Job request rejected.'),
          backgroundColor: Colors.orange,
        ),
      );
      dismissNotification();
    } catch (e) {
      print('Error rejecting request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _renegotiatePrice(String serviceRequestId, Map<String, dynamic> requestData, double newPrice) async {
    final firestore = FirebaseFirestore.instance;
    final serviceRequestRef = firestore.collection('service_requests').doc(serviceRequestId);

    try {
      await firestore.runTransaction((transaction) async {
        final serviceRequestSnapshot = await transaction.get(serviceRequestRef);
        if (!serviceRequestSnapshot.exists || serviceRequestSnapshot.data()!['status'] != 'pending') {
          throw Exception('This job is no longer available.');
        }

        // Add the new price to the negotiation history
        transaction.update(serviceRequestRef, {
          'negotiationHistory': FieldValue.arrayUnion([
            {
              'price': newPrice,
              'proposer': 'worker',
              'timestamp': FieldValue.serverTimestamp(),
            }
          ]),
          'negotiationCount': FieldValue.increment(1),
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your new price has been submitted to the user.'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      print('Error renegotiating price: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  void _showAcceptanceDialog(
      String serviceRequestId, Map<String, dynamic> requestData) {
    int selectedOption = 1;
    final priceController = TextEditingController();
    final regularPrice = requestData['price'] as double? ?? 0.0;
    final negotiationCount = requestData['negotiationCount'] as int? ?? 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Confirm Acceptance'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile<int>(
                    title: Text('Accept with regular price (₹$regularPrice)'),
                    value: 1,
                    groupValue: selectedOption,
                    onChanged: (int? value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('Accept with lesser price'),
                    value: 2,
                    groupValue: selectedOption,
                    onChanged: (int? value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  if (selectedOption == 2)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 8.0),
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Enter your price',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    if (negotiationCount < 3)
                    RadioListTile<int>(
                    title: const Text('Re-negotiate Price'),
                    value: 3,
                    groupValue: selectedOption,
                    onChanged: (int? value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  if (selectedOption == 3)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 8.0),
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Enter your new price',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Confirm'),
                  onPressed: () {
                    double? customPrice;
                    if (selectedOption == 2) {
                      customPrice = double.tryParse(priceController.text);
                      if (customPrice == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a valid price.'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }
                       _confirmBooking(serviceRequestId, requestData, customPrice);
                    } else if (selectedOption == 3) {
                       customPrice = double.tryParse(priceController.text);
                      if (customPrice == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a valid price.'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }
                      _renegotiatePrice(serviceRequestId, requestData, customPrice);
                    } else {
                       _confirmBooking(serviceRequestId, requestData, regularPrice);
                    }

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final latestRequestData =
        _latestRequest?.data() as Map<String, dynamic>? ?? {};

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                AppImages.logofixitcolorImg,
                height: 40,
              ),
            ),
            centerTitle: true,
            title: const Text(
              "Worker Dashboard",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
              background: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: _workerData?['img'] != null
                                      ? NetworkImage(_workerData!['img'])
                                      : const AssetImage(AppImages.kalpeshImg)
                                          as ImageProvider,
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Welcome, ${_workerData?['name'] ?? 'Worker'}!",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      _workerData?['service'] ?? 'Unavailable',
                                      style: const TextStyle(
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
          if (showHeaderNotification && _latestRequest != null)
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyNotificationDelegate(
                child: Container(
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
                      Text(
                        'Order By: ${latestRequestData['userName'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      Text(
                        'Service: ${latestRequestData['serviceName'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
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
                            onPressed: () {
                              _showAcceptanceDialog(
                                  _latestRequest!.id, latestRequestData);
                            },
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
                            onPressed: () => _rejectRequest(_latestRequest!.id, latestRequestData),
                            child: const Text('Reject',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
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
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('service_requests')
                                  .where('serviceName',
                                      isEqualTo: _workerData?['service'])
                                  .where('status', whereIn: ['pending', 'negotiating'])
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return const Center(
                                      child: Text(
                                          'No new job requests at the moment.'));
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    final request = snapshot.data!.docs[index];
                                    final data =
                                        request.data() as Map<String, dynamic>;
                                      final negotiationHistory = data['negotiationHistory'] as List<dynamic>? ?? [];


                                    return Card(
                                      elevation: 3,
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                             ListTile(
                                                leading: const Icon(
                                                  Icons.work,
                                                  color: AppColors.blueColor,
                                                ),
                                                title: Text(data['serviceName'] ?? 'N/A'),
                                                subtitle: Text(
                                                    'From: ${data['userName'] ?? 'N/A'}'),
                                              ),
                                            const Divider(),
                                            ...negotiationHistory.map((negotiation) {
                                                return ListTile(
                                                  title: Text('Offer: ₹${negotiation['price']}'),
                                                  subtitle: Text('By: ${negotiation['proposer']}'),
                                                );
                                            }),
                                            const Divider(),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text("Status: ${data['status']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                            const Spacer(),
                                            ElevatedButton(
                                              onPressed: () {
                                                _showAcceptanceDialog(
                                                    request.id, data);
                                              },
                                              child: const Text('Respond'),
                                            ),
                                          ],
                                        ),
                                          ],
                                        ),
                                      )
                                    );
                                  },
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyNotificationDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyNotificationDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 220;

  @override
  double get minExtent => 220;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
