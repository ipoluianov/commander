import 'package:flutter/material.dart';

import '../appstate/state_app.dart';
import '../appstate/state_filepanel.dart';

class FileInfoBlock extends StatefulWidget {
  final int panelIndex;

  const FileInfoBlock({
    super.key,
    required this.panelIndex,
  });
  @override
  State<StatefulWidget> createState() {
    return FileInfoBlockState();
  }
}

class FileInfoBlockState extends State<FileInfoBlock> {
  late StateFilePanel state;
  @override
  void initState() {
    super.initState();
    state = StateApp().filepanels[widget.panelIndex];
  }

  String trim(String text, int count) {
    if (count >= text.length) {
      return text;
    }
    return "${text.substring(0, count - 3)}...";
  }

  @override
  Widget build(BuildContext context) {
    var item = state.currentItem();

    TextStyle style =
        const TextStyle(fontSize: 10, overflow: TextOverflow.clip);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 210,
          child: Text(
            "File Path: ${trim(item.fileName, 30)}",
            style: style,
            softWrap: false,
          ),
        ),
        Text(
          "Linked to: ${trim(item.linkTarget, 30)}",
          style: style,
        ),
        Text(
          "Owner: ${trim(item.owner, 30)}",
          style: style,
        ),
      ],
    );
  }
}
