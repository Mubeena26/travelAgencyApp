import 'dart:convert';
import 'dart:io';
import 'package:admin_project/features/bloc/tour_bloc.dart';
import 'package:admin_project/features/core/theme/colors.dart';
import 'package:admin_project/features/tour/widgts/form_container.dart';
import 'package:admin_project/features/tour/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddTour extends StatefulWidget {
  AddTour({super.key});

  get tour => null;

  @override
  State<AddTour> createState() => _AddTourState();
}

class _AddTourState extends State<AddTour> {
  String? _selectedPackageType;

  final List<String> _packageTypes = [
    'Adventure',
    'Honeymoon',
    'Family',
  ];
  // Controllers for all fields
  final TextEditingController _packageNameController = TextEditingController();
  final TextEditingController _packageTypeController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _activitiesController = TextEditingController();
  final TextEditingController _accommodationTypeController =
      TextEditingController();
  final TextEditingController _starRatingController = TextEditingController();
  final TextEditingController _transportationModeController =
      TextEditingController();
  final TextEditingController _arrivalTimeController = TextEditingController();
  final TextEditingController _departureTimeController =
      TextEditingController();
  final TextEditingController _mealsController = TextEditingController();
  final TextEditingController _inclusionsController = TextEditingController();
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();
  final TextEditingController _adultPer = TextEditingController();
  final TextEditingController _childper = TextEditingController();
  final TextEditingController _exclusionsController = TextEditingController();
  final TextEditingController _itineraryController = TextEditingController();
  final TextEditingController _cancellationPolicyController =
      TextEditingController();
  final TextEditingController _termsConditionsController =
      TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<File> _selectedImages = [];

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();

    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    } else {
      print('No images selected.');
    }
  }

  Future<List<String>?> _uploadImages() async {
    final List<String> imageUrls = [];
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dbgvn6kup/upload');

    for (var selectedImage in _selectedImages) {
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'my_upload_preset'
        ..files
            .add(await http.MultipartFile.fromPath('file', selectedImage.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        final imageUrl = jsonMap['url'];

        imageUrls.add(imageUrl);
      } else {
        print('Image upload failed');
      }
    }

    return imageUrls.isNotEmpty ? imageUrls : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Tour'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery),
                  child: _selectedImages.isNotEmpty
                      ? Container(
                          height:
                              200, // Set a fixed height for the grid view container
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // Adjust as needed
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                            ),
                            itemCount: _selectedImages.length,
                            itemBuilder: (context, index) {
                              return Image.file(
                                _selectedImages[index],
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        )
                      : Container(
                          height: 200, // Empty space if no images are selected
                          color: grey,
                          child: Center(child: Text('No images selected')),
                        ),
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _packageNameController,
                  hintText: 'Enter package name',
                  labelText: 'Package Name',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your package name.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedPackageType,
                  items: _packageTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPackageType = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: 'Package Type',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: whitecolor),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a package type.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _destinationController,
                  hintText: 'Enter destination',
                  labelText: 'Destination',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your destination.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _startDate,
                  hintText: 'Enter start date',
                  labelText: 'Start date',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter start date.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _endDate,
                  hintText: 'Enter end date',
                  labelText: 'end date',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter end date.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _durationController,
                  hintText: 'Enter duration (in days)',
                  labelText: 'Duration',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your duration.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _adultPer,
                  hintText: 'Enter adult price',
                  labelText: 'adult Price',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter adult price.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _childper,
                  hintText: 'Enter child price',
                  labelText: 'child price',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your child price.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _priceController,
                  hintText: 'Enter price',
                  labelText: 'Price',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your price.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _activitiesController,
                  hintText: 'Enter activities (comma-separated)',
                  labelText: 'Activities',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your activities.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _accommodationTypeController,
                  hintText: 'Enter accommodation type',
                  labelText: 'Accommodation Type',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your accomodation type.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _starRatingController,
                  hintText: 'Enter star rating',
                  labelText: 'Star Rating',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your star rating.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _transportationModeController,
                  hintText: 'Enter transportation mode',
                  labelText: 'Transportation Mode',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your transportation mode.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _arrivalTimeController,
                  hintText: 'Enter arrival time',
                  labelText: 'Arrival Time',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your arrivaltime.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _departureTimeController,
                  hintText: 'Enter departure time',
                  labelText: 'Departure Time',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your departure time.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _mealsController,
                  hintText: 'Enter meals (comma-separated)',
                  labelText: 'Meals',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your meals.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _inclusionsController,
                  hintText: 'Enter inclusions (comma-separated)',
                  labelText: 'Inclusions',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Inclusions.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _exclusionsController,
                  hintText: 'Enter exclusions (comma-separated)',
                  labelText: 'Exclusions',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your exclusions.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _cancellationPolicyController,
                  hintText: 'Enter cancellation policy',
                  labelText: 'Cancellation Policy',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your cancellation policy.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _termsConditionsController,
                  hintText: 'Enter terms and conditions',
                  labelText: 'Terms & Conditions',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your terms and conditions.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _availabilityController,
                  hintText: 'Enter availability',
                  labelText: 'Availability',
                  border: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your availability.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Upload images and get the URLs
                      List<String>? imageUrls;
                      if (_selectedImages.isNotEmpty) {
                        imageUrls = await _uploadImages();
                      }

                      if (_selectedImages.isNotEmpty && imageUrls == null) {
                        // Show error message if image upload failed
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Image upload failed. Please try again."),
                          ),
                        );
                        return;
                      }

                      // Create the Tour object with all the input data
                      final newTour = Tour(
                        id: UniqueKey().toString(),
                        packageName: _packageNameController.text.trim(),
                        adultper: _adultPer.text.trim(),
                        childper: _childper.text.trim(),
                        packageType: _selectedPackageType ?? '',
                        destination: _destinationController.text.trim(),
                        duration: int.parse(_durationController.text.trim()),
                        price: double.parse(_priceController.text.trim()),
                        activities:
                            _activitiesController.text.trim().split(','),
                        accommodationType:
                            _accommodationTypeController.text.trim(),
                        starRating:
                            int.parse(_starRatingController.text.trim()),
                        transportationMode:
                            _transportationModeController.text.trim(),
                        arrivalTime: _arrivalTimeController.text.trim(),
                        departureTime: _departureTimeController.text.trim(),
                        meals: _mealsController.text.trim().split(','),
                        inclusions:
                            _inclusionsController.text.trim().split(','),
                        exclusions:
                            _exclusionsController.text.trim().split(','),
                        itinerary: [], // Populate this as needed
                        cancellationPolicy:
                            _cancellationPolicyController.text.trim(),
                        termsConditions: _termsConditionsController.text.trim(),
                        startDate: DateTime.parse(_startDate.text)
                            .toIso8601String()
                            .split('T')[0],
                        endDate: DateTime.parse(_endDate.text)
                            .toIso8601String()
                            .split('T')[0],

                        availability:
                            int.parse(_availabilityController.text.trim()),
                        isPublished: true,
                        imagePath: imageUrls, // Store the list of image URLs
                      );

                      // Example usage: Add to Firebase Firestore
                      // try {
                      //   CollectionReference toursCollection =
                      //       FirebaseFirestore.instance.collection('tours');
                      //   await toursCollection.add(newTour.toMap());
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(
                      //       content: Text("Tour added successfully!"),
                      //     ),
                      //   );

                      //   // Optionally clear the form
                      //   _formKey.currentState?.reset();
                      //   setState(() {
                      //     _selectedImage = null;
                      //     _selectedPackageType = null;
                      //   });
                      // } catch (e) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Text("Failed to add tour: $e"),
                      //     ),
                      //   );
                      // }

                      // Example usage with Bloc
                      context.read<TourBloc>().add(AddTourEvent(tour: newTour));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Method to save the tour to Firebase Firestore
Future<void> _saveTourToFirebase(Tour tour) async {
  try {
    CollectionReference toursCollection =
        FirebaseFirestore.instance.collection('tours');
    await toursCollection.add({
      'packageName': tour.packageName,
      'packageType': tour.packageType,
      'destination': tour.destination,
      'duration': tour.duration,
      'price': tour.price,
      'activities': tour.activities,
      'accommodationType': tour.accommodationType,
      'starRating': tour.starRating,
      'transportationMode': tour.transportationMode,
      'arrivalTime': tour.arrivalTime,
      'departureTime': tour.departureTime,
      'meals': tour.meals,
      'inclusions': tour.inclusions,
      'exclusions': tour.exclusions,
      'cancellationPolicy': tour.cancellationPolicy,
      'termsConditions': tour.termsConditions,
      'availability': tour.availability,
      'imageUrl': tour.imagePath, // Save image URL to Firestore
    });

    print('Tour added to Firestore!');
  } catch (e) {
    print('Failed to add tour: $e');
  }
}
