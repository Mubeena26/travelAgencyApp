import 'package:admin_project/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  Stream<Map<String, dynamic>> _calculatePackageRevenues() {
    return FirebaseFirestore.instance
        .collection('bookings')
        .snapshots()
        .map((querySnapshot) {
      final Map<String, dynamic> packageRevenues = {};

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final packageName = data['packageName'] ?? 'Unknown Package';
        final totalPrice = data['totalPrice'] ?? 0.0;
        final imageUrls =
            data['imagePath'] as List<dynamic>?; // Assuming it's a list
        final imageUrl = (imageUrls != null && imageUrls.isNotEmpty)
            ? imageUrls.first // Fetch first image from the list
            : 'https://via.placeholder.com/150'; // Placeholder if no image

        // Ensure totalPrice is added correctly
        double revenue = 0.0;
        if (totalPrice is double) {
          revenue = totalPrice;
        } else {
          final price = double.tryParse(totalPrice.toString());
          if (price != null) {
            revenue = price;
          }
        }

        // Add or update the package revenue
        packageRevenues[packageName] = {
          'revenue':
              (packageRevenues[packageName]?['revenue'] ?? 0.0) + revenue,
          'imageUrl': imageUrl, // Store the image URL
        };
      }

      return packageRevenues;
    });
  }

  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 234, 247),
      drawer: Menu(),
      appBar: AppBar(
        title: const Text('Revenue'),
        backgroundColor: const Color.fromARGB(255, 107, 152, 161),
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: _calculatePackageRevenues(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No revenue data available'));
          }

          final packageRevenues = snapshot.data!;
          final packageNames = packageRevenues.keys.toList();

          return Stack(
            children: [
              // Background Container
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 108, 171, 182),
                      Color.fromARGB(255, 204, 217, 223),
                      Color.fromARGB(255, 121, 136, 143),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // GridView on top of the background
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 3 / 4, // Aspect ratio for each grid item
                  ),
                  itemCount: packageNames.length,
                  itemBuilder: (context, index) {
                    final packageName = packageNames[index];
                    final revenue = packageRevenues[packageName]['revenue'];
                    final imageUrl = packageRevenues[packageName]['imageUrl'];

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.image_not_supported,
                                      size: 120,
                                      color: Colors.grey,
                                    ),
                                  )
                                : const Icon(
                                    Icons.image_not_supported,
                                    size: 120,
                                    color: Colors.grey,
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  packageName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${revenue.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
