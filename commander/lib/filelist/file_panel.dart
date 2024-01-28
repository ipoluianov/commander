import 'dart:async';

import 'package:commander/appstate/state_filepanel.dart';
import 'package:flutter/material.dart';

import '../appstate/state_app.dart';
import 'file_panel_item.dart';

class FilePanel extends StatefulWidget {
  final int panelIndex;
  const FilePanel({super.key, required this.panelIndex});

  @override
  State<StatefulWidget> createState() {
    return FilePanelState();
  }
}

class FilePanelState extends State<FilePanel> {
  late StateFilePanel state;

  @override
  void initState() {
    super.initState();
    state = StateApp().filepanels[widget.panelIndex];
    Timer.run(() {
      state.load(0);
    });
  }

  Widget buildItem(BuildContext context, int index, dynamic item) {
    bool selected = false;
    //print("CFP: ${StateApp().currentFilePanel} ${widget.panelIndex}");
    if (StateApp().currentFilePanel == widget.panelIndex) {
      if (index == state.currentIndex) {
        selected = true;
      }
    }
    return FilelistItem(
      index: index,
      fileName: item.fileName,
      selected: selected,
      isDir: item.isDir,
      onTap: (index) {
        setState(() {
          StateApp().processFilePanelItem(widget.panelIndex, index);
        });
      },
    );
  }

  List<Widget> buildItems(BuildContext context) {
    List<Widget> res = [];
    int index = 0;
    for (var item in state.items) {
      res.add(buildItem(context, index, item));
      index++;
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.white30, width: 1)),
      child: ListView(
        children: buildItems(context),
      ),
    );
  }
}
