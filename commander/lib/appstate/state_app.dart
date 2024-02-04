import 'package:commander/appstate/state_drives.dart';
import 'package:commander/appstate/state_filepanel.dart';
import 'package:flutter/services.dart';

class StateApp {
  List<StateFilePanel> filepanels = [];
  List<StateDrives> drives = [];
  int currentFilePanel = 0;
  String _activatedWidget = "";

  static const String widgetFilePanel = "";
  static const String widgetCommandLine = "COMMAND_LINE";
  static const String widgetRenameFileField = "RENAME_FILE_FIELD";
  static const String widgetDrives0 = "DRIVES0";
  static const String widgetDrives1 = "DRIVES1";

  static final StateApp _instance = StateApp._internal();

  factory StateApp() {
    return _instance;
  }

  StateApp._internal() {
    filepanels.add(StateFilePanel());
    filepanels[0].panelIndex = 0;
    filepanels.add(StateFilePanel());
    filepanels[1].panelIndex = 1;

    drives.add(StateDrives());
    drives[0].panelIndex = 0;
    drives.add(StateDrives());
    drives[1].panelIndex = 1;
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
    _activatedWidget = activatedWidget;
    if (activatedWidget == widgetFilePanel) {
      onRequestDefaultFocus();
    }
    notifyChanges();
  }

  void renameFilePanelItem() {
    filepanels[currentFilePanel].currentItem().onRenameFieldActivated();
  }

  void renameFilePanelItemCancel() {
    filepanels[currentFilePanel].currentItem().onRenameFieldDeActivated();
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

  bool isDrives0Activated() {
    return _activatedWidget == widgetDrives0;
  }

  bool isDrives1Activated() {
    return _activatedWidget == widgetDrives1;
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

  bool processKeyDown(RawKeyDownEvent event) {
    bool processed = false;
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (isFilePanelActivated()) {
        if (filepanels[currentFilePanel].currentIndex > 0) {
          filepanels[currentFilePanel]
              .setCurrentIndex(filepanels[currentFilePanel].currentIndex - 1);
          processed = true;
        }
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (isFilePanelActivated()) {
        if (filepanels[currentFilePanel].currentIndex <
            filepanels[currentFilePanel].items.length - 1) {
          filepanels[currentFilePanel]
              .setCurrentIndex(filepanels[currentFilePanel].currentIndex + 1);
          processed = true;
        }
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.tab) {
      if (currentFilePanel == 0) {
        currentFilePanel = 1;
        processed = true;
      } else {
        currentFilePanel = 0;
        processed = true;
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.enter &&
        !event.isAltPressed &&
        !event.isShiftPressed &&
        !event.isControlPressed) {
      if (isFilePanelActivated()) {
        filepanels[currentFilePanel].mainAction();
        processed = true;
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.enter &&
        !event.isAltPressed &&
        event.isShiftPressed &&
        event.isControlPressed) {
      if (isFilePanelActivated()) {
        String txt = filepanels[currentFilePanel].selectedFileNameWithPath();
        appendToCommandLine(txt);
        processed = true;
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.enter &&
        !event.isAltPressed &&
        !event.isShiftPressed &&
        event.isControlPressed) {
      if (isFilePanelActivated()) {
        String txt = filepanels[currentFilePanel].selectedFileName();
        appendToCommandLine(txt);
        processed = true;
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      if (isFilePanelActivated()) {
        filepanels[currentFilePanel].goBack();
        processed = true;
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (isFilePanelActivated()) {
        onCommandLineActivate();
        processed = true;
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.home) {
      if (isFilePanelActivated()) {
        filepanels[currentFilePanel].keyHome();
        processed = true;
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.end) {
      if (isFilePanelActivated()) {
        filepanels[currentFilePanel].keyEnd();
        processed = true;
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.pageUp) {
      if (isFilePanelActivated()) {
        filepanels[currentFilePanel].keyPageUp();
        processed = true;
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.pageDown) {
      if (isFilePanelActivated()) {
        filepanels[currentFilePanel].keyPageDown();
        processed = true;
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.f6 && event.isShiftPressed) {
      if (isFilePanelActivated()) {
        filepanels[currentFilePanel].keyShiftF6();
        processed = true;
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.f1 && event.isAltPressed) {
      if (isFilePanelActivated() ||
          isDrives0Activated() ||
          isDrives1Activated()) {
        if (isDrives1Activated()) {
          hideDrives1();
        }
        filepanels[0].keyShowDrives();
        setActivatedWidget(widgetDrives0);
        processed = true;
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.f2 && event.isAltPressed) {
      if (isFilePanelActivated() ||
          isDrives0Activated() ||
          isDrives1Activated()) {
        hideDrives0();
      }
      if (isFilePanelActivated()) {
        filepanels[1].keyShowDrives();
        setActivatedWidget(widgetDrives1);
        processed = true;
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (isCommandLineActivated()) {
        requestDefaultFocus();
        StateApp().requestClearCommandLine();
        processed = true;
      }
      if (isRenameFieldActivated()) {
        requestDefaultFocus();
        processed = true;
      }
      if (isDrives0Activated()) {
        hideDrives0();
        processed = true;
      }
      if (isDrives1Activated()) {
        hideDrives1();
        processed = true;
      }
    }
    notifyChanges();
    return processed;
  }

  void hideDrives0() {
    filepanels[0].keyHideDrives();
    setActivatedWidget(widgetFilePanel);
    requestDefaultFocus();
  }

  void hideDrives1() {
    filepanels[1].keyHideDrives();
    setActivatedWidget(widgetFilePanel);
    requestDefaultFocus();
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
