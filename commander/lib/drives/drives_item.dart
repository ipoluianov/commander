import 'package:flutter/material.dart';

class DrivesItem extends StatefulWidget {
  String item;
  bool selected;
  int index;
  int filePanelIndex;
  Function(int index) onTap;
  Function(int index) onDoubleTap;

  DrivesItem({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
    required this.onDoubleTap,
    required this.index,
    required this.filePanelIndex,
  });

  @override
  State<StatefulWidget> createState() {
    return DrivesItemState();
  }
}

class DrivesItemState extends State<DrivesItem> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.item);
  }
}
