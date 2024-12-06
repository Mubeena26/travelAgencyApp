import 'dart:io';

import 'package:admin_project/bloc/tour_bloc.dart';
import 'package:admin_project/form_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:admin_project/models.dart';

class EditTour extends StatefulWidget {
  final Tour tour; // Pass the Tour object to edit
  const EditTour({super.key, required this.tour});

  @override
  State<EditTour> createState() => _EditTourState();
}

class _EditTourState extends State<EditTour> {
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
  final TextEditingController _exclusionsController = TextEditingController();
  final TextEditingController _itineraryController = TextEditingController();
  final TextEditingController _cancellationPolicyController =
      TextEditingController();
  final TextEditingController _termsConditionsController =
      TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize the form fields with the current tour's data
    _packageNameController.text = widget.tour.packageName;
    _packageTypeController.text = widget.tour.packageType;
    _destinationController.text = widget.tour.destination;
    _durationController.text = widget.tour.duration.toString();
    _priceController.text = widget.tour.price.toString();
    _activitiesController.text = widget.tour.activities.join(', ');
    _accommodationTypeController.text = widget.tour.accommodationType;
    _starRatingController.text = widget.tour.starRating.toString();
    _transportationModeController.text = widget.tour.transportationMode;
    _arrivalTimeController.text = widget.tour.arrivalTime;
    _departureTimeController.text = widget.tour.departureTime;
    _mealsController.text = widget.tour.meals.join(', ');
    _inclusionsController.text = widget.tour.inclusions.join(', ');
    _exclusionsController.text = widget.tour.exclusions.join(', ');
    _cancellationPolicyController.text = widget.tour.cancellationPolicy;
    _termsConditionsController.text = widget.tour.termsConditions;
    _availabilityController.text = widget.tour.availability.toString();
    _selectedImage =
        widget.tour.imagePath != null ? File(widget.tour.imagePath!) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Tour'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.add_a_photo,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _packageNameController,
                  hintText: 'Enter package name',
                  labelText: 'Package Name',
                  border: const OutlineInputBorder(),
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
                      fillColor: Colors.white),
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
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _durationController,
                  hintText: 'Enter duration (in days)',
                  labelText: 'Duration',
                  border: const OutlineInputBorder(),
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _priceController,
                  hintText: 'Enter price',
                  labelText: 'Price',
                  border: const OutlineInputBorder(),
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _activitiesController,
                  hintText: 'Enter activities (comma-separated)',
                  labelText: 'Activities',
                  border: const OutlineInputBorder(),
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _accommodationTypeController,
                  hintText: 'Enter accommodation type',
                  labelText: 'Accommodation Type',
                  border: const OutlineInputBorder(),
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _starRatingController,
                  hintText: 'Enter star rating',
                  labelText: 'Star Rating',
                  border: const OutlineInputBorder(),
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _transportationModeController,
                  hintText: 'Enter transportation mode',
                  labelText: 'Transportation Mode',
                  border: const OutlineInputBorder(),
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _arrivalTimeController,
                  hintText: 'Enter arrival time',
                  labelText: 'Arrival Time',
                  border: const OutlineInputBorder(),
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _departureTimeController,
                  hintText: 'Enter departure time',
                  labelText: 'Departure Time',
                  border: const OutlineInputBorder(),
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _mealsController,
                  hintText: 'Enter meals (comma-separated)',
                  labelText: 'Meals',
                  border: const OutlineInputBorder(),
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _inclusionsController,
                  hintText: 'Enter inclusions (comma-separated)',
                  labelText: 'Inclusions',
                  border: const OutlineInputBorder(),
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _exclusionsController,
                  hintText: 'Enter exclusions (comma-separated)',
                  labelText: 'Exclusions',
                  border: const OutlineInputBorder(),
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _cancellationPolicyController,
                  hintText: 'Enter cancellation policy',
                  labelText: 'Cancellation Policy',
                  border: const OutlineInputBorder(),
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _termsConditionsController,
                  hintText: 'Enter terms and conditions',
                  labelText: 'Terms & Conditions',
                  border: const OutlineInputBorder(),
                ),
                const SizedBox(height: 16),
                FormContainer(
                  controller: _availabilityController,
                  hintText: 'Enter availability',
                  labelText: 'Availability',
                  border: const OutlineInputBorder(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final updatedTour = widget.tour.copyWith(
                        packageName: _packageNameController.text.trim(),
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
                        cancellationPolicy:
                            _cancellationPolicyController.text.trim(),
                        termsConditions: _termsConditionsController.text.trim(),
                        availability:
                            int.parse(_availabilityController.text.trim()),
                        imagePath: _selectedImage?.path,
                      );
                      context.read<TourBloc>().add(
                            UpdateTour(tour: updatedTour),
                          );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Update Tour'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
