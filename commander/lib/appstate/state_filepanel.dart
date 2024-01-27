import 'package:commander/appstate/state_app.dart';
import 'package:commander/appstate/state_filepanel_item.dart';

import '../go/go.dart';

class StateFilePanel {
  int currentIndex = 0;
  List<String> currentPath = [];
  List<StateFilePanelItem> items = [];

  void setCurrentIndex(int index) {
    currentIndex = index;
  }

  String currentPathString() {
    String result = "";
    for (var part in currentPath) {
      result += "/";
      result += part;
    }
    if (result.isEmpty) {
      result = "/";
    }
    return result;
  }

  Future<void> load() async {
    items.clear();
    //StateApp().notifyChanges();
    var value = await callGo(
      '{"f":"filesystem_dirs", "path":"${currentPathString()}"}',
    );
    var its = value["items"];
    if (its != null) {
      for (var it in its) {
        StateFilePanelItem item = StateFilePanelItem();
        item.fileName = it['name'];
        items.add(item);
      }
    }
    StateApp().notifyChanges();
  }

  void mainAction() {
    currentPath.add(items[currentIndex].fileName);
    load();
    currentIndex = 0;
    StateApp().notifyChanges();
  }

  void goBack() {
    if (currentPath.isNotEmpty) {
      currentPath.removeLast();
    }
    load();
  }
}
