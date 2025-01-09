import 'package:admin_project/features/screens/bloc/filter_event.dart';
import 'package:admin_project/features/screens/bloc/filter_state.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitialState());

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (event is FilterChangedEvent) {
      yield DashboardFilterChangedState(event.selectedFilter);
    }
  }
}
