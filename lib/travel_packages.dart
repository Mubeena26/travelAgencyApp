import 'dart:io';

import 'package:admin_project/bloc/tour_bloc.dart';
import 'package:admin_project/edit_tour.dart';
import 'package:admin_project/tour_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_tour.dart';

class TravelPackages extends StatefulWidget {
  const TravelPackages({super.key});

  @override
  _TravelPackagesState createState() => _TravelPackagesState();
}

class _TravelPackagesState extends State<TravelPackages> {
  @override
  void initState() {
    super.initState();
    // Trigger the loading of tours
    context.read<TourBloc>().add(LoadTours());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Packages'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF98C1E2)),
        ),
      ),
      body: BlocBuilder<TourBloc, TourState>(
        builder: (context, state) {
          if (state is TourLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TourError) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else if (state is TourLoaded) {
            final tours = state.tours;

            if (tours.isEmpty) {
              return const Center(child: Text('No packages available.'));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 10, // Spacing between columns
                mainAxisSpacing: 10, // Spacing between rows
                childAspectRatio: 3 / 4, // Adjust aspect ratio for card size
              ),
              itemCount: tours.length,
              itemBuilder: (context, index) {
                final tour = tours[index];

                return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TourDetailPage(tour: tour),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Image.network(
                              tour.imagePath ??
                                  '', // Replace `imagePath` with your URL field
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text Column
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tour.packageName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 66, 88, 132),
                                    ),
                                    maxLines:
                                        1, // Limit to 1 line to avoid excessive text
                                    overflow: TextOverflow
                                        .ellipsis, // Add ellipsis for long text
                                  ),
                                  Text(
                                    tour.destination,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 66, 88, 132),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Icon Buttons
                          Row(
                            mainAxisSize: MainAxisSize
                                .min, // Ensure the row takes only needed space
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Package'),
                                      content: const Text(
                                          'Are you sure you want to delete this package?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context.read<TourBloc>().add(
                                                DeleteTour(tourId: tour.id));
                                            Navigator.pop(context);
                                            context
                                                .read<TourBloc>()
                                                .add(LoadTours());
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditTour(tour: tour),
                                  ));
                                  context.read<TourBloc>().add(LoadTours());
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    ]));
              },
            );
          } else if (state is TourError) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF99C5E9),
        onPressed: () async {
          // Navigate to AddTour screen and refresh after a new tour is added
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddTour(),
          ));

          // Trigger a state refresh to reflect new or updated tours
          context.read<TourBloc>().add(LoadTours());
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
