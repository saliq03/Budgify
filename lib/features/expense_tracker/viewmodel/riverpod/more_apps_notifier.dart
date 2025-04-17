import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/more_apps_model.dart';
import '../../data/more_apps_contents.dart';

class MoreAppsNotifier extends StateNotifier<List<MoreAppsModel>> {
  MoreAppsNotifier() : super(moreAppsContentsList);

  void filterApps(String text) {
    state = moreAppsContentsList
        .where((app) => app.title.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }
}

final moreAppsProvider = StateNotifierProvider<MoreAppsNotifier, List<MoreAppsModel>>(
      (ref) => MoreAppsNotifier(),
);
