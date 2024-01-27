import 'package:commander/appstate/state_app.dart';
import 'package:commander/appstate/state_filepanel_item.dart';

import '../go/go.dart';

class StateFilePanel {
  int currentIndex = 0;
  List<PathPart> currentPath = [];
  List<StateFilePanelItem> items = [];
  List<int> savedCursorPositions = [];

  void setCurrentIndex(int index) {
    currentIndex = index;
  }

  String currentPathString() {
    String result = "";
    for (var part in currentPath) {
      result += "/";
      result += part.name;
    }
    if (result.isEmpty) {
      result = "/";
    }
    return result;
  }

  Future<void> load(int selectIndex) async {
    items.clear();
    StateApp().notifyChanges();
    var value = await callGo(
      '{"f":"filesystem_dirs", "path":"${currentPathString()}"}',
    );

    if (currentPath.isNotEmpty) {
      StateFilePanelItem item = StateFilePanelItem();
      item.fileName = '..';
      item.isDir = true;
      items.add(item);
    }

    var its = value["items"];
    if (its != null) {
      for (var it in its) {
        StateFilePanelItem item = StateFilePanelItem();
        item.fileName = it['name'];
        item.isDir = it['is_dir'];
        if (item.isDir) {
          items.add(item);
        }
      }
      for (var it in its) {
        StateFilePanelItem item = StateFilePanelItem();
        item.fileName = it['name'];
        item.isDir = it['is_dir'];
        if (!item.isDir) {
          items.add(item);
        }
      }
    }
    currentIndex = selectIndex;
    StateApp().notifyChanges();
  }

  void mainAction() {
    String fileName = items[currentIndex].fileName;
    if (fileName == "..") {
      goBack();
      return;
    }
    if (items[currentIndex].isDir) {
      savedCursorPositions.add(currentIndex);
      var part = PathPart(fileName);
      currentPath.add(part);
      load(0);
      StateApp().notifyChanges();
    }
  }

  void goBack() {
    if (currentPath.isNotEmpty) {
      currentPath.removeLast();
      int lastIndex = savedCursorPositions.last;
      savedCursorPositions.removeLast();
      load(lastIndex);
    }
  }
}

class PathPart {
  String name = "";
  PathPart(this.name);
}
