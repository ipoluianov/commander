import 'package:commander/appstate/state_filepanel.dart';
import 'package:flutter/services.dart';

class StateApp {
  List<StateFilePanel> filepanels = [];
  int currentFilePanel = 0;
  bool commandLineActivated = false;

  static final StateApp _instance = StateApp._internal();

  factory StateApp() {
    return _instance;
  }

  StateApp._internal() {
    filepanels.add(StateFilePanel());
    filepanels.add(StateFilePanel());
  }

  Function onUpdate = () {};
  Function onCommandLineActivate = () {};
  Function onRequestDefaultFocus = () {};
  Function onRequestClearCommandLine = () {};

  void notifyChanges() {
    onUpdate();
  }

  void requestDefaultFocus() {
    onRequestDefaultFocus();
  }

  void executeCommandLine(String cmd) {
    commandLineActivated = false;
    print("Execute: $cmd");
    requestDefaultFocus();
    notifyChanges();
  }

  void requestClearCommandLine() {
    onRequestClearCommandLine();
  }

  void processKeyDown(RawKeyDownEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (filepanels[currentFilePanel].currentIndex > 0) {
        filepanels[currentFilePanel].currentIndex--;
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (filepanels[currentFilePanel].currentIndex <
          filepanels[currentFilePanel].items.length - 1) {
        filepanels[currentFilePanel].currentIndex++;
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.tab) {
      if (currentFilePanel == 0) {
        currentFilePanel = 1;
      } else {
        currentFilePanel = 0;
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (!commandLineActivated) {
        filepanels[currentFilePanel].mainAction();
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      filepanels[currentFilePanel].goBack();
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      onCommandLineActivate();
    }
    notifyChanges();
  }

  void setCurrentPanelIndex(int panelIndex) {
    currentFilePanel = panelIndex;
    notifyChanges();
  }

  void processFilePanelItem(int panelIndex, int index) {
    setCurrentPanelIndex(panelIndex);
    filepanels[panelIndex].currentIndex = index;
    notifyChanges();
  }
}
