import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitialState extends DashboardState {}

class DashboardFilterChangedState extends DashboardState {
  final String selectedFilter;

  const DashboardFilterChangedState(this.selectedFilter);

  @override
  List<Object> get props => [selectedFilter];
}
