import 'package:commander/appstate/state_filepanel.dart';
import 'package:flutter/services.dart';

class StateApp {
  List<StateFilePanel> filepanels = [];
  int currentFilePanel = 0;
  String _activatedWidget = "";

  static const String widgetFilePanel = "";
  static const String widgetCommandLine = "COMMAND_LINE";
  static const String widgetRenameFileField = "RENAME_FILE_FIELD";

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
  Function onCommandLineAppend = (String txt) {};

  void notifyChanges() {
    onUpdate();
  }

  void requestDefaultFocus() {
    onRequestDefaultFocus();
  }

  void setActivatedWidget(String activatedWidget) {
    if (_activatedWidget == widgetRenameFileField &&
        activatedWidget != widgetRenameFileField) {
      filepanels[currentFilePanel].currentItem().onRenameFieldDeActivated();
    }

    _activatedWidget = activatedWidget;
    notifyChanges();

    if (isRenameFieldActivated()) {
      filepanels[currentFilePanel].currentItem().onRenameFieldActivated();
    }
  }

  String activatedWidget() {
    return _activatedWidget;
  }

  bool isFilePanelActivated() {
    return _activatedWidget == "";
  }

  bool isCommandLineActivated() {
    return _activatedWidget == widgetCommandLine;
  }

  bool isRenameFieldActivated() {
    return _activatedWidget == widgetRenameFileField;
  }

  void executeCommandLine(String cmd) {
    setActivatedWidget("");
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
        filepanels[currentFilePanel]
            .setCurrentIndex(filepanels[currentFilePanel].currentIndex - 1);
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (filepanels[currentFilePanel].currentIndex <
          filepanels[currentFilePanel].items.length - 1) {
        filepanels[currentFilePanel]
            .setCurrentIndex(filepanels[currentFilePanel].currentIndex + 1);
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.tab) {
      if (currentFilePanel == 0) {
        currentFilePanel = 1;
      } else {
        currentFilePanel = 0;
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.enter &&
        !event.isAltPressed &&
        !event.isShiftPressed &&
        !event.isControlPressed) {
      if (isFilePanelActivated()) {
        filepanels[currentFilePanel].mainAction();
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.enter &&
        !event.isAltPressed &&
        event.isShiftPressed &&
        event.isControlPressed) {
      if (isFilePanelActivated()) {
        String txt = filepanels[currentFilePanel].selectedFileNameWithPath();
        appendToCommandLine(txt);
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.enter &&
        !event.isAltPressed &&
        !event.isShiftPressed &&
        event.isControlPressed) {
      if (isFilePanelActivated()) {
        String txt = filepanels[currentFilePanel].selectedFileName();
        appendToCommandLine(txt);
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      if (isFilePanelActivated()) {
        filepanels[currentFilePanel].goBack();
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (isFilePanelActivated()) {
        onCommandLineActivate();
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.home) {
      if (isFilePanelActivated()) {
        filepanels[currentFilePanel].keyHome();
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.end) {
      if (isFilePanelActivated()) {
        filepanels[currentFilePanel].keyEnd();
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.pageUp) {
      filepanels[currentFilePanel].keyPageUp();
    }
    if (event.logicalKey == LogicalKeyboardKey.pageDown) {
      filepanels[currentFilePanel].keyPageDown();
    }
    if (event.logicalKey == LogicalKeyboardKey.f6 && event.isShiftPressed) {
      filepanels[currentFilePanel].keyShiftF6();
    }
    notifyChanges();
  }

  void appendToCommandLine(String txt) {
    onCommandLineAppend("$txt ");
  }

  void setCurrentPanelIndex(int panelIndex) {
    currentFilePanel = panelIndex;
    notifyChanges();
  }

  void processFilePanelItem(int panelIndex, int index) {
    setCurrentPanelIndex(panelIndex);
    filepanels[panelIndex].setCurrentIndex(index);
    notifyChanges();
  }
}
