import 'package:admin_project/bloc/tour_bloc.dart';
import 'package:admin_project/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  // Adds tour details to Firestore
  Future<void> addTourDetails(
      Map<String, dynamic> tourDetails, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('tours')
          .doc(id)
          .set(tourDetails);
      print('Tour added with ID: $id');
    } catch (e) {
      print('Failed to add tour details: $e');
    }
  }

  // Adds a Tour object to Firestore
  Future<void> addTour(Tour tour) async {
    try {
      await addTourDetails(tour.toMap(), tour.id);
      print('Tour added: ${tour.packageName}');
    } catch (e) {
      print('Failed to add tour: $e');
    }
  }

  // Deletes a tour by ID
  Future<void> deleteTour(String id) async {
    try {
      await FirebaseFirestore.instance.collection('tours').doc(id).delete();
      print('Tour deleted: $id');
    } catch (e) {
      print('Failed to delete tour: $e');
    }
  }

  // Fetches all tours as a stream
  Future<List<Tour>> getTours() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('tours').get();
      snapshot.docs.forEach((doc) {
        print('Fetched tour: ${doc.data()}');
      });
      return snapshot.docs.map((doc) {
        return Tour.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Failed to fetch tours: $e');
      rethrow;
    }
  }

  // Update a tour in Firestore
  Future<void> updateTour(String id, Tour tour) async {
    try {
      await FirebaseFirestore.instance
          .collection('tours')
          .doc(id)
          .update(tour.toMap());
      print('Tour updated: $id');
    } catch (e) {
      print('Failed to update tour: $e');
    }
  }
}

Future<void> _saveImageUrlToFirebase(String imageUrl) async {
  try {
    // Reference to the Firestore collection where you want to save the data
    CollectionReference toursCollection =
        FirebaseFirestore.instance.collection('tours');

    // Assuming 'tourId' is the ID of the tour you're adding
    await toursCollection.add({
      'imagePath': imageUrl, // Save the image URL here
      'otherField': 'value', // You can also save other fields here
    });

    print('Image URL saved to Firebase!');
  } catch (e) {
    print('Failed to save image URL to Firebase: $e');
  }
}
