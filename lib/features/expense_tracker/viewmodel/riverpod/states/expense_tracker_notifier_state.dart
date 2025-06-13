import '../../../model/tracker_model.dart';

abstract class ExpenseTrackerNotifierState {}

class ExpenseTrackerInitialState extends ExpenseTrackerNotifierState {}

class ExpenseTrackerLoadingState extends ExpenseTrackerNotifierState {}

class ExpenseTrackerLoadedState extends ExpenseTrackerNotifierState {
  final List<TrackerModel> trackerList;

  ExpenseTrackerLoadedState(this.trackerList);
}
