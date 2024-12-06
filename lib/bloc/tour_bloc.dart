import 'package:admin_project/firestore_services.dart';
import 'package:admin_project/models.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'tour_event.dart';
part 'tour_state.dart';

class TourBloc extends Bloc<TourEvent, TourState> {
  final FirestoreServices _firestoreServices;
  List<Tour> _tours = [];

  TourBloc(this._firestoreServices) : super(TourInitial()) {
    on<LoadTours>((event, emit) async {
      try {
        emit(TourLoading());
        _tours = await _firestoreServices.getTours();
        emit(TourLoaded(_tours));
      } catch (e) {
        emit(TourError('Failed to load tours.'));
      }
    });

    on<AddTourEvent>((event, emit) async {
      try {
        emit(TourLoading());
        await _firestoreServices.addTour(event.tour);
        emit(TourOperationSuccess('Tour added successfully.'));
      } catch (e) {
        emit(TourError('Failed to save the tour: $e'));
      }
    });

    on<UpdateTour>((event, emit) async {
      try {
        emit(TourLoading());
        await _firestoreServices.updateTour(event.tour.id, event.tour);
        emit(TourOperationSuccess('Tour updated successfully.'));
      } catch (e) {
        emit(TourError('Failed to update tour.'));
      }
    });

    on<DeleteTour>((event, emit) async {
      try {
        emit(TourDeleting());
        await _firestoreServices
            .deleteTour(event.tourId); // Corrected to use tourId
        emit(TourDeleted());
      } catch (e) {
        emit(TourError('Failed to delete tour: $e'));
      }
    });
  }
}
