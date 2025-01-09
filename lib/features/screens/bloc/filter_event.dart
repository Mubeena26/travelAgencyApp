import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class FilterChangedEvent extends DashboardEvent {
  final String selectedFilter;

  const FilterChangedEvent(this.selectedFilter);

  @override
  List<Object> get props => [selectedFilter];
}
