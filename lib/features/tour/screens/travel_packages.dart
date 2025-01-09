import 'dart:developer';
import 'dart:io';

import 'package:admin_project/features/bloc/tour_bloc.dart';
import 'package:admin_project/features/core/theme/colors.dart';
import 'package:admin_project/features/tour/screens/tour_detail_page.dart';
import 'package:admin_project/features/tour/components/edit_tour.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/add_tour.dart';

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
          icon: const Icon(Icons.arrow_back, color: bluetheme),
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
            log(state.tours[0].imagePath.toString());
            log(state.tours[1].packageName.toString());

            if (tours.isEmpty) {
              return const Center(child: Text('No packages available.'));
            }
// ivide printavunind nan kanika athede verne print?? adh deails add cheydhitambo wait image avanila
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

                // Safely extract the first image URL if it exists

                // Log the first image URL to the console
                log('Image URL for tour at index $index: ${tour.imagePath}');

                return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: whitecolor,
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
                            child: tour.imagePath != null
                                ? Image.network(
                                    tour.imagePath!.first,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    },
                                  )
                                : const Center(
                                    child: Icon(Icons.image, size: 50),
                                  ), // Fallback if no image is available
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
                                      color: lightPrimary,
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
                                      color: lightPrimary,
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
                                  color: blackcolor,
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
