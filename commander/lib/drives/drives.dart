import 'package:commander/appstate/state_app.dart';
import 'package:commander/appstate/state_drives.dart';
import 'package:flutter/material.dart';

import 'drives_item.dart';

class Drives extends StatefulWidget {
  final int panelIndex;
  final double width;
  final double height;
  const Drives(
      {super.key,
      required this.panelIndex,
      required this.width,
      required this.height});

  @override
  State<StatefulWidget> createState() {
    return DrivesState();
  }
}

class DrivesState extends State<Drives> {
  late StateDrives state;
  @override
  void initState() {
    super.initState();
    state = StateApp().drives[widget.panelIndex];
  }

  @override
  void dispose() {
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  Widget buildItem(BuildContext context, int index, dynamic item) {
    bool selected = false;
    //print("CFP: ${StateApp().currentFilePanel} ${widget.panelIndex}");
    if (StateApp().currentFilePanel == widget.panelIndex) {
      if (index == state.currentIndex) {
        selected = true;
      }
    }
    return SizedBox(
      height: 20,
      child: DrivesItem(
        key: Key("drives_" + item.toString() + widget.panelIndex.toString()),
        index: index,
        filePanelIndex: widget.panelIndex,
        item: item,
        selected: selected,
        onTap: (index) {
          setState(() {
            //StateApp().processFilePanelItem(widget.panelIndex, index);
          });
        },
        onDoubleTap: (index) {
          setState(() {
            //StateApp().processFilePanelItem(widget.panelIndex, index);
            //state.mainAction();
          });
        },
      ),
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
    return SizedBox(
      width: widget.width / 2,
      height: widget.height / 2,
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.white30, width: 1)),
        child: ListView(
          controller: _scrollController,
          children: buildItems(context),
        ),
      ),
    );
  }
}
