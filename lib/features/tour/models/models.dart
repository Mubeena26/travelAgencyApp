class Tour {
  String id;
  String packageName;
  String packageType;
  String destination;
  int duration;
  double price;
  List<String> activities;
  String accommodationType;
  int starRating;
  String transportationMode;
  String arrivalTime;
  String departureTime;
  List<String> meals;
  List<String> inclusions;
  List<String> exclusions;
  List<Map<String, String>> itinerary;
  String cancellationPolicy;
  String termsConditions;
  String startDate; // Store as string
  String endDate; // Store as string
  int availability;
  bool isPublished;
  String adultper;
  String childper;
  List<String>? imagePath;

  Tour(
      {required this.id,
      required this.packageName,
      required this.packageType,
      required this.destination,
      required this.duration,
      required this.price,
      required this.activities,
      required this.accommodationType,
      required this.starRating,
      required this.transportationMode,
      required this.arrivalTime,
      required this.departureTime,
      required this.meals,
      required this.inclusions,
      required this.exclusions,
      required this.itinerary,
      required this.cancellationPolicy,
      required this.termsConditions,
      required this.startDate, // Pass as string
      required this.endDate, // Pass as string
      required this.availability,
      required this.isPublished,
      required this.imagePath,
      required this.adultper,
      required this.childper});

  // Serialize for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'packageName': packageName,
      'packageType': packageType,
      'destination': destination,
      'duration': duration,
      'price': price,
      'activities': activities,
      'accommodationType': accommodationType,
      'starRating': starRating,
      'transportationMode': transportationMode,
      'arrivalTime': arrivalTime,
      'departureTime': departureTime,
      'meals': meals,
      'inclusions': inclusions,
      'exclusions': exclusions,
      'itinerary': itinerary,
      'cancellationPolicy': cancellationPolicy,
      'termsConditions': termsConditions,
      'startDate': startDate, // Store startDate as a string
      'endDate': endDate, // Store endDate as a string
      'availability': availability,
      'isPublished': isPublished,
      'imagePath': imagePath,
      'adultPer': adultper,
      'childPer': childper,
    };
  }

  // Deserialize from Firestore
  factory Tour.fromMap(Map<String, dynamic> map) {
    return Tour(
      id: map['id'] ?? '',
      packageName: map['packageName'] ?? '',
      packageType: map['packageType'] ?? '',
      destination: map['destination'] ?? '',
      adultper: map['adultPer'] ?? '',
      childper: map['childPer'] ?? '',
      duration: map['duration'] ?? 0,
      price: map['price'] ?? 0.0,
      activities: List<String>.from(map['activities'] ?? []),
      accommodationType: map['accommodationType'] ?? '',
      starRating: map['starRating'] ?? 0,
      transportationMode: map['transportationMode'] ?? '',
      arrivalTime: map['arrivalTime'] ?? '',
      departureTime: map['departureTime'] ?? '',
      meals: List<String>.from(map['meals'] ?? []),
      inclusions: List<String>.from(map['inclusions'] ?? []),
      exclusions: List<String>.from(map['exclusions'] ?? []),
      itinerary: List<Map<String, String>>.from(map['itinerary'] ?? []),
      cancellationPolicy: map['cancellationPolicy'] ?? '',
      termsConditions: map['termsConditions'] ?? '',
      startDate: map['startDate'] ?? '', // Parse startDate as string
      endDate: map['endDate'] ?? '', // Parse endDate as string
      availability: map['availability'] ?? 0,
      isPublished: map['isPublished'] ?? false,
      imagePath: List<String>.from(map['imagePath'] ?? []),
    );
  }

  Tour copyWith({
    String? id,
    String? packageName,
    String? packageType,
    String? destination,
    int? duration,
    double? price,
    List<String>? activities,
    String? accommodationType,
    int? starRating,
    String? transportationMode,
    String? arrivalTime,
    String? departureTime,
    List<String>? meals,
    List<String>? inclusions,
    List<String>? exclusions,
    List<Map<String, String>>? itinerary,
    String? cancellationPolicy,
    String? termsConditions,
    String? startDate, // Changed to string
    String? endDate, // Changed to string
    int? availability,
    bool? isPublished,
    String? adultPer,
    String? childPer,
    List<String>? imagePath,
  }) {
    return Tour(
      id: id ?? this.id,
      packageName: packageName ?? this.packageName,
      packageType: packageType ?? this.packageType,
      destination: destination ?? this.destination,
      adultper: adultper,
      childper: childper,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      activities: activities ?? this.activities,
      accommodationType: accommodationType ?? this.accommodationType,
      starRating: starRating ?? this.starRating,
      transportationMode: transportationMode ?? this.transportationMode,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      departureTime: departureTime ?? this.departureTime,
      meals: meals ?? this.meals,
      inclusions: inclusions ?? this.inclusions,
      exclusions: exclusions ?? this.exclusions,
      itinerary: itinerary ?? this.itinerary,
      cancellationPolicy: cancellationPolicy ?? this.cancellationPolicy,
      termsConditions: termsConditions ?? this.termsConditions,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      availability: availability ?? this.availability,
      isPublished: isPublished ?? this.isPublished,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
