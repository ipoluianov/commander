import 'dart:async';

import 'package:commander/file_info_block/file_info_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../appstate/state_app.dart';
import '../command_line/command_line.dart';
import '../filelist/file_panel.dart';

class MainForm extends StatefulWidget {
  const MainForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return MainFormState();
  }
}

class MainFormState extends State<MainForm> {
  StateApp stateApp = StateApp();

  int _lastStateId = 0;

  @override
  void initState() {
    super.initState();
    StateApp().onUpdate = () {
      setState(() {});
    };
    StateApp().onRequestDefaultFocus = () {
      Timer.run(() {
        focusNode.requestFocus();
      });
    };
    RawKeyboard.instance.addListener(_handleKey);
  }

  bool processedLastKey = false;

  void _handleKey(RawKeyEvent event) {
    //print("_handleKey ${event.logicalKey}");

    if (event is RawKeyDownEvent) {
      setState(() {
        processedLastKey = stateApp.processKeyDown(event);
      });
    }
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKey);
    super.dispose();
  }

  FocusNode focusNode = FocusNode();

  Widget buildContent(BuildContext context) {
    //print("MainForm Build State:");
    return Focus(
      focusNode: focusNode,
      onKey: (node, event) {
        if (processedLastKey) return KeyEventResult.handled;
        return KeyEventResult.ignored;

        print("onKey ${event.logicalKey}");
        if (StateApp().isRenameFieldActivated()) {
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            focusNode.requestFocus();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        }
        if (StateApp().isCommandLineActivated()) {
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            focusNode.requestFocus();
            StateApp().requestClearCommandLine();
            return KeyEventResult.handled;
          }
          Set<LogicalKeyboardKey> notAllowedForCommandLine = {};
          notAllowedForCommandLine.add(LogicalKeyboardKey.arrowUp);
          notAllowedForCommandLine.add(LogicalKeyboardKey.arrowDown);
          if (notAllowedForCommandLine.contains(event.logicalKey)) {
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        }
        return KeyEventResult.handled;
      },
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: FilePanel(
                          panelIndex: 0,
                        ),
                      ),
                      FileInfoBlock(
                        panelIndex: 0,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: FilePanel(
                          panelIndex: 1,
                        ),
                      ),
                      FileInfoBlock(
                        panelIndex: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            child: CommandLine(),
          ),
          Text(StateApp().activatedWidget()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Container(
          color: Colors.white12,
          child: buildContent(context),
        ),
      ),
    );
  }
}
