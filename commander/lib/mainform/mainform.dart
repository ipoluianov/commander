import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../appstate/state_app.dart';
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
          return KeyEventResult.handled;
        },
        child: Row(
          children: [
            Expanded(
              child: FilePanel(
                panelIndex: 0,
              ),
            ),
            Expanded(
              child: FilePanel(
                panelIndex: 1,
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildContent(context),
    );
  }
}
