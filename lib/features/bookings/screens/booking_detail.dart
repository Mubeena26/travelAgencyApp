import 'package:admin_project/features/core/theme/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BookingDetail extends StatelessWidget {
  final dynamic booking;

  const BookingDetail({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: board2,
      appBar:
          AppBar(title: const Text('Booking Details'), backgroundColor: board2),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [board2, board1, board3],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Images section (Carousel Slider) first
              const Text(
                'Images:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if ((booking['imagePath'] as List<dynamic>).isNotEmpty)
                CarouselSlider(
                  items: (booking['imagePath'] as List<dynamic>)
                      .map<Widget>((imageUrl) => ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ))
                      .toList(),
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    autoPlayInterval: const Duration(seconds: 3),
                  ),
                )
              else
                const Center(
                  child: Text(
                    'No images available',
                    style: TextStyle(color: grey),
                  ),
                ),
              const SizedBox(height: 20), // Space before details section

              // Displaying booking details (Name, Package, Price, etc.)
              Container(
                height: 300,
                width: 400,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [board2, board1, board3],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${booking['name']}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text('Package: ${booking['packageName']}'),
                    const SizedBox(height: 10),
                    Text('Total Price: \$${booking['totalPrice']}'),
                    const SizedBox(height: 10),
                    Text('Email: ${booking['email']}'),
                    const SizedBox(height: 10),
                    Text('Phone Number: ${booking['phoneNumber']}'),
                    const SizedBox(height: 10),
                    Text('Adult count: ${booking['adultCount']}'),
                    const SizedBox(height: 10),
                    Text('Child count: ${booking['childCount']}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
