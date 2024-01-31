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
      focusNode.requestFocus();
    };
    RawKeyboard.instance.addListener(_handleKey);
  }

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      setState(() {
        stateApp.processKeyDown(event);
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
    print("MainForm Build State:");
    return Focus(
      focusNode: focusNode,
      onKey: (node, event) {
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
          OutlinedButton(onPressed: () {}, child: Text("adsda")),
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
      body: buildContent(context),
    );
  }
}
