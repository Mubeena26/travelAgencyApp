part of 'tour_bloc.dart';

@immutable
sealed class TourEvent {}

class LoadTours extends TourEvent {}

class AddTourEvent extends TourEvent {
  // Renamed here
  final Tour tour;
  AddTourEvent({required this.tour});
}

class UpdateTour extends TourEvent {
  final Tour tour;
  UpdateTour({required this.tour});
}

// class DeleteTour extends TourEvent {
//   final Tour tour;
//   DeleteTour({required this.tour});
// }
class DeleteTour extends TourEvent {
  final String tourId; // Tour ID to delete
  DeleteTour({required this.tourId});
}
