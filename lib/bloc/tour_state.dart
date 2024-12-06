part of 'tour_bloc.dart';

@immutable
sealed class TourState {}

class TourInitial extends TourState {}

class TourLoading extends TourState {}

class TourLoaded extends TourState {
  final List<Tour> tours;
  TourLoaded(this.tours);
}

class TourOperationSuccess extends TourState {
  final String message;
  TourOperationSuccess(this.message);
}

class TourError extends TourState {
  final String errorMessage;
  TourError(this.errorMessage);
}

class TourDeleting extends TourState {}

class TourDeleted extends TourState {}
