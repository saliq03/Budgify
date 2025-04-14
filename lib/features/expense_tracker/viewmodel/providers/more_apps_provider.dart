import 'package:flutter/material.dart';
import '../../model/more_apps_model.dart';
import '../../data/more_apps_contents.dart';

class MoreAppsProvider extends ChangeNotifier{
  List<MoreAppsModel> _filteredApps = moreAppsContentsList;

  //Getter
  List<MoreAppsModel> get filteredApps => _filteredApps;

  //Setter
  set filteredApps(List<MoreAppsModel> value) {
    _filteredApps = value;
    notifyListeners();
  }

  //Methods
  void filterApps(String text){
    filteredApps = moreAppsContentsList
        .where((app) => app.title
        .toLowerCase()
        .contains(text.toLowerCase()))
        .toList();
  }
}

// void _filterApps() {
//   setState(() {
//     filteredApps = moreAppsContentsList
//         .where((app) => app.title
//             .toLowerCase()
//             .contains(searchController.text.toLowerCase()))
//         .toList();
//   });
// }
