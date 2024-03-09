import 'package:flutter/material.dart';

import '../appstate/state_app.dart';
import '../appstate/state_filepanel.dart';

class FileListHeader extends StatefulWidget {
  final int panelIndex;

  const FileListHeader({
    super.key,
    required this.panelIndex,
  });
  @override
  State<StatefulWidget> createState() {
    return FileListHeaderState();
  }
}

class FileListHeaderState extends State<FileListHeader> {
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
        const TextStyle(fontSize: 16, overflow: TextOverflow.clip);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 40,
          //color: Colors.white10,
          decoration: const BoxDecoration(
            color: Colors.white10,
            border: Border(
              top: BorderSide(
                color: Colors.white10,
                width: 1,
              ),
              right: BorderSide(
                color: Colors.white30,
                width: 1,
              ),
            ),
          ),
          //height: 20,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FittedBox(
              alignment: Alignment.centerLeft,
              child: Text(
                StateApp().filepanels[widget.panelIndex].currentPathString(),
                style: style,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
